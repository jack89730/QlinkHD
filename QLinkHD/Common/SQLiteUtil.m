//
//  SQLiteUtil.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "SQLiteUtil.h"
#import "FMDatabase.h"

@implementation SQLiteUtil

//获取数据库对象
+(FMDatabase *)getDB
{
    NSString *dbPath = [[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:DBNAME];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    return db;
}

//中控信息sql
+(NSString *)connectControlSql:(Control *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO CONTROL (\"Ip\", \"SendType\", \"Port\", \"Domain\", \"Url\", \"Updatever\",\"Jsname\",\"Jstel\",\"Jsuname\",\"Jsaddess\", \"Jslogo\",\"JslogoIpad\", \"Jsqq\",\"OpenPic\",\"OpenPicIpad\") VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",obj.Ip, obj.SendType, obj.Port, obj.Domain, obj.Url, obj.Updatever,obj.Jsname,obj.Jstel,obj.Jsuname,obj.Jsaddess,obj.Jslogo,obj.JslogoIpad,obj.Jsqq,obj.OpenPic,obj.OpenPicIpad];
    
    return sql;
}

//设备表sql拼接
+(NSString *)connectDeviceSql:(Device *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO DEVICE (\"DeviceId\" , \"DeviceName\" , \"Type\" , \"HouseId\" , \"LayerId\" , \"RoomId\") VALUES (\"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\")",obj.DeviceId, obj.DeviceName,obj.Type, obj.HouseId, obj.LayerId, obj.RoomId];
    return sql;
}

//命令表sql拼接
+(NSString *)connectOrderSql:(Order *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO ORDERS (\"OrderId\", \"OrderName\", \"Type\", \"SubType\" , \"OrderCmd\", \"Address\", \"StudyCmd\",\"OrderNo\", \"HouseId\", \"LayerId\", \"RoomId\", \"DeviceId\",\"Hora\") VALUES  (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\" , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",obj.OrderId, obj.OrderName,obj.Type, obj.SubType , obj.OrderCmd,obj.Address, obj.StudyCmd,obj.OrderNo, obj.HouseId, obj.LayerId, obj.RoomId, obj.DeviceId,obj.Hora];
    return sql;
}

//房间表sql拼接
+(NSString *)connectRoomSql:(Room *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO ROOM (\"RoomId\", \"RoomName\", \"HouseId\", \"LayerId\") VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",obj.RoomId,obj.RoomName,obj.HouseId, obj.LayerId];
    return sql;
}

//场景表sql拼接
+(NSString *)connectSenceSql:(Sence *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO SENCE (\"SenceId\" , \"SenceName\" , \"Macrocmd\" , \"Type\" , \"CmdList\" , \"HouseId\" , \"LayerId\" , \"RoomId\") VALUES (\"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\")",obj.SenceId,obj.SenceName,obj.Macrocmd, obj.Type,obj.CmdList, obj.HouseId,obj.LayerId,obj.RoomId];
    return sql;
}

//获取当前版本号
+(NSString *)getCurVersionNo
{
    FMDatabase *db = [self getDB];
    
    NSString *versionNo = @"";
    NSString *sql = @"SELECT UPDATEVER FROM CONTROL LIMIT 1";
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            versionNo = [rs stringForColumn:@"Updatever"];
            
            break;
        }
        
        [rs close];
    }
    
    [db close];
    
    return versionNo;
}

//获取设置当前默认楼层和房间号码
+(void)setDefaultLayerIdAndRoomId
{
    FMDatabase *db = [self getDB];
    
    NSString *sql = @"SELECT MIN(LAYERID) AS LayerId,ROOMID,HOUSEID FROM (SELECT RoomId,LayerId,HouseId FROM ROOM GROUP BY LAYERID ORDER BY LAYERID ASC)";
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[DataUtil getDefaultValue:[rs stringForColumn:@"LayerId"]] forKey:@"LayerId"];
            [dic setObject:[DataUtil getDefaultValue:[rs stringForColumn:@"RoomId"]] forKey:@"RoomId"];
            [dic setObject:[DataUtil getDefaultValue:[rs stringForColumn:@"HouseId"]] forKey:@"HouseId"];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:dic forKey:Global_Room_Attr];
            [ud synchronize];
            
            break;
        }
        
        [rs close];
    }
    
    [db close];
}

#pragma mark - 楼层

//TODO:获取所有楼层
+(NSMutableArray *)getLayerList
{
    NSMutableArray *layerArr = [NSMutableArray array];
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = @"SELECT LayerId,HouseId FROM ROOM GROUP BY LAYERID ORDER BY LAYERID ASC";
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Layer *obj = [[Layer alloc] init];
            obj.LayerId = [rs stringForColumn:@"LayerId"];
            obj.HouseId = [rs stringForColumn:@"HouseId"];
            
            [layerArr addObject:obj];
            break;
        }
        
        [rs close];
    }
    
    [db close];
    
    return layerArr;
}

//获取房间列表
+(NSArray *)getRoomList:(NSString *)houseId
             andLayerId:(NSString *)layerId
{
    NSMutableArray *roomArr = [NSMutableArray array];
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ROOM WHERE HOUSEID='%@' AND LAYERID='%@'",houseId,layerId];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Room *obj = [Room setRoomId:[rs stringForColumn:@"RoomId"]
                            andRoomName:[rs stringForColumn:@"RoomName"]
                             andHouseId:[rs stringForColumn:@"HouseId"]
                             andLayerId:[rs stringForColumn:@"LayerId"]];
            [roomArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    Room *obj = [Room setRoomId:@""
                    andRoomName:@"返回楼层"
                     andHouseId:@""
                     andLayerId:@""];
    [roomArr addObject:obj];
    
    return roomArr;
}

//清除数据
+(void)clearData
{
    FMDatabase *db = [self getDB];
    
    [db open];
    
    [db executeUpdate:@"DELETE FROM CONTROL"];
    [db executeUpdate:@"DELETE FROM DEVICE"];
    [db executeUpdate:@"DELETE FROM ORDERS"];
    [db executeUpdate:@"DELETE FROM ROOM"];
    [db executeUpdate:@"DELETE FROM SENCE"];
    
    [db close];
    
    //删除文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *logoPath = [[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:@"logo.png"];
    NSString *defaultPath = [[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:@"help.png"];
    [fileManager removeItemAtPath:logoPath error:&error];
    [fileManager removeItemAtPath:defaultPath error:&error];
}

//执行sql语句事物
+(BOOL)handleConfigToDataBase:(NSArray *)sqlArr
{
    FMDatabase *db = [self getDB];
    
    [db open];
    BOOL bResult = [self addToDataBase:db andSQL:sqlArr];
    [db close];
    
    return bResult;
}

//执行添加
+(BOOL)addToDataBase:(FMDatabase *)db andSQL:(NSArray *)sqlArr
{
    BOOL bResult = FALSE;
    
    [db beginTransaction];
    
    for (NSString *sql in sqlArr) {
        bResult = [db executeUpdate:sql];
    }
    
    [db commit];
    
    return bResult;
}

+(NSArray *)getDeviceHasAr:(NSString *)houseId
                andLayerId:(NSString *)layerId
                 andRoomId:(NSString *)roomId
{
    NSMutableArray *deviceArr = [NSMutableArray array];
    NSMutableArray *iconArr = [DataUtil getIconList:IconTypeAll];
    
    FMDatabase *db = [self getDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT distinct(d.deviceid),d.deviceName,d.Type,i.NewType FROM Device d LEFT JOIN Orders o ON d.DeviceId = o.DeviceId LEFT JOIN ICON i ON d.DeviceId=i.DeviceId  WHERE o.type = 'ar' and o.HouseId='%@' and o.LayerId='%@' and o.RoomId='%@'",houseId,layerId,roomId];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            NSString *type = [rs stringForColumn:@"NewType"];
            if ([DataUtil checkNullOrEmpty:type]) {
                type = [rs stringForColumn:@"Type"];
            }
            if (![iconArr containsObject:type]) {
                type = @"other";
            }
            
            Device *device = [[Device alloc] init];
            device.DeviceId = [rs stringForColumn:@"DeviceId"];
            device.DeviceName = [rs stringForColumn:@"DeviceName"];
            device.Type = [rs stringForColumn:@"Type"];
            device.IconType =  type;
            
            [deviceArr addObject:device];
        }
        [rs close];
    }
    [db close];
    
    return deviceArr;
}

//获取场景列表
+(NSArray *)getSenceList:(NSString *)houseId
              andLayerId:(NSString *)layerId
               andRoomId:(NSString *)roomId
{
    NSMutableArray *senceArr = [NSMutableArray array];
    NSMutableArray *iconArr = [DataUtil getIconList:IconTypeAll];
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT S.*,I.NewType FROM SENCE S LEFT JOIN ICON I ON S.SENCEID=I.DEVICEID AND I.TYPE='macro' WHERE S.HOUSEID='%@' AND S.LAYERID='%@' AND S.ROOMID='%@'",houseId,layerId,roomId];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            NSString *type = [rs stringForColumn:@"NewType"];
            if ([DataUtil checkNullOrEmpty:type]) {
                type = [rs stringForColumn:@"Type"];
            }
            if (![iconArr containsObject:type]) {
                type = @"other";
            }
            
            Sence *obj = [Sence setSenceId:[rs stringForColumn:@"SenceId"]
                              andSenceName:[rs stringForColumn:@"SenceName"]
                               andMacrocmd:[rs stringForColumn:@"Macrocmd"]
                                   andType:[rs stringForColumn:@"Type"]
                                andCmdList:[rs stringForColumn:@"CmdList"]
                                andHouseId:[rs stringForColumn:@"HouseId"]
                                andLayerId:[rs stringForColumn:@"LayerId"]
                                 andRoomId:[rs stringForColumn:@"RoomId"]
                               andIconType:type];
            [senceArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    //add图标
    Sence *senceObj = [[Sence alloc] init];
    senceObj.Type = add_oper;
    senceObj.SenceName = @"添加场景";
    senceObj.IconType = add_oper;
    [senceArr addObject:senceObj];
    
    return senceArr;
}

//是否存在某个场景
+(BOOL)isHasSence:(NSString *)houseId
              andLayerId:(NSString *)layerId
               andRoomId:(NSString *)roomId
              andSenceId:(NSString *)senceId
{
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM SENCE WHERE HOUSEID='%@' AND LAYERID='%@' AND ROOMID='%@' and SenceId='%@'",houseId,layerId,roomId,senceId];
    
    BOOL isHas = NO;
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            int totalCount = [rs intForColumnIndex:0];
            if (totalCount > 0) {
                isHas = YES;
            }
        }
        [rs close];
    }

    [db close];

    return isHas;
}

//获取具体场景命令集合，用于紧急模式下发送
+(NSMutableArray *)getOrderBySenceId:(NSString *)senceId
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT SENCEID, SENCENAME, CMDLIST FROM SENCE WHERE SENCEID='%@'",senceId];
    
    Sence *obj = [[Sence alloc] init];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]){
            obj.SenceId = [rs stringForColumn:@"SenceId"];
            obj.SenceName = [rs stringForColumn:@"SenceName"];
            obj.CmdList = [rs stringForColumn:@"CmdList"];
        }
        
        [rs close];
        
        NSArray *cmdListArr = [obj.CmdList componentsSeparatedByString:@"|"];
        NSArray *orderIdArr = [[cmdListArr objectAtIndex:0] componentsSeparatedByString:@","];
        NSArray *timerArr = [[cmdListArr objectAtIndex:1] componentsSeparatedByString:@","];
        
        for (int i = 0; i < [orderIdArr count];i ++) {
            NSString *subSql = [NSString stringWithFormat:@"SELECT O.ORDERID,O.ORDERNAME,O.ORDERCMD,O.ADDRESS,D.DEVICEID,D.DEVICENAME,D.TYPE,I.NEWTYPE FROM ORDERS O LEFT JOIN DEVICE D ON O.DEVICEID=D.DEVICEID  LEFT JOIN ICON I ON O.DEVICEID=I.DEVICEID  WHERE O.ORDERID='%@'",[orderIdArr objectAtIndex:i]];
            FMResultSet *rs = [db executeQuery:subSql];
            if ([rs next])
            {
                Sence *subobj = [[Sence alloc] init];
                subobj.SenceId = [rs stringForColumn:@"DeviceId"];
                subobj.OrderId = [rs stringForColumn:@"OrderId"];
                subobj.OrderCmd = [rs stringForColumn:@"OrderCmd"];
                subobj.Address = [rs stringForColumn:@"Address"];
                subobj.SenceName = [rs stringForColumn:@"DeviceName"];
                subobj.OrderName = [rs stringForColumn:@"OrderName"];
                subobj.Type = [rs stringForColumn:@"Type"];
                subobj.IconType = [rs stringForColumn:@"NewType"];
                subobj.Timer = [timerArr objectAtIndex:i];
                [orderArr addObject:subobj];
            }
            
            [rs close];
        }
    }
    
    [db close];
    
    return orderArr;
}

//更新场景下命令和时间
+(BOOL)updateCmdListBySenceId:(NSString *)senceId andSenceName:(NSString *)senceName andCmdList:(NSString *)cmdLists
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE SENCE SET CMDLIST='%@' , SENCENAME='%@' WHERE SENCEID='%@'",cmdLists,senceName,senceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//添加场景
+(BOOL)insertSence:(Sence *)obj
{
    GlobalAttr *globalAttr = [DataUtil shareInstanceToRoom];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO SENCE (SENCEID,SENCENAME,MACROCMD,TYPE,CMDLIST,HOUSEID,LAYERID,ROOMID) VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",obj.SenceId,obj.SenceName,obj.Macrocmd,@"macro",obj.CmdList,globalAttr.HouseId,globalAttr.LayerId,globalAttr.RoomId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取设备列表
+(NSArray *)getDeviceList:(NSString *)houseId
               andLayerId:(NSString *)layerId
                andRoomId:(NSString *)roomId
{
    NSMutableArray *iconArr = [DataUtil getIconList:IconTypeAll];
    
    NSMutableArray *deviceArr = [NSMutableArray array];
    
    FMDatabase *db = [self getDB];
    
    NSString *lightKeyWord = @"%light%";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT D.*,I.NewType FROM DEVICE D LEFT JOIN ICON I ON D.DEVICEID=I.DEVICEID AND I.TYPE !='%@' WHERE D.HOUSEID='%@' AND D.LAYERID='%@' AND D.ROOMID='%@' AND D.TYPE NOT LIKE '%@'",MACRO,houseId,layerId,roomId,lightKeyWord];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            NSString *type = [rs stringForColumn:@"NewType"];
            if ([DataUtil checkNullOrEmpty:type]) {
                type = [rs stringForColumn:@"Type"];
            }
            if (![iconArr containsObject:type]) {
                type = @"other";
            }
            
            Device *obj = [Device setDeviceId:[rs stringForColumn:@"DeviceId"]
                                andDeviceName:[rs stringForColumn:@"DeviceName"]
                                      andType:[rs stringForColumn:@"Type"]
                                   andHouseId:[rs stringForColumn:@"HouseId"]
                                   andLayerId:[rs stringForColumn:@"LayerId"]
                                    andRoomId:[rs stringForColumn:@"RoomId"]
                                  andIconType:type];
            [deviceArr addObject:obj];
        }
        
        [rs close];
    }
    
    sql = @"SELECT COUNT(*) FROM DEVICE WHERE TYPE LIKE '%light%'";
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            int totalCount = [rs intForColumnIndex:0];
            if (totalCount > 0) {
                Device *obj = [Device setDeviceId:@""
                                    andDeviceName:@"照明"
                                          andType:@"light"
                                       andHouseId:@""
                                       andLayerId:@""
                                        andRoomId:@""
                                      andIconType:@"light"];
                [deviceArr addObject:obj];
            }
        }
        [rs close];
    }
    
    [db close];
    
    //add图标
    Device *deviceObj = [[Device alloc] init];
    deviceObj.Type = add_oper;
    deviceObj.DeviceName = @"添加设备";
    deviceObj.IconType = add_oper;
    [deviceArr addObject:deviceObj];
    
    return deviceArr;
}

//更新图标
+(BOOL)changeIcon:(NSString *)deviceId
          andType:(NSString *)type
       andNewType:(NSString *)newType
{
    BOOL bResult = FALSE;
    
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO ICON (DEVICEID,TYPE,NEWTYPE) VALUES ('%@','%@','%@')",deviceId,type,newType];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        bResult = [db executeUpdate:sql];
    }
    
    [db close];
    
    return bResult;
}

//重命名场景
+(BOOL)renameSenceName:(NSString *)senceId
            andNewName:(NSString *)newName
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE SENCE SET SENCENAME='%@' WHERE SENCEID='%@'",newName,senceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//重命名设备
+(BOOL)renameDeviceName:(NSString *)deviceId
             andNewName:(NSString *)newName
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE DEVICE SET DEVICENAME='%@' WHERE DEVICEID='%@'",newName,deviceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//删除场景
+(BOOL)removeSence:(NSString *)senceId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM SENCE WHERE SENCEID='%@'",senceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//删除设备
+(BOOL)removeDevice:(NSString *)deviceId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM DEVICE WHERE DEVICEID='%@'",deviceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//添加本地音量控制设备
+(BOOL)addDeviceHasArToLocal:(NSString *)deviceId
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO DeviceArLocal (DEVICEID) VALUES ('%@')",deviceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//删除本地音量控制设备
+(BOOL)deleteDeviceHasArToLocal:(NSString *)deviceId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM DeviceArLocal WHERE DEVICEID='%@'",deviceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

+(NSArray *)getDeviceHasArLocal
{
    NSArray *iconArr = [DataUtil getDeviceArLocalIconList];
    NSMutableArray *deviceArr = [NSMutableArray array];
    NSString *sql = @"SELECT dl.DeviceId,d.Type FROM DeviceArLocal dl LEFT JOIN Device d ON dl.DeviceId = d.DeviceId";
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Device *obj = [[Device alloc] init];
            obj.DeviceId = [rs stringForColumn:@"DeviceId"];
            obj.IconType = [rs stringForColumn:@"Type"];
            if (![iconArr containsObject:obj.IconType]) {
                obj.IconType = @"other";
            }
            [deviceArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    if (deviceArr.count < 8) {
        Device *obj = [[Device alloc] init];
        obj.DeviceId = @"";
        obj.IconType = add_oper_localAr;
        [deviceArr addObject:obj];
    }
    
    return deviceArr;
}

//获取该设备下所有命令类型
+(NSArray *)getOrderTypeGroupOrder:(NSString *)deviceId
{
    NSMutableArray *typeArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT DEVICEID,TYPE FROM ORDERS WHERE DEVICEID='%@' GROUP BY TYPE ORDER BY CAST(ORDERNO AS INT) ASC",deviceId];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Order *obj = [[Order alloc] init];
            obj.DeviceId = [rs stringForColumn:@"DeviceId"];
            obj.Type = [rs stringForColumn:@"Type"];
            [typeArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return typeArr;
}

//获取指定音量设备下指定类型的命令集合
+(NSArray *)getArOrderListByDeviceId:(NSString *)deviceId
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ORDERS WHERE DEVICEID='%@' AND TYPE='ar' and SubType in ('ad','rd')",deviceId];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Order *obj = [Order setOrderId:[rs stringForColumn:@"OrderId"]
                              andOrderName:[rs stringForColumn:@"OrderName"]
                                   andType:[rs stringForColumn:@"Type"]
                                andSubType:[rs stringForColumn:@"SubType"]
                               andOrderCmd:[rs stringForColumn:@"OrderCmd"]
                                andAddress:[rs stringForColumn:@"Address"]
                               andStudyCmd:[rs stringForColumn:@"StudyCmd"]
                                andOrderNo:[rs stringForColumn:@"OrderNo"]
                                andHouseId:[rs stringForColumn:@"HouseId"]
                                andLayerId:[rs stringForColumn:@"LayerId"]
                                 andRoomId:[rs stringForColumn:@"RoomId"]
                               andDeviceId:[rs stringForColumn:@"DeviceId"]
                                   andHora:[rs stringForColumn:@"Hora"]];
            [orderArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return orderArr;
}

//获取指定设备下指定类型的命令集合,用于非照明设备命令查询
+(NSArray *)getOrderListByDeviceId:(NSString *)deviceId andType:(NSString *)type
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ORDERS WHERE DEVICEID='%@' AND TYPE='%@' ORDER BY SUBTYPE ASC",deviceId,type];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Order *obj = [Order setOrderId:[rs stringForColumn:@"OrderId"]
                              andOrderName:[rs stringForColumn:@"OrderName"]
                                   andType:[rs stringForColumn:@"Type"]
                                andSubType:[rs stringForColumn:@"SubType"]
                               andOrderCmd:[rs stringForColumn:@"OrderCmd"]
                                andAddress:[rs stringForColumn:@"Address"]
                               andStudyCmd:[rs stringForColumn:@"StudyCmd"]
                                andOrderNo:[rs stringForColumn:@"OrderNo"]
                                andHouseId:[rs stringForColumn:@"HouseId"]
                                andLayerId:[rs stringForColumn:@"LayerId"]
                                 andRoomId:[rs stringForColumn:@"RoomId"]
                               andDeviceId:[rs stringForColumn:@"DeviceId"]
                                   andHora:[rs stringForColumn:@"Hora"]];
            [orderArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return orderArr;
}

//获取指定设备下指定类型的命令集合,用于照明设备命令查询
+(NSArray *)getOrderListByDeviceId:(NSString *)deviceId
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ORDERS WHERE DEVICEID='%@' ORDER BY SUBTYPE ASC",deviceId];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Order *obj = [Order setOrderId:[rs stringForColumn:@"OrderId"]
                              andOrderName:[rs stringForColumn:@"OrderName"]
                                   andType:[rs stringForColumn:@"Type"]
                                andSubType:[rs stringForColumn:@"SubType"]
                               andOrderCmd:[rs stringForColumn:@"OrderCmd"]
                                andAddress:[rs stringForColumn:@"Address"]
                               andStudyCmd:[rs stringForColumn:@"StudyCmd"]
                                andOrderNo:[rs stringForColumn:@"OrderNo"]
                                andHouseId:[rs stringForColumn:@"HouseId"]
                                andLayerId:[rs stringForColumn:@"LayerId"]
                                 andRoomId:[rs stringForColumn:@"RoomId"]
                               andDeviceId:[rs stringForColumn:@"DeviceId"]
                                   andHora:[rs stringForColumn:@"Hora"]];
            [orderArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return orderArr;
}

//获取当前房间下所有的照明设备
+(NSArray *)getLightDevice:(NSString *)houseId
                andLayerId:(NSString *)layerId
                 andRoomId:(NSString *)roomId
{
    NSMutableArray *deviceArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT DeviceId,DeviceName,Type FROM DEVICE WHERE TYPE IN ('light','light_1','light_check') AND HOUSEID='%@' AND LAYERID='%@' AND ROOMID='%@' ORDER BY TYPE ASC",houseId,layerId,roomId];
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            Device *obj = [[Device alloc] init];
            obj.DeviceId = [rs stringForColumn:@"DeviceId"];
            obj.DeviceName = [rs stringForColumn:@"DeviceName"];
            obj.Type = [rs stringForColumn:@"Type"];
            
            [deviceArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return deviceArr;
}

//获取当前房间下所有的照明设备(除了type＝‘light’)，考虑到先加载type＝‘light’的照明控件，所以分开取数据
+(NSArray *)getLightComplexDevice:(NSString *)houseId
                       andLayerId:(NSString *)layerId
                        andRoomId:(NSString *)roomId
{
    NSMutableArray *deviceArr = [NSMutableArray array];
    
    NSString *keyWord = @"%light%";
    NSString *sql = [NSString stringWithFormat:@"SELECT DeviceId,DeviceName,Type FROM DEVICE WHERE TYPE LIKE '%@' AND HOUSEID='%@' AND LAYERID='%@' AND ROOMID='%@' AND TYPE NOT IN ('light','light_1','light_check') ORDER BY TYPE ASC",keyWord,houseId,layerId,roomId];
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            Device *obj = [[Device alloc] init];
            obj.DeviceId = [rs stringForColumn:@"DeviceId"];
            obj.DeviceName = [rs stringForColumn:@"DeviceName"];
            obj.Type = [rs stringForColumn:@"Type"];
            
            [deviceArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return deviceArr;
}

//添加命令到购物车表，用于构建场景
+(BOOL)addOrderToShoppingCar:(NSString *)orderId andDeviceId:(NSString *)deviceId
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO SHOPPINGCAR (ORDERID,DEVICEID,TIMER) VALUES ('%@','%@','%@')",orderId,deviceId,@"20"];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取购物车里的命令
+(NSMutableArray *)getShoppingCarOrder
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    NSString *sql = @"SELECT S.ORDERID,S.DEVICEID,O.ORDERNAME,D.DEVICENAME,D.TYPE,I.NEWTYPE,S.TIMER FROM SHOPPINGCAR S LEFT JOIN ORDERS O ON S.ORDERID=O.ORDERID LEFT JOIN DEVICE D ON S.DEVICEID=D.DEVICEID LEFT JOIN ICON I ON S.DEVICEID=I.DEVICEID";
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            Sence *obj = [[Sence alloc] init];
            obj.SenceId = [rs stringForColumn:@"DeviceId"];
            obj.OrderId = [rs stringForColumn:@"OrderId"];
            obj.SenceName = [rs stringForColumn:@"DeviceName"];
            obj.OrderName = [rs stringForColumn:@"OrderName"];
            obj.Type = [rs stringForColumn:@"Type"];
            obj.IconType = [rs stringForColumn:@"NewType"];
            obj.Timer = [rs stringForColumn:@"Timer"];
            [orderArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return orderArr;
}

//更新场景的时间间隔
+(BOOL)updateShoppingCarTimer:(NSString *)orderId andDeviceId:(NSString *)deviceId andTimer:(NSString *)timer
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE SHOPPINGCAR SET TIMER='%@' WHERE DEVICEID='%@' AND ORDERID='%@'",timer,deviceId,orderId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//删除所有添加的场景命令
+(BOOL)removeShoppingCar
{
    NSString *sql = @"DELETE FROM SHOPPINGCAR";
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取购物车数量
+(int)getShoppingCarCount
{
    int totalCount = 0;
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = @"SELECT COUNT(*) FROM SHOPPINGCAR";
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            totalCount = [rs intForColumnIndex:0];
        }
    }
    
    [db close];
    
    return totalCount;
}

//移除购物车的某条命令
+(BOOL)removeShoppingCarByOrderId:(NSString *)orderId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM SHOPPINGCAR WHERE ORDERID='%@'",orderId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取全局配置信息
+(Control *)getControlObj
{
    FMDatabase *db = [self getDB];
    Control *obj = nil;
    NSString *sql = @"SELECT * FROM Control";
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            obj = [Control setIp:[rs stringForColumn:@"Ip"]
                     andSendType:[rs stringForColumn:@"SendType"]
                         andPort:[rs stringForColumn:@"Port"]
                       andDomain:[rs stringForColumn:@"Domain"]
                          andUrl:[rs stringForColumn:@"Url"]
                    andUpdatever:[rs stringForColumn:@"Updatever"]
                   andJsname:[rs stringForColumn:@"Jsname"]
                        andJstel:[rs stringForColumn:@"Jstel"]
                      andJsuname:[rs stringForColumn:@"Jsuname"]
                     andJsaddess:[rs stringForColumn:@"Jsaddess"]
                       andJslogo:[rs stringForColumn:@"Jslogo"]
                   andJslogoIpad:[rs stringForColumn:@"JslogoIpad"]
                         andJsqq:[rs stringForColumn:@"Jsqq"]
                      andOpenPic:[rs stringForColumn:@"OpenPic"]
                   andOpenPicIpad:[rs stringForColumn:@"OpenPicIpad"]];
        }
    }
    
    [db close];
    
    return obj;
}

//当前设备是否有学习模式
+(BOOL)isStudyModel:(NSString *)deviceId
{
    BOOL isResult = NO;
    int totalCount = 0;
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"select count(studycmd) from Orders where deviceid='%@' and studycmd<>''",deviceId];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            totalCount = [rs intForColumnIndex:0];
        }
    }
    
    [db close];
    
    if (totalCount > 0) {
        isResult = YES;
    }
    
    return isResult;
}

//更改设备Order命令
+(BOOL)updateDeviceOrder:(NSString *)orderId
              andAddress:(NSString *)address
             andOrderCmd:(NSString *)orderCmd
                 andHora:(NSString *)hora
{
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    NSString *sql = [NSString stringWithFormat:@"UPDATE ORDERS SET Address='%@', orderCmd='%@',Hora='%@' where OrderId='%@' and HouseId='%@' and LayerId='%@' and Roomid='%@'",address,orderCmd,hora,orderId,obj.HouseId,obj.LayerId,obj.RoomId];
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
    
}

@end

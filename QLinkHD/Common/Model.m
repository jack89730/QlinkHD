//
//  Model.m
//  QLink
//
//  Created by 尤日华 on 14-9-21.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "Model.h"
#import "DataUtil.h"

/******************************TODO:GlobalAttr**************************************/

@implementation GlobalAttr

@end

/******************************TODO:Control**************************************/

@implementation Control

+(Control *)setIp:(NSString *)ip
      andSendType:(NSString *)sendType
          andPort:(NSString *)port
        andDomain:(NSString *)domain
           andUrl:(NSString *)url
     andUpdatever:(NSString *)updatever
        andJsname:(NSString *)jsname
         andJstel:(NSString *)jstel
       andJsuname:(NSString *)jsuname
      andJsaddess:(NSString *)jsaddess
        andJslogo:(NSString *)jslogo
    andJslogoIpad:(NSString *)jslogoIpad
          andJsqq:(NSString *)jsqq
       andOpenPic:(NSString *)openPic
       andOpenPicIpad:(NSString *)openPicIpad;
{
    Control *obj = [[Control alloc] init];
    obj.Ip = ip;
    obj.SendType = sendType;
    obj.Port = port;
    obj.Domain = domain;
    obj.Url = url;
    obj.Updatever = updatever;
    obj.Jsname = jsname;
    obj.Jstel = jstel;
    obj.Jsuname = jsuname;
    obj.Jsaddess = jsaddess;
    obj.Jslogo = jslogo;
    obj.JslogoIpad = jslogoIpad;
    obj.Jsqq = jsqq;
    obj.OpenPic = openPic;
    obj.OpenPicIpad = openPicIpad;
    return obj;
}
                                                                                                                                                        
@end

/*******************************TODO:Device*************************************/

@implementation Device

+(Device *)setDeviceId:(NSString *)deviceId
     andDeviceName:(NSString *)deviceName
           andType:(NSString *)type
        andHouseId:(NSString *)houseId
        andLayerId:(NSString *)layerId
         andRoomId:(NSString *)roomId
       andIconType:(NSString *)iconType
{
    Device *obj = [[Device alloc] init];
    obj.DeviceId = deviceId;
    obj.DeviceName = deviceName;
    obj.Type = type;
    obj.HouseId = houseId;
    obj.LayerId = layerId;
    obj.RoomId = roomId;
    obj.IconType = iconType;
    
    return obj;
}
@end

/*******************************TODO:Order*************************************/

@implementation Order

+(Order *)setOrderId:(NSString *)orderId
        andOrderName:(NSString *)orderName
             andType:(NSString *)type
          andSubType:(NSString *)subType
         andOrderCmd:(NSString *)orderCmd
          andAddress:(NSString *)address
         andStudyCmd:(NSString *)studyCmd
          andOrderNo:(NSString *)orderNo
          andHouseId:(NSString *)houseId
          andLayerId:(NSString *)layerId
           andRoomId:(NSString *)roomId
         andDeviceId:(NSString *)deviceId
             andHora:(NSString *)hora
{
    Order *obj = [[Order alloc] init];
    obj.OrderId = orderId;
    obj.OrderName = orderName;
    obj.Type = type;
    obj.SubType = subType;
    obj.OrderCmd = orderCmd;
    obj.Address = address;
    obj.StudyCmd = studyCmd;
    obj.OrderNo = orderNo;
    obj.HouseId = houseId;
    obj.LayerId = layerId;
    obj.RoomId = roomId;
    obj.DeviceId = deviceId;
    obj.Hora = hora;
    
    return obj;
}

@end

/***************************** TODO:Layer ***************************************/

@implementation Layer
@end

/*****************************TODO:Room***************************************/

@implementation Room

+(Room *)setRoomId:(NSString *)roomId
     andRoomName:(NSString *)roomName
      andHouseId:(NSString *)houseId
      andLayerId:(NSString *)layerId
{
    Room *obj = [[Room alloc] init];
    obj.RoomId = roomId;
    obj.RoomName = roomName;
    obj.HouseId = houseId;
    obj.LayerId = layerId;
    
    return obj;
}

@end

/******************************TODO:Sence****************************************/

@implementation Sence

+(Sence *)setSenceId:(NSString *)senceId
     andSenceName:(NSString *)senceName
      andMacrocmd:(NSString *)macrocmd
          andType:(NSString *)type
       andCmdList:(NSString *)cmdList
       andHouseId:(NSString *)houseId
       andLayerId:(NSString *)layerId
        andRoomId:(NSString *)roomId
      andIconType:(NSString *)iconType
{
    Sence *obj = [[Sence alloc] init];
    obj.SenceId = senceId;
    obj.SenceName = senceName;
    obj.Macrocmd = macrocmd;
    obj.Type = type;
    obj.CmdList = cmdList;
    obj.HouseId = houseId;
    obj.LayerId = layerId;
    obj.RoomId = roomId;
    obj.IconType = iconType;
    
    return obj;
}

@end

/************************************************************************************/

@implementation Member

//获取Ud对象用户信息
+(Member *)getMember
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *memberDict = [ud objectForKey:@"MEMBER_UD"];
    if (!memberDict) {
        return nil;
    }
    
    Member *memberObj = [[Member alloc] init];
    memberObj.uName = [memberDict objectForKey:@"uName"];
    memberObj.uPwd = [memberDict objectForKey:@"uPwd"];
    memberObj.uKey = [memberDict objectForKey:@"uKey"];
    memberObj.isRemeber = [[memberDict objectForKey:@"isRemeber"] boolValue];
    
    return memberObj;
}

//设置对象信息
+(void)setUdMember:(NSString *)uName
           andUPwd:(NSString *)uPwd
           andUKey:(NSString *)uKey
      andIsRemeber:(BOOL)isRemeber
{
    NSMutableDictionary *memberDict = [[NSMutableDictionary alloc] init];
    [memberDict setObject:uName forKey:@"uName"];
    [memberDict setObject:uPwd forKey:@"uPwd"];
    [memberDict setObject:uKey forKey:@"uKey"];
    [memberDict setObject:[NSNumber numberWithBool:isRemeber] forKey:@"isRemeber"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:memberDict forKey:@"MEMBER_UD"];
    [ud synchronize];
}

//设置登录临时对象信息
+(void)setTempLoginUdMember:(NSString *)uName
           andUPwd:(NSString *)uPwd
           andUKey:(NSString *)uKey
      andIsRemeber:(BOOL)isRemeber
{
    NSMutableDictionary *memberDict = [[NSMutableDictionary alloc] init];
    [memberDict setObject:uName forKey:@"uName"];
    [memberDict setObject:uPwd forKey:@"uPwd"];
    [memberDict setObject:uKey forKey:@"uKey"];
    [memberDict setObject:[NSNumber numberWithBool:isRemeber] forKey:@"isRemeber"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:memberDict forKey:@"MEMBER_UD_LOGIN_TEMP"];
    [ud synchronize];
}

//获取Ud对象用户信息
+(Member *)getTempLoginMember
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *memberDict = [ud objectForKey:@"MEMBER_UD_LOGIN_TEMP"];
    if (!memberDict) {
        return nil;
    }
    
    Member *memberObj = [[Member alloc] init];
    memberObj.uName = [memberDict objectForKey:@"uName"];
    memberObj.uPwd = [memberDict objectForKey:@"uPwd"];
    memberObj.uKey = [memberDict objectForKey:@"uKey"];
    memberObj.isRemeber = [[memberDict objectForKey:@"isRemeber"] boolValue];
    
    return memberObj;
}

@end

/***************************************TODO:Config(配置信息) *********************************************/

@implementation Config

//获取配置信息
+(Config *)getConfig
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *objDic = [ud objectForKey:@"CONFIG_UD"];
    if (!objDic) {
        return nil;
    }
    
    Config *obj = [[Config alloc] init];
    obj.configVersion = [objDic objectForKey:@"configVersion"];
    obj.isSetSign = [[objDic objectForKey:@"isSetSign"] boolValue];
    obj.isWriteCenterControl = [[objDic objectForKey:@"isWriteCenterControl"] boolValue];
    obj.isSetIp = [[objDic objectForKey:@"isSetIp"] boolValue];
    obj.isBuyCenterControl = [[objDic objectForKey:@"isBuyCenterControl"] boolValue];
    
    return obj;
}

//设置配置信息
+(void)setConfigArr:(NSArray *)configArr
{
    NSMutableDictionary *memberDict = [[NSMutableDictionary alloc] init];
    
    //配置文件版本
    [memberDict setObject:[configArr objectAtIndex:1] forKey:@"configVersion"];
    
    //是否配置过标记，未配置则强制进入配置模式
    NSString *sIsSetSign = [configArr objectAtIndex:3];
    BOOL bIsSetSign = NO;
    if ([[sIsSetSign uppercaseString] isEqualToString:@"TRUE"]) {
        bIsSetSign = YES;
    }
    [memberDict setObject:[NSNumber numberWithBool:bIsSetSign] forKey:@"isSetSign"];
    
    //是否写入中控
    NSString *sIsWriteCenterControl = [configArr objectAtIndex:4];
    BOOL bIsWriteCenterControl = NO;
    if ([[sIsWriteCenterControl uppercaseString] isEqualToString:@"TRUE"]) {
        bIsWriteCenterControl = YES;
    }
    [memberDict setObject:[NSNumber numberWithBool:bIsWriteCenterControl] forKey:@"isWriteCenterControl"];
    
    //是否设置 IP
    NSString *sIsSetIp = [configArr objectAtIndex:5];
    BOOL bIsSetIp = NO;
    if ([[sIsSetIp uppercaseString] isEqualToString:@"TRUE"]) {
        bIsSetIp = YES;
    }
    [memberDict setObject:[NSNumber numberWithBool:bIsSetIp] forKey:@"isSetIp"];
    
    //是否购买中控
    NSString *sIsBuyCenterControl = [configArr objectAtIndex:6];
    BOOL bIsBuyCenterControl = NO;
    if ([[sIsBuyCenterControl uppercaseString] isEqualToString:@"TRUE"]) {
        bIsBuyCenterControl = YES;
    }
    [memberDict setObject:[NSNumber numberWithBool:bIsBuyCenterControl]forKey:@"isBuyCenterControl"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:memberDict forKey:@"CONFIG_UD"];
    [ud synchronize];
}

//设置配置信息
+(void)setConfigObj:(Config *)obj
{
    NSMutableDictionary *memberDict = [[NSMutableDictionary alloc] init];
    
    //配置文件版本
    [memberDict setObject:obj.configVersion forKey:@"configVersion"];
    
    //是否配置过标记，未配置则强制进入配置模式
    [memberDict setObject:[NSNumber numberWithBool:obj.isSetSign] forKey:@"isSetSign"];
    
    //是否写入中控
    [memberDict setObject:[NSNumber numberWithBool:obj.isWriteCenterControl] forKey:@"isWriteCenterControl"];
    
    //是否设置 IP
    [memberDict setObject:[NSNumber numberWithBool:obj.isSetIp] forKey:@"isSetIp"];
    
    //是否购买中控
    [memberDict setObject:[NSNumber numberWithBool:obj.isBuyCenterControl]forKey:@"isBuyCenterControl"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:memberDict forKey:@"CONFIG_UD"];
    [ud synchronize];
}

//临时变量,用于对比本地配置属性
+(Config *)getTempConfig:(NSArray *)configArr
{
    Config *obj = [[Config alloc] init];
    
    obj.configVersion = [configArr objectAtIndex:1];
    
    //是否配置过标记，未配置则强制进入配置模式
    NSString *sIsSetSign = [configArr objectAtIndex:3];
    BOOL bIsSetSign = NO;
    if ([[sIsSetSign uppercaseString] isEqualToString:@"TRUE"]) {
        bIsSetSign = YES;
    }
    obj.isSetSign = bIsSetSign;
    
    //是否写入中控
    NSString *sIsWriteCenterControl = [configArr objectAtIndex:4];
    BOOL bIsWriteCenterControl = NO;
    if ([[sIsWriteCenterControl uppercaseString] isEqualToString:@"TRUE"]) {
        bIsWriteCenterControl = YES;
    }
    obj.isWriteCenterControl = bIsWriteCenterControl;
    
    //是否设置 IP
    NSString *sIsSetIp = [configArr objectAtIndex:5];
    BOOL bIsSetIp = NO;
    if ([[sIsSetIp uppercaseString] isEqualToString:@"TRUE"]) {
        bIsSetIp = YES;
    }
    obj.isSetIp = bIsSetIp;
    
    //是否购买中控
    NSString *sIsBuyCenterControl = [configArr objectAtIndex:6];
    BOOL bIsBuyCenterControl = NO;
    if ([[sIsBuyCenterControl uppercaseString] isEqualToString:@"TRUE"]) {
        bIsBuyCenterControl = YES;
    }
    obj.isBuyCenterControl = bIsBuyCenterControl;
    
    return obj;
}

@end



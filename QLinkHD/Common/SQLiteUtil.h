//
//  SQLiteUtil.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteUtil : NSObject

//中控信息sql
+(NSString *)connectControlSql:(Control *)obj;
//设备表sql拼接
+(NSString *)connectDeviceSql:(Device *)obj;

//命令表sql拼接
+(NSString *)connectOrderSql:(Order *)obj;

//房间表sql拼接
+(NSString *)connectRoomSql:(Room *)obj;

//场景表sql拼接
+(NSString *)connectSenceSql:(Sence *)obj;

//获取当前版本号
+(NSString *)getCurVersionNo;

//获取设置当前默认楼层和房间号码
+(void)setDefaultLayerIdAndRoomId;
//TODO:获取所有楼层(忽略多个房子)
+(NSMutableArray *)getLayerList;
//TODO:获取楼层下所有的房间
+(NSMutableArray *)getRoomListByLayerId:(NSString *)layerId;

//清除数据
+(void)clearData;

//执行sql语句事物
+(BOOL)handleConfigToDataBase:(NSArray *)sqlArr;

//获取场景列表
+(NSArray *)getSenceList:(NSString *)houseId
              andLayerId:(NSString *)layerId
               andRoomId:(NSString *)roomId;

//获取具体场景命令集合
+(NSMutableArray *)getOrderBySenceId:(NSString *)senceId;

//更新场景下命令和时间
+(BOOL)updateCmdListBySenceId:(NSString *)senceId andSenceName:(NSString *)senceName andCmdList:(NSString *)cmdLists;

//添加场景
+(BOOL)insertSence:(Sence *)obj;

//获取设备列表
+(NSArray *)getDeviceList:(NSString *)houseId
               andLayerId:(NSString *)layerId
                andRoomId:(NSString *)roomId;

//更新图标
+(BOOL)changeIcon:(NSString *)deviceId
          andType:(NSString *)type
       andNewType:(NSString *)newType;

//获取房间列表
+(NSArray *)getRoomList:(NSString *)houseId
             andLayerId:(NSString *)layerId;

//重命名场景
+(BOOL)renameSenceName:(NSString *)senceId
            andNewName:(NSString *)newName;

//重命名设备
+(BOOL)renameDeviceName:(NSString *)deviceId
             andNewName:(NSString *)newName;

//删除场景
+(BOOL)removeSence:(NSString *)senceId;

//删除设备
+(BOOL)removeDevice:(NSString *)deviceId;

//获取该设备下所有命令类型
+(NSArray *)getOrderTypeGroupOrder:(NSString *)deviceId;

//获取指定设备下指定类型的命令集合,用于非照明设备命令查询
+(NSArray *)getOrderListByDeviceId:(NSString *)deviceId andType:(NSString *)type;

//获取指定设备下指定类型的命令集合,用于照明设备命令查询
+(NSArray *)getOrderListByDeviceId:(NSString *)deviceId;

//获取当前房间下所有的照明设备
+(NSArray *)getLightDevice:(NSString *)houseId
                andLayerId:(NSString *)layerId
                 andRoomId:(NSString *)roomId;

//获取当前房间下所有的照明设备(除了type＝‘light’)，考虑到先加载type＝‘light’的照明控件，所以分开取数据
+(NSArray *)getLightComplexDevice:(NSString *)houseId
                       andLayerId:(NSString *)layerId
                        andRoomId:(NSString *)roomId;

//添加命令到购物车表，用于构建场景
+(BOOL)addOrderToShoppingCar:(NSString *)orderId andDeviceId:(NSString *)deviceId;

//获取购物车里的命令
+(NSMutableArray *)getShoppingCarOrder;

//删除所有添加的场景命令
+(BOOL)removeShoppingCar;

//获取购物车数量
+(int)getShoppingCarCount;

//移除购物车的某条命令
+(BOOL)removeShoppingCarByOrderId:(NSString *)orderId;

//获取全局配置信息
+(Control *)getControlObj;

//当前设备是否有学习模式
+(BOOL)isStudyModel:(NSString *)deviceId;

@end

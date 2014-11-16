//
//  Model.h
//  QLink
//
//  Created by 尤日华 on 14-9-21.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************TODO:GlobalAttr(存储全局变量)**************************************/

@interface GlobalAttr : NSObject

//当前房间信息
@property(nonatomic,strong) NSString *LayerId;
@property(nonatomic,strong) NSString *RoomId;
@property(nonatomic,strong) NSString *HouseId;

@end

/****************************TODO:Control****************************************/

@interface Control : NSObject

@property(nonatomic,strong) NSString *Ip;
@property(nonatomic,strong) NSString *SendType;
@property(nonatomic,strong) NSString *Port;
@property(nonatomic,strong) NSString *Domain;
@property(nonatomic,strong) NSString *Url;
@property(nonatomic,strong) NSString *Updatever;

+(Control *)setIp:(NSString *)ip
      andSendType:(NSString *)sendType
          andPort:(NSString *)port
        andDomain:(NSString *)domain
           andUrl:(NSString *)url
     andUpdatever:(NSString *)updatever;

@end

/****************************TODO:Device****************************************/

@interface Device : NSObject

@property(nonatomic,strong) NSString *DeviceId;
@property(nonatomic,strong) NSString *DeviceName;
@property(nonatomic,strong) NSString *Type;
@property(nonatomic,strong) NSString *HouseId;
@property(nonatomic,strong) NSString *LayerId;
@property(nonatomic,strong) NSString *RoomId;
@property(nonatomic,strong) NSString *IconType;

+(Device *)setDeviceId:(NSString *)deviceId
         andDeviceName:(NSString *)deviceName
               andType:(NSString *)type
            andHouseId:(NSString *)houseId
            andLayerId:(NSString *)layerId
             andRoomId:(NSString *)roomId
           andIconType:(NSString *)iconType;

@end


/*****************************TODO:Order***************************************/

@interface Order : NSObject

@property(nonatomic,strong) NSString *OrderId;
@property(nonatomic,strong) NSString *OrderName;
@property(nonatomic,strong) NSString *Type;
@property(nonatomic,strong) NSString *SubType;
@property(nonatomic,strong) NSString *OrderCmd;
@property(nonatomic,strong) NSString *Address;
@property(nonatomic,strong) NSString *StudyCmd;
@property(nonatomic,strong) NSString *HouseId;
@property(nonatomic,strong) NSString *LayerId;
@property(nonatomic,strong) NSString *RoomId;
@property(nonatomic,strong) NSString *DeviceId;
@property(nonatomic,strong) NSString *OrderNo;

//紧急模式下配置参数
@property(nonatomic,strong) NSString *senceId;

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
         andDeviceId:(NSString *)deviceId;

@end

/*******************************TODO:Layer*************************************/

@interface Layer : NSObject

@property(nonatomic,strong) NSString *HouseId;
@property(nonatomic,strong) NSString *LayerId;

@end

/*******************************TODO:Room*************************************/

@interface Room : NSObject

@property(nonatomic,strong) NSString *RoomId;
@property(nonatomic,strong) NSString *RoomName;
@property(nonatomic,strong) NSString *HouseId;
@property(nonatomic,strong) NSString *LayerId;

+(Room *)setRoomId:(NSString *)roomId
       andRoomName:(NSString *)roomName
        andHouseId:(NSString *)houseId
        andLayerId:(NSString *)layerId;

@end


/*****************************TODO:Sence***************************************/

@interface Sence : NSObject

@property(nonatomic,strong) NSString *SenceId;
@property(nonatomic,strong) NSString *SenceName;
@property(nonatomic,strong) NSString *Macrocmd;
@property(nonatomic,strong) NSString *Type;
@property(nonatomic,strong) NSString *CmdList;
@property(nonatomic,strong) NSString *HouseId;
@property(nonatomic,strong) NSString *LayerId;
@property(nonatomic,strong) NSString *RoomId;
@property(nonatomic,strong) NSString *IconType;
//场景下命令
@property(nonatomic,strong) NSString *OrderId;
@property(nonatomic,strong) NSString *OrderName;
@property(nonatomic,strong) NSString *OrderCmd;
@property(nonatomic,strong) NSString *Address;
@property(nonatomic,strong) NSString *Timer;

+(Sence *)setSenceId:(NSString *)senceId
        andSenceName:(NSString *)senceName
         andMacrocmd:(NSString *)macrocmd
             andType:(NSString *)type
          andCmdList:(NSString *)cmdList
          andHouseId:(NSString *)houseId
          andLayerId:(NSString *)layerId
           andRoomId:(NSString *)roomId
         andIconType:(NSString *)iconType;

@end

/************************************TODO:Member************************************************/

@interface Member : NSObject

@property(nonatomic,strong) NSString *uName;
@property(nonatomic,strong) NSString *uPwd;
@property(nonatomic,strong) NSString *uKey;
@property(nonatomic,assign) BOOL isRemeber;

//获取Ud对象用户信息
+(Member *)getMember;

//设置对象信息
+(void)setUdMember:(NSString *)uName
           andUPwd:(NSString *)uPwd
           andUKey:(NSString *)uKey
      andIsRemeber:(BOOL)isRemeber;

@end

/********************************TODO:Config(配置信息)****************************************************/

@interface Config : NSObject

@property(nonatomic,strong) NSString *configVersion;//配置文件版本
@property(nonatomic,assign) BOOL isSetSign;//是否配置过标记,未配置则强制进入配置页面
@property(nonatomic,assign) BOOL isWriteCenterControl;//是否写入中控
@property(nonatomic,assign) BOOL isSetIp;//是否配置中控IP
@property(nonatomic,assign) BOOL isBuyCenterControl;//是否购买中控

//获取配置信息
+(Config *)getConfig;

//设置配置信息
+(void)setConfigArr:(NSArray *)configArr;

//设置配置信息
+(void)setConfigObj:(Config *)obj;

//临时变量,用于对比本地配置属性
+(Config *)getTempConfig:(NSArray *)configArr;

@end



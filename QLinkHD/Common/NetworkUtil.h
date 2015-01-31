//
//  NetworkUtil.h
//  QLink
//
//  Created by 尤日华 on 14-9-19.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtil : NSObject

+(NSString *)getBaseUrl;

//获取 Action = login Url
+(NSString *)getActionLogin:(NSString *)uName
                    andUPwd:(NSString *)uPwd
                    andUKey:(NSString *)uKey;

//获取 Action URL
+(NSString *)getAction:(NSString *)action;

//获取设置ip地址
+(NSString *)getSetUpIp:(NSString *)uName andPwd:(NSString *)uPwd andKey:(NSString *)uKey;

//修改场景名称URL
+(NSString *)getChangeSenceName:(NSString *)newName andSenceId:(NSString *)senceId;

//修改设备名称URL
+(NSString *)getChangeDeviceName:(NSString *)newName andDeviceId:(NSString *)deviceId;

//+(NSString *)handleIpRequest;
+(NSString *)handleIpRequest:(Member *)loginUser;

//编辑场景
+(NSString *)getEditSence:(NSString *)senceId
             andSenceName:(NSString *)senceName
                   andCmd:(NSString *)cmds
                  andTime:(NSString *)times;

//删除场景
+(NSString *)getDelSence:(NSString *)senceId;

//删除设备
+(NSString *)getDelDevice:(NSString *)deviceId;

//注册
+(NSString *)getRegisterUrl:(NSString *)uName
                     andPwd:(NSString *)uPwd
                   andICode:(NSString *)icode;

//设置设备IP
+(NSString *)geSetDeviceIp:(NSString *)deviceId andChangeVar:(NSString *)var;

//修改协议URL
+(NSString *)getChangeDeviceProtocol:(NSString *)name andDeviceId:(NSString *)deviceId;

//请输入产品序列号（MAC）
+(NSString *)setNumber:(NSString *)number;

//重写中控
+(NSString *)geResetZK;

//重设IP
+(NSString *)getResetIp:(NSString *)pwd;

//设置Order命令
+(NSString *)geSetDeviceOrder:(NSString *)orderId andChangeVar:(NSString *)var andInputw:(NSString *)inputw;

@end

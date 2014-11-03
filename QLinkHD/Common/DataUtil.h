//
//  DataUtil.h
//  QLink
//
//  Created by SANSAN on 14-9-20.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface DataUtil : NSObject

//获取沙盒地址
+(NSString *)getDirectoriesInDomains;

//检测是否为空
+(BOOL)checkNullOrEmpty:(NSString *)str;

//判断节点类型并且转换为数组
+(NSArray *)changeDicToArray:(NSObject *)obj;

//判断是否为nil,nil则返回空
+(NSString *)getDefaultValue:(NSString *)value;

//全局变量
+(GlobalAttr *)shareInstanceToRoom;

//更新房间号
+(void)setGlobalAttrRoom:(NSString *)roomId;

//设置全局模式
+(void)setGlobalModel:(NSString *)global;

//获取全局模式类型
+(NSString *)getGlobalModel;

//设置是否添加场景
+(void)setGlobalIsAddSence:(BOOL)isAdd;

//获取是否添加场景模式
+(BOOL)getGlobalIsAddSence;

+(NSStringEncoding)getGB2312Code;

//设置编辑的场景id
+(void)setUpdateInsertSenceInfo:(NSString *)senceId
                   andSenceName:(NSString *)senceName;

+ (NSString *)hexStringFromString:(NSString *)string;

+ (NSString *)localWiFiIPAddress;

//设置udp端口
+(void)setUdpPort:(NSString *)port;

//获取udp端口
+(NSString *)getUdpPort;

@end





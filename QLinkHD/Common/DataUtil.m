//
//  DataUtil.m
//  QLink
//
//  Created by SANSAN on 14-9-20.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "DataUtil.h"
//ip
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation DataUtil

//获取沙盒地址
+(NSString *)getDirectoriesInDomains
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return docsDir;
}

//检测是否为空
+(BOOL)checkNullOrEmpty:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

//判断节点类型并且转换为数组
+(NSArray *)changeDicToArray:(NSObject *)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [NSArray arrayWithObject:(NSDictionary *)obj];
    }else
    {
        return (NSArray *)obj;
    }
}

//判断是否为nil,nil则返回空
+(NSString *)getDefaultValue:(NSString *)value
{
    if ([DataUtil checkNullOrEmpty:value]) {
        return  @"";
    }else{
        return value;
    }
}

//全局变量
+(GlobalAttr *)shareInstanceToRoom
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *globalAttrDic = [ud objectForKey:Global_Room_Attr];
    
    GlobalAttr *obj = [[GlobalAttr alloc] init];
    obj.LayerId = [globalAttrDic objectForKey:@"LayerId"];
    obj.RoomId = [globalAttrDic objectForKey:@"RoomId"];
    obj.HouseId = [globalAttrDic objectForKey:@"HouseId"];
    
    return obj;
}

//TODO:获取图标
+(NSMutableArray *)getIconList:(IconType)iconType
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"iConPlist" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray *iconArr = [NSMutableArray array];
    switch (iconType) {
        case IconTypeSence:
        {
            [iconArr addObjectsFromArray:[dataDic objectForKey:@"Sence"]];
            break;
        }
        case IconTypeDevice:
        {
            [iconArr addObjectsFromArray:[dataDic objectForKey:@"Device"]];
            break;
        }
        case IconTypeAll:
        {
            [iconArr addObjectsFromArray:[dataDic objectForKey:@"Device"]];
            [iconArr addObjectsFromArray:[dataDic objectForKey:@"Sence"]];
            break;
        }
        default:
            break;
    }
    
    return iconArr;
}

//TODO:配置设备icon图标
+(NSMutableDictionary *)getDeviceConfigIconList
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DeviceConfigIconPlist" ofType:@"plist"];
    NSMutableDictionary *iconDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return iconDic;
}

//更新房间号
+(void)setGlobalAttrRoom:(NSString *)roomId
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *globalAttrDic = [ud objectForKey:Global_Room_Attr];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:globalAttrDic];
    [newDic setObject:roomId forKey:@"RoomId"];
    [ud setObject:newDic forKey:Global_Room_Attr];
    [ud synchronize];
}

//设置全局模式
+(void)setGlobalModel:(NSString *)global
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:global forKey:Global_Model_Attr];
    [ud synchronize];
}

//获取全局模式类型
+(NSString *)getGlobalModel
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *model = [ud objectForKey:Global_Model_Attr];
    return model;
}

//设置是否添加场景
+(void)setGlobalIsAddSence:(BOOL)isAdd
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:isAdd forKey:Global_Model_IsAddSence];
    [ud synchronize];
}

//获取是否添加场景模式
+(BOOL)getGlobalIsAddSence
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL bResult = [[ud objectForKey:Global_Model_IsAddSence] boolValue];
    return bResult;
}

+(NSStringEncoding)getGB2312Code
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return enc;
}

//设置编辑的场景id
+(void)setUpdateInsertSenceInfo:(NSString *)senceId
                   andSenceName:(NSString *)senceName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:senceId forKey:@"SenceId"];
    [ud setObject:senceName forKey:@"SenceName"];
    [ud synchronize];
}

//设置udp端口
+(void)setUdpPort:(NSString *)port
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:port forKey:@"port"];
    [ud synchronize];
}

//获取udp端口
+(NSString *)getUdpPort
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *model = [ud objectForKey:@"port"];
    return model;
}

+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

+(NSString *)localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

@end



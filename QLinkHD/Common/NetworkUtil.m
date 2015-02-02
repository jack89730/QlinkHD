//
//  NetworkUtil.m
//  QLink
//
//  Created by 尤日华 on 14-9-19.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "NetworkUtil.h"
#import "DataUtil.h"

@implementation NetworkUtil

//获取基础 Url
+(NSString *)getBaseUrl
{
    Member *member = [Member getMember];
    
    return [NSString stringWithFormat:@"http://qlink.cc/zq/lookmobile.asp?uname=%@&upsd=%@&passkey=%@",member.uName,member.uPwd,member.uKey];
}

//获取 Action = login Url
+(NSString *)getActionLogin:(NSString *)uName
                    andUPwd:(NSString *)uPwd
                    andUKey:(NSString *)uKey
{
    return [NSString stringWithFormat:@"http://qlink.cc/zq/lookmobile.asp?uname=%@&upsd=%@&passkey=%@&action=login",uName,uPwd,uKey];
}

////获取 Action URL
//+(NSString *)getAction:(NSString *)action
//{
//    return [NSString stringWithFormat:@"%@&action=%@",[self getBaseUrl],action];
//}

//获取 Action URL
+(NSString *)getAction:(NSString *)action andMember:(Member *)loginUser
{
    //登录请求，因为这时候，Member 全局变量还没被覆盖最新的，到Action=null请求时，才为最新的
    //而其他请求，比如说中控等，是传入登录成功的用户
    NSString *baseUrl = [NSString stringWithFormat:@"http://qlink.cc/zq/lookmobile.asp?uname=%@&upsd=%@&passkey=%@",loginUser.uName,loginUser.uPwd,loginUser.uKey];
    
    return [NSString stringWithFormat:@"%@&action=%@",baseUrl,action];
}

//获取设置ip地址
+(NSString *)getSetUpIp:(NSString *)uName andPwd:(NSString *)uPwd andKey:(NSString *)uKey
{
    return [NSString stringWithFormat:@"http://qlink.cc/zq/lookmobile.asp?uname=%@&upsd=%@&passkey=%@&action=%@",uName,uPwd,uKey,ACTIONSETUPIP];
}

//修改场景名称URL
+(NSString *)getChangeSenceName:(NSString *)newName andSenceId:(NSString *)senceId
{
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=savekfchang&dx=2&classname=macro&Id=%@&ChangVar=%@",[self getBaseUrl],senceId,newName];
    sUrl = [sUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    return sUrl;
}

//+(NSString *)handleIpRequest
//{
//    NSString *wifiIp = [DataUtil localWiFiIPAddress];
//    wifiIp = [NSString stringWithFormat:@"TCP:%@:1234",wifiIp];
//    
//    NSString *sUrl = [NSString stringWithFormat:@"%@&action=savekfchang&dx=3&ChangVar=%@",[self getBaseUrl],wifiIp];
//    return sUrl;
//}

+(NSString *)handleIpRequest:(Member *)loginUser
{
    NSString *wifiIp = [DataUtil localWiFiIPAddress];
    wifiIp = [NSString stringWithFormat:@"TCP:%@:1234",wifiIp];
    
    //因为这时候，Member 全局变量还没被覆盖最新的，到Action=null请求时，才为最新的
    NSString *baseUrl = [NSString stringWithFormat:@"http://qlink.cc/zq/lookmobile.asp?uname=%@&upsd=%@&passkey=%@",loginUser.uName,loginUser.uPwd,loginUser.uKey];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=savekfchang&dx=3&ChangVar=%@",baseUrl,wifiIp];
    return sUrl;
}

//修改设备名称URL
+(NSString *)getChangeDeviceName:(NSString *)newName andDeviceId:(NSString *)deviceId
{
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=savekfchang&dx=1&Id=%@&ChangVar=%@",[self getBaseUrl],deviceId,newName];
    sUrl = [sUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    return sUrl;
}

//编辑场景
+(NSString *)getEditSence:(NSString *)senceId andSenceName:(NSString *)senceName andCmd:(NSString *)cmds andTime:(NSString *)times
{
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=macro&macroid=%@&macroname=%@&mcmd=%@&mtime=%@",[self getBaseUrl],senceId,senceName,cmds,times];
    sUrl = [sUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    return sUrl;
}

//删除场景
+(NSString *)getDelSence:(NSString *)senceId
{
    return [NSString stringWithFormat:@"%@&action=savekfchang&dx=4&classname=macro&Id=%@",[self getBaseUrl],senceId];
}

//删除设备
+(NSString *)getDelDevice:(NSString *)deviceId
{
    return [NSString stringWithFormat:@"%@&action=savekfchang&dx=4&Id=%@",[self getBaseUrl],deviceId];
}

//注册
+(NSString *)getRegisterUrl:(NSString *)uName
                     andPwd:(NSString *)uPwd
                   andICode:(NSString *)icode
{
    return [NSString stringWithFormat:@"http://qlink.cc/zq/reg.asp?usname=%@&psword=%@&icode=%@",uName,uPwd,icode];
}

//设置设备IP
+(NSString *)geSetDeviceIp:(NSString *)deviceId andChangeVar:(NSString *)var
{
    return [NSString stringWithFormat:@"%@&action=savekfchang&dx=5&Id=%@&changvar=%@",[self getBaseUrl],deviceId,var];
}

//修改协议URL
+(NSString *)getChangeDeviceProtocol:(NSString *)name andDeviceId:(NSString *)deviceId
{
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=savethisdevice&deviceid=%@&dname=%@",[self getBaseUrl],deviceId,name];
    sUrl = [sUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    return sUrl;
}

//请输入产品序列号（MAC）
+(NSString *)setNumber:(NSString *)number
{
    return [NSString stringWithFormat:@"%@&action=snpudui&product_sn=%@",[self getBaseUrl],number];
}

//重写中控
+(NSString *)geResetZK
{
    return [NSString stringWithFormat:@"%@&action=resetupzk",[self getBaseUrl]];
}

//重设IP
+(NSString *)getResetIp:(NSString *)pwd
{
    return [NSString stringWithFormat:@"%@&action=reip&password=%@",[self getBaseUrl],pwd];
}

//设置Order命令
+(NSString *)geSetDeviceOrder:(NSString *)orderId andChangeVar:(NSString *)var andInputw:(NSString *)inputw
{
    return [NSString stringWithFormat:@"%@&action=savekfchang&dx=6&Id=%@&changvar=%@&Inputw=%@",[self getBaseUrl],orderId,var,inputw];
}



@end

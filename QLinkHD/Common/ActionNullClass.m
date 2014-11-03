//
//  ActionNullClass.m
//  QLink
//
//  Created by 尤日华 on 14-10-4.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "ActionNullClass.h"

@implementation ActionNullClass

-(id)init
{
    self = [super init];
    if (self) {
        self.iRetryCount = 1;
    }
    
    return self;
}

-(void)requestActionNULL
{
    [SVProgressHUD showWithStatus:@"配置中..."];
    
    NSString *sUrl = [NetworkUtil getBaseUrl];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //清除本地配置数据
         [SQLiteUtil clearData];
         
         NSString *strXML = [[NSString alloc] initWithData:responseObject encoding:[DataUtil getGB2312Code]];
         
         if ([strXML isEqualToString:@"key error"]) {
             [SVProgressHUD showErrorWithStatus:@"配置出错,请重试."];
             return;
         }
         
         strXML = [strXML stringByReplacingOccurrencesOfString:@"\"GB2312\"" withString:@"\"utf-8\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,40)];
         NSData *newData = [strXML dataUsingEncoding:NSUTF8StringEncoding];
         
         //解析存到数据库
         NSMutableArray *sqlArr = [NSMutableArray array];
         NSDictionary *dict = [NSDictionary dictionaryWithXMLData:newData];
         
         if (!dict) {
             [SVProgressHUD showErrorWithStatus:@"配置出错,请重试."];
             return;
         }
         //配置表
         NSDictionary *info = [dict objectForKey:@"info"];
         Control *controlObj = [Control setIp:[info objectForKey:@"_ip"]
                                  andSendType:[info objectForKey:@"_tu"]
                                      andPort:[info objectForKey:@"_port"]
                                    andDomain:[info objectForKey:@"_domain"]
                                       andUrl:[info objectForKey:@"_url"]
                                 andUpdatever:[info objectForKey:@"_updatever"]];
         [sqlArr addObject:[SQLiteUtil connectControlSql:controlObj]];
         
         NSArray *layerArr = [DataUtil changeDicToArray:[info objectForKey:@"layer"]];
         for (NSDictionary *layerDic in layerArr) {
             //room
             NSArray *roomArr = [DataUtil changeDicToArray:[layerDic objectForKey:@"room"]];
             for (NSDictionary *roomDic in roomArr) {
                 Room *roomObj = [Room setRoomId:[roomDic objectForKey:@"_Id"]
                                     andRoomName:[roomDic objectForKey:@"_name"]
                                      andHouseId:[roomDic objectForKey:@"_houseid"]
                                      andLayerId:[roomDic objectForKey:@"_layerId"]];
                 [sqlArr addObject:[SQLiteUtil connectRoomSql:roomObj]];
                 
                 //device
                 NSArray *deviceArr = [DataUtil changeDicToArray:[roomDic objectForKey:@"device"]];
                 for (NSDictionary *deviceDic in deviceArr) {
                     if ([[deviceDic objectForKey:@"_type"] isEqualToString:MACRO]) {
                         Sence *senceObj = [Sence setSenceId:[deviceDic objectForKey:@"_id"]
                                                andSenceName:[deviceDic objectForKey:@"_name"]
                                                 andMacrocmd:[deviceDic objectForKey:@"_macrocmd"]
                                                     andType:[deviceDic objectForKey:@"_type"]
                                                  andCmdList:[deviceDic objectForKey:@"_cmdlist"]
                                                  andHouseId:[deviceDic objectForKey:@"_houseid"]
                                                  andLayerId:[deviceDic objectForKey:@"_layerId"]
                                                   andRoomId:[deviceDic objectForKey:@"_roomId"]
                                                 andIconType:@""];
                         [sqlArr addObject:[SQLiteUtil connectSenceSql:senceObj]];
                     }else{
                         Device *deviceObj = [Device setDeviceId:[deviceDic objectForKey:@"_id"]
                                                   andDeviceName:[deviceDic objectForKey:@"_name"]
                                                         andType:[deviceDic objectForKey:@"_type"]
                                                      andHouseId:[deviceDic objectForKey:@"_houseid"]
                                                      andLayerId:[deviceDic objectForKey:@"_layerId"]
                                                       andRoomId:[deviceDic objectForKey:@"_roomId"]
                                                     andIconType:@""];
                         [sqlArr addObject:[SQLiteUtil connectDeviceSql:deviceObj]];
                         
                         //order
                         NSArray *orderArr = [DataUtil changeDicToArray:[deviceDic objectForKey:@"order"]];
                         for (NSDictionary *orderDic in orderArr) {
                             NSString *studyCmd = [orderDic objectForKey:@"_studycmd"];
                             if ([DataUtil checkNullOrEmpty:studyCmd]) {
                                 studyCmd = @"";
                             }
                             Order *orderObj = [Order setOrderId:[orderDic objectForKey:@"_id"]
                                                    andOrderName:[orderDic objectForKey:@"_name"]
                                                         andType:[orderDic objectForKey:@"_type"]
                                                      andSubType:[orderDic objectForKey:@"_subtype"]
                                                     andOrderCmd:[orderDic objectForKey:@"_ordercmd"]
                                                      andAddress:[orderDic objectForKey:@"_ades"]
                                                     andStudyCmd:studyCmd
                                                      andOrderNo:[orderDic objectForKey:@"_sn"]
                                                      andHouseId:[orderDic objectForKey:@"_houseid"]
                                                      andLayerId:[orderDic objectForKey:@"_layerId"]
                                                       andRoomId:[orderDic objectForKey:@"_roomId"]
                                                     andDeviceId:[orderDic objectForKey:@"_deviceid"]];
                             [sqlArr addObject:[SQLiteUtil connectOrderSql:orderObj]];
                         }
                     }
                 }
             }
         }
         
         BOOL bResult = [SQLiteUtil handleConfigToDataBase:sqlArr];
         if (bResult) {
             if (self.delegate) {
                 [self.delegate successOper];
             }
         }else{
             [SVProgressHUD showErrorWithStatus:@"配置失败,请重试."];
         }
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (NumberOfTimeout > [self iRetryCount]) {
             [self setIRetryCount:[self iRetryCount] + 1];
             [self requestActionNULL];
         } else if ([self iRetryCount] == NumberOfTimeout) {
             [SVProgressHUD dismiss];
             
             if (self.delegate) {
                 [self.delegate failOper];
             }
         }
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data {
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data,
                                                               kCFPropertyListImmutable,
                                                               NULL);
    if(plist == nil) return nil;
    if ([(__bridge id)plist isKindOfClass:[NSDictionary class]]) {
        return (__bridge NSDictionary *)plist;
    }
    else {
        CFRelease(plist);
        return nil;
    }
}

@end

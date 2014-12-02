//
//  BottomRightView.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-16.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "BottomRightView.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "AboutViewController.h"
#import "DataUtil.h"
#import "SimplePingHelper.h"

@implementation BottomRightView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnSysConfigPressed:(id)sender
{
    define_weakself;

    Config *configObj = [Config getConfig];
    if (configObj.isBuyCenterControl) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"正常模式",@"紧急模式",@"写入中控",@"初始化",@"关于", nil];
        
        NSString *model = [DataUtil getGlobalModel];
        if ([model isEqualToString:Model_ZKDOMAIN] || [model isEqualToString:Model_ZKIp]) {//正常模式
            arr[0] = @"√  正常模式";
        } else if ([model isEqualToString:Model_JJ]) {//紧急模式
            arr[1] = @"√  紧急模式";
        }
        
        [UIAlertView alertViewWithTitle:@"操作"
                                message:nil
                      cancelButtonTitle:@"关闭"
                      otherButtonTitles:arr onDismiss:^(int buttonIdx) {
                          switch (buttonIdx) {
                              case 0://正常模式
                              {
                                  [weakSelf normalModel];
                                  break;
                              }
                              case 1://紧急模式
                              {
                                  [weakSelf jjModel];
                                  break;
                              }
                              case 2://写入中控
                              {
                                  [weakSelf writeZk];
                                  break;
                              }
                              case 3://初始化
                              {
                                  break;
                              }
                              case 4://关于
                              {
                                  [weakSelf about];
                                  break;
                              }
                              default:
                                  break;
                          }
                      }onCancel:nil];
    } else {
        [UIAlertView alertViewWithTitle:@"操作"
                                message:nil
                      cancelButtonTitle:@"关闭"
                      otherButtonTitles:@[@"关于"] onDismiss:^(int buttonIdx) {
                          [weakSelf about];
                      }onCancel:nil];
    }
    
    
}

#pragma mark -
#pragma mark SimpDel

- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        [DataUtil setGlobalModel:Model_ZKIp];
    } else {
        [DataUtil setGlobalModel:Model_ZKDOMAIN];
    }
}

-(void)normalModel
{
    [SVProgressHUD showSuccessWithStatus:@"正常模式"];
    //设置当前模式
    Config *configObj = [Config getConfig];
    if (configObj.isBuyCenterControl) {//购买中控
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    [DataUtil setGlobalModel:Model_ZKDOMAIN];
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    Control *control = [SQLiteUtil getControlObj];
                    [SimplePingHelper ping:control.Ip
                                    target:self
                                       sel:@selector(pingResult:)];
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable:{
                    [UIAlertView alertViewWithTitle:@"温馨提示" message:@"连接失败\n请确认网络是否连接." cancelButtonTitle:@"关闭"];
                    break ;
                }
                default:
                    break;
            };
        }];
        
    } else {
        [DataUtil setGlobalModel:Model_JJ];
    }
}

-(void)jjModel
{
    [SVProgressHUD showSuccessWithStatus:@"紧急模式"];
    [DataUtil setGlobalModel:Model_JJ];
}

-(void)writeZk
{
    if (self.delegate) {
        [self.delegate writeToZk];
    }
}

-(void)about
{
    AboutViewController *aboutVC = [AboutViewController loadFromSB];
    NSDictionary * notiInfo = @{@"VC": aboutVC};
    [[NSNotificationCenter defaultCenter] postNotificationName:NDNotiMainUiJump
                                                        object:nil
                                                      userInfo:notiInfo];
}

@end

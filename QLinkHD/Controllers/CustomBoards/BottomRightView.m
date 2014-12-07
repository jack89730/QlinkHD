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
#import "CricleButton.h"
#import "SQLiteUtil.h"
#import "QuickOperDeviceChooseView.h"
#import "UIView+xib.h"
#import "KDGoalBar.h"

@interface BottomRightView()
{
    CricleButton *btnSel;
    Order *soundUpOrder;
    Order *soundDownOrder;
}

@property(nonatomic,strong) QuickOperDeviceChooseView *popView;
@property (weak, nonatomic) IBOutlet KDGoalBar *circleGoalBar;

@end

@implementation BottomRightView
{
    NSArray *dataArr;
    NSArray *orderArr;
}

-(void)awakeFromNib
{
    [self initData];
    
    [self normalModel];
    
    [self.circleGoalBar setThumbEnabled:YES];
    [self.circleGoalBar setAllowSwitching:NO];
    [self.circleGoalBar setSoundDown:^{
        if (!soundDownOrder) {
            return;
        }
        NSDictionary * notiInfo = @{@"Order": soundDownOrder};
        [[NSNotificationCenter defaultCenter] postNotificationName:NDNotiMainSoundSendOrder
                                                            object:nil
                                                          userInfo:notiInfo];
    }];
    [self.circleGoalBar setSoundUp:^{
        if (!soundUpOrder) {
            return;
        }
        NSDictionary * notiInfo = @{@"Order": soundUpOrder};
        [[NSNotificationCenter defaultCenter] postNotificationName:NDNotiMainSoundSendOrder
                                                            object:nil
                                                          userInfo:notiInfo];
    }];
}

-(void)initData
{
    for (int i=0; i<8; i++) {
        CricleButton *btn = (CricleButton *)[self viewWithTag:(101 + i)];
        btn.ivIcon = nil;
        btn.selected = NO;
    }
    
    dataArr = [NSArray array];
    dataArr = [SQLiteUtil getDeviceHasArLocal];
    define_weakself;
    for (int i = 0;i < dataArr.count; i++) {
        Device *device = dataArr[i];
        
        CricleButton *btn = (CricleButton *)[self viewWithTag:(101 + i)];
        [btn setLongPressBlock:^{
            [SQLiteUtil deleteDeviceHasArToLocal:device.DeviceId];
            [weakSelf initData];
        }];
        [btn addSmallIcon:device andIndex:i];
        if (i == 0) {
            btnSel = btn;
            btn.selected = YES;
            [btn setImageSel];
            
            if (![device.IconType isEqualToString:add_oper_localAr]) {
                orderArr = [SQLiteUtil getArOrderListByDeviceId:device.DeviceId];
                for (Order *obj in orderArr) {
                    if ([obj.SubType isEqualToString:@"ad"]) {
                        soundUpOrder = obj;
                    }else if ([obj.SubType isEqualToString:@"rd"]){
                        soundDownOrder = obj;
                    }
                }
            }
        }
    }
}

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
                                  [SVProgressHUD showSuccessWithStatus:@"正常模式"];
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
        [DataUtil setTempGlobalModel:Model_ZKIp];
    } else {
        [DataUtil setGlobalModel:Model_ZKDOMAIN];
        [DataUtil setTempGlobalModel:Model_ZKDOMAIN];
    }
}

-(void)normalModel
{
    //设置当前模式
    Config *configObj = [Config getConfig];
    if (configObj.isBuyCenterControl) {//购买中控
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    [DataUtil setGlobalModel:Model_ZKDOMAIN];
                    [DataUtil setTempGlobalModel:Model_ZKDOMAIN];
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
        [DataUtil setTempGlobalModel:Model_JJ];
    }
}

-(void)jjModel
{
    [SVProgressHUD showSuccessWithStatus:@"紧急模式"];
    [DataUtil setGlobalModel:Model_JJ];
    [DataUtil setTempGlobalModel:Model_JJ];
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

- (IBAction)btnDeviceArPressed:(CricleButton *)sender
{
    soundUpOrder = nil;
    soundDownOrder = nil;
    
    if ([sender.iconType isEqual:add_oper_localAr]) {//新增
        self.popView = [QuickOperDeviceChooseView viewFromDefaultXib];
        self.popView.frame = CGRectMake(0, 0, 1024, 768);
        self.popView.backgroundColor = [UIColor clearColor];
        define_weakself;
        [self.popView setConfirmPressed:^(NSString *deviceId){
            [SQLiteUtil addDeviceHasArToLocal:deviceId];
            [weakSelf initData];
            [weakSelf.popView removeFromSuperview];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    } else {//设备
        orderArr = [SQLiteUtil getArOrderListByDeviceId:sender.deviceId];
        for (Order *obj in orderArr) {
            if ([obj.SubType isEqualToString:@"ad"]) {
                soundUpOrder = obj;
            }else if ([obj.SubType isEqualToString:@"rd"]){
                soundDownOrder = obj;
            }
        }
    }
    
    btnSel.selected = NO;
    [btnSel setImageUnSel];
    sender.selected = YES;
    [sender setImageSel];
    btnSel = sender;
}

@end

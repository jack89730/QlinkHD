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
#import "ReSetIpView.h"

@interface BottomRightView()
{
    CricleButton *btnSel;
    Order *soundUpOrder;
    Order *soundDownOrder;
}

@property(nonatomic,strong) QuickOperDeviceChooseView *popView;
@property (weak, nonatomic) IBOutlet KDGoalBar *circleGoalBar;
@property(nonatomic,retain) ReSetIpView *resetIpView;

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
        if (self.delegate && [self.delegate respondsToSelector:@selector(soundChange:)]) {
            [self.delegate soundChange:soundDownOrder];
        }
    }];
    [self.circleGoalBar setSoundUp:^{
        if (!soundUpOrder) {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(soundChange:)]) {
            [self.delegate soundChange:soundUpOrder];
        }
    }];
}

-(void)initData
{
    for (int i=0; i<8; i++) {
        CricleButton *btn = (CricleButton *)[self viewWithTag:(101 + i)];
        btn.selected = NO;
        
        UIImageView *iv = (UIImageView *)[btn viewWithTag:999];
        [iv removeFromSuperview];
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
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"正常模式",@"紧急模式",@"写入中控",@"重写中控",@"重设IP",@"关于", nil];
        
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
                              case 3://重写中控
                              {
                                  [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                                  
                                  NSString *sUrl = [NetworkUtil geResetZK];
                                  NSURL *url = [NSURL URLWithString:sUrl];
                                  NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                                  
                                  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                                  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       NSString *sConfig = [[NSString alloc] initWithData:responseObject encoding:[DataUtil getGB2312Code]];
                                       NSRange range = [sConfig rangeOfString:@"error"];
                                       if (range.location != NSNotFound)
                                       {
                                           NSArray *errorArr = [sConfig componentsSeparatedByString:@":"];
                                           if (errorArr.count > 1) {
                                               [SVProgressHUD showErrorWithStatus:errorArr[1]];
                                               return;
                                           }
                                       }
                                       
                                       [SVProgressHUD dismiss];
                                       
                                       [UIAlertView alertViewWithTitle:@"温馨提示" message:@"设置成功,重启应用后生效."];
                                       
                                   }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [UIAlertView alertViewWithTitle:@"温馨提示" message:@"设置失败,请稍后再试."];
                                       [SVProgressHUD dismiss];
                                   }];
                                  
                                  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                                  [queue addOperation:operation];
                                  
                                  break;
                              }
                              case 4://重设IP
                              {
                                  define_weakself;
                                  self.resetIpView = [ReSetIpView viewFromDefaultXib];
                                  self.resetIpView.frame = CGRectMake(0, 0, 1024, 768);
                                  self.resetIpView.backgroundColor = [UIColor clearColor];
                                  [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.resetIpView];
                                  break;
                              }
                              case 5://关于
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
                      otherButtonTitles:@[@"重设IP",@"关于"] onDismiss:^(int buttonIdx) {
                          switch (buttonIdx) {
                              case 0://重设IP
                              {
                                  define_weakself;
                                  self.resetIpView = [ReSetIpView viewFromDefaultXib];
                                  self.resetIpView.frame = CGRectMake(0, 0, 1024, 768);
                                  self.resetIpView.backgroundColor = [UIColor clearColor];
                                  [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.resetIpView];
                                  break;
                              }
                              case 1:
                              {
                                  [weakSelf about];
                                  break;
                              }
                              default:
                                  break;
                          }
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
    if ((sender.tag - 100) > dataArr.count) {
        return;
    }
    
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

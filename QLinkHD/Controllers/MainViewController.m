//
//  MainViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "MainViewController.h"
#import "BottomBoard.h"
#import "LeftBoard.h"
#import "BottomView.h"
#import "UIView+xib.h"
#import "UIButton+image.h"
#import "IconCollectionCell.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "DataUtil.h"
#import "SQLiteUtil.h"
#import "RenameView.h"
#import "NetworkUtil.h"
#import "DeviceConfigViewController.h"
#import "SenceConfigViewController.h"
#import "RemoteViewController.h"
#import "LightViewController.h"

@interface MainViewController()<IconViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *deviceCollectionView;
@property (nonatomic, retain) RenameView *renameView;

@end

@implementation MainViewController
{
    NSMutableArray *deviceArr;
}

+(id)loadFromSB
{
    MainViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
    return vc;
}

- (void)viewDidLoad
{
    [self initNavigation];
    
    [self initCommonUI];
    
    [self initData];
}

-(void)initCommonUI
{
    BottomBoard *bottomBoard = [BottomBoard defaultBottomBoard];
    [bottomBoard setSendSenceOrderPressed:^(Order *orderObj){
        self.isSence = YES;
        [self load_typeSocket:999 andOrderObj:orderObj];
    }];
    [bottomBoard setWriteZkPressed:^{
        self.zkOperType = ZkOperNormal;
        [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
    }];
    [LeftBoard defaultLeftBoard];
    
    [self observeUiJumpNotfi];
}

-(void)observeUiJumpNotfi
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NDNotiMainUiJump object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary * userInfo = note.userInfo;
        UIViewController *vc = [userInfo objectForKey:@"VC"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NDNotiMainUiPop object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        //页面跳转
        NSArray * viewcontrollers = self.navigationController.viewControllers;
        int idxInStack = 0;
        for (int i=0; i<[viewcontrollers count]; i++) {
            if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
                idxInStack = i;
                break;
            }
        }
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
    }];
    
    //首页音量控制快捷命令入口
    [[NSNotificationCenter defaultCenter] addObserverForName:NDNotiMainSoundSendOrder object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary * userInfo = note.userInfo;
        Order *orderObj = [userInfo objectForKey:@"order"];
        [self load_typeSocket:999 andOrderObj:orderObj];
        NSLog(@"-----");
    }];
}

-(void)initData
{
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    
    deviceArr = [NSMutableArray arrayWithArray:[SQLiteUtil getDeviceList:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId]];
    [self.deviceCollectionView reloadData];
}

//设置导航
-(void)initNavigation
{
    self.title = @"桌面";
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - UICollectionViewDataSouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return deviceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Device *obj = deviceArr[indexPath.row];
    //功能cell
    IconCollectionCell * iconCell = nil;
    iconCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IconCellIdentifier" forIndexPath:indexPath];
    [iconCell fillDeviceValue:obj];
    [iconCell setLongPressed:^{
        if ([obj.Type isEqualToString:@"light"])
        {
            [UIAlertView alertViewWithTitle:@"温馨提示" message:@"照明类设备请到设备详情进行操作" cancelButtonTitle:@"取消"];
            return;
        } else if ([obj.Type isEqualToString:add_oper]) {
            [UIAlertView alertViewWithTitle:@"温馨提示" message:@"请单击进行操作" cancelButtonTitle:@"取消"];
            return;
        }
        
        define_weakself;
        //弹出操作框
        [UIAlertView alertViewWithTitle:@"请选择操作"
                                message:nil
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@[@"重命名",@"图标重置",@"删除"]
                              onDismiss:^(int btnIdx){
                                  switch (btnIdx) {
                                      case 0://重命名
                                      {
                                          self.renameView = [RenameView viewFromDefaultXib];
                                          self.renameView.frame = CGRectMake(0, 0, 1024, 768);
                                          self.renameView.backgroundColor = [UIColor clearColor];
                                          self.renameView.tfContent.text = obj.DeviceName;
                                          [self.renameView setCanclePressed:^{
                                              [weakSelf.renameView removeFromSuperview];
                                          }];
                                          [self.renameView setConfirmPressed:^(UILabel *lTitle,NSString *newName){
                                              NSString *sUrl = [NetworkUtil getChangeDeviceName:newName andDeviceId:obj.DeviceId];
                                              
                                              NSURL *url = [NSURL URLWithString:sUrl];
                                              NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                                              NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                              NSString *sResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
                                              if ([[sResult lowercaseString] isEqualToString:@"ok"]) {
                                                  [SQLiteUtil renameDeviceName:obj.DeviceId andNewName:newName];
                                                  
                                                  [UIAlertView alertViewWithTitle:@"温馨提示"
                                                                          message:@"更新成功"
                                                                cancelButtonTitle:@"确定"];
                                                  
                                                  [weakSelf.renameView removeFromSuperview];
                                                  
                                                  [weakSelf initData];
                                              }else{
                                                  [UIAlertView alertViewWithTitle:@"温馨提示"
                                                                          message:@"更新失败,请稍后再试."
                                                                cancelButtonTitle:@"关闭"];
                                              }
                                          }];
                                          [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.renameView];
                                          
                                          break;
                                      }
                                      case 1://图标重置
                                      {
                                          IconViewController *iconVC = [IconViewController loadFromSB];
                                          iconVC.pIconType = IconTypeDevice;
                                          iconVC.pDeviceObj = obj;
                                          iconVC.delegate = self;
                                          [self.navigationController pushViewController:iconVC animated:YES];
                                          
                                          break;
                                      }
                                      case 2://删除
                                      {
                                          NSString *sUrl = [NetworkUtil getDelDevice:obj.DeviceId];;
                                        
                                          NSURL *url = [NSURL URLWithString:sUrl];
                                          NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                                          NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                          NSString *sResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
                                          if ([[sResult lowercaseString] isEqualToString:@"ok"]) {
                                              [SQLiteUtil removeDevice:obj.DeviceId];
                                              [self initData];
                                              
                                              [UIAlertView alertViewWithTitle:@"温馨提示"
                                                                      message:@"删除成功"
                                                            cancelButtonTitle:@"确定"];
                                              
                                          }else{
                                              [UIAlertView alertViewWithTitle:@"温馨提示"
                                                                      message:@"删除失败.请稍后再试."
                                                            cancelButtonTitle:@"关闭"];
                                          }
                                          
                                          break;
                                      }
                                      default:
                                          break;
                                  }
        }onCancel:nil];
    }];
    
    //单击事件
    [iconCell setSinglePressed:^(UIButton *btn){
        if ([obj.Type isEqualToString:@"light"])
        {
            LightViewController *lightVC = [[LightViewController alloc] init];
            [self.navigationController pushViewController:lightVC animated:YES];
        } else if ([obj.Type isEqualToString:add_oper]) {
            DeviceConfigViewController *deviceConfigVC = [DeviceConfigViewController loadFromSB];
            [self.navigationController pushViewController:deviceConfigVC animated:YES];
        } else {
            RemoteViewController *remoteVC = [[RemoteViewController alloc] init];
            remoteVC.deviceId = obj.DeviceId;
            remoteVC.deviceName = obj.DeviceName;
            [self.navigationController pushViewController:remoteVC animated:YES];
        }
    }];
    
    return iconCell;
}

#pragma mark - RenameViewDelegate

//取消
-(void)handleCanclePressed:(RenameView *)view
{
    [view removeFromSuperview];
}

#pragma mark - IconViewControllerDelegate

-(void)refreshTable
{
    [self initData];
}

@end

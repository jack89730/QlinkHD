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

@interface MainViewController()

@property (weak, nonatomic) IBOutlet UICollectionView *deviceCollectionView;


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
    [BottomBoard defaultBottomBoard];
    [LeftBoard defaultLeftBoard];
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
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setHidden:NO];
    
//    UIImage * imgOn = [UIImage imageNamed:@"Common_返回键01"];
//    UIImage * imgOff = [UIImage imageNamed:@"Common_返回键02"];
//    UIBarButtonItem * btnBack =  [UIBarButtonItem barItemWithImage:imgOn
//                                                      highlightImage:imgOff
//                                                              target:self
//                                                        withAction:@selector(actionBack)];
//    self.navigationItem.rightBarButtonItem = btnBack;
}

//-(void)actionBack
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

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
    [iconCell fillViewValue:obj];
    [iconCell setSinglePressed:^(UIButton *btn){
        
        //to do some thing 跳转到设备控制页面
        
    }];
    [iconCell setLongPressed:^(UIButton *btn){
        if ([obj.Type isEqualToString:@"light"] || [obj.Type isEqualToString:@"sansan_add"])
        {
            [UIAlertView alertViewWithTitle:@"温馨提示" message:@"照明类设备请到设备详情进行操作" cancelButtonTitle:@"取消"];
            return;
        }
        
        //弹出操作框
        [UIAlertView alertViewWithTitle:@"请选择操作"
                                message:nil
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@[@"重命名",@"图标重置",@"删除"]
                              onDismiss:^(int btnIdx){
                                  switch (btnIdx) {
                                      case 0://重命名
                                      {
                                          break;
                                      }
                                      case 1://图标重置
                                      {
                                          IconViewController *iconVC = [IconViewController loadFromSB];
                                          iconVC.pIconType = IconTypeDevice;
                                          iconVC.pObj = obj;
                                          iconVC.delegate = self;
                                          [self.navigationController pushViewController:iconVC animated:YES];
                                          
                                          break;
                                      }
                                      case 2://删除
                                      {
                                          break;
                                      }
                                      default:
                                          break;
                                  }
        }onCancel:nil];
    }];
    return iconCell;
}

#pragma mark - IconViewControllerDelegate

-(void)refreshTable
{
    [self initData];
}

@end

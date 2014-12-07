//
//  QuickOperDeviceChooseView.m
//  QLinkHD
//
//  Created by 尤日华 on 14-12-4.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "QuickOperDeviceChooseView.h"
#import "SenceCell.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface QuickOperDeviceChooseView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *dataArr;
    UIButton *btnSel;
}
@property (weak, nonatomic) IBOutlet UICollectionView *cvDevice;

@end

@implementation QuickOperDeviceChooseView

-(void)awakeFromNib
{
    UINib *cellNib = [UINib nibWithNibName:@"SenceCell" bundle:nil];
    [self.cvDevice registerNib:cellNib forCellWithReuseIdentifier:@"SenceCell"];
    
    self.cvDevice.delegate = self;
    self.cvDevice.dataSource = self;
    
    [self initData];
}

-(void)initData
{
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    dataArr = [SQLiteUtil getDeviceHasAr:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId];
    
    [self.cvDevice reloadData];
}

#pragma mark - UICollectionViewDataSouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Device *obj = dataArr[indexPath.row];
    //功能cell
    SenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SenceCell" forIndexPath:indexPath];
    
    NSString *imgSel = [NSString stringWithFormat:@"%@02",obj.IconType];
    [cell.btnIcon setBackgroundImage:QLImage(obj.IconType) forState:UIControlStateNormal];
    [cell.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateHighlighted];
    [cell.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateSelected];
    cell.btnIcon.tag = indexPath.row;
    cell.lName.text = obj.DeviceName;
    
    [cell setSingleDeviceArPressed:^(SenceCell *pCell){
        btnSel.selected = NO;
        pCell.btnIcon.selected = YES;
        btnSel = pCell.btnIcon;
    }];
    
    return cell;
}

- (IBAction)btnCancle:(id)sender
{
    [self removeFromSuperview];
}
- (IBAction)btnConfirm:(id)sender
{
    if (!btnSel) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"请选择相应设备"];
        return;
    }
    
    if (self.confirmPressed) {
        Device *obj = dataArr[btnSel.tag];
        self.confirmPressed(obj.DeviceId);
    }
}


@end

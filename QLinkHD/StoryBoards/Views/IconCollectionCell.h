//
//  IconCollectionCell.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-13.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface IconCollectionCell : UICollectionViewCell

@property (copy, nonatomic) void (^singlePressed)(UIButton *btn);
@property (copy, nonatomic) void (^longPressed)();
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (weak, nonatomic) Device *curDeviceObj;
@property (weak, nonatomic) Sence *curSenceObj;

//设备主页面
-(void)fillDeviceValue:(Device *)deviceObj;
//场景主页面
-(void)fillSenceValue:(Sence *)senceObj;
-(void)fillViewValue:(NSString *)img andImgSel:(NSString *)imgSel andTitle:(NSString *)title;

@end

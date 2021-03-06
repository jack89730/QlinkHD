//
//  SenceCell.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-20.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (copy, nonatomic) void (^longPressed)();
@property (copy, nonatomic) void (^singlePressed)();
@property (copy, nonatomic) void (^singleDeviceArPressed)(SenceCell *cell);
@end

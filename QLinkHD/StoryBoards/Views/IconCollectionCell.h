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
@property (copy, nonatomic) void (^longPressed)(UIButton *btn);
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (weak, nonatomic) Device *curObj;

-(void)fillViewValue:(Device *)deviceObj;

@end

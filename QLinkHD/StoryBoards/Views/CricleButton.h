//
//  CricleButton.h
//  QLinkHD
//
//  Created by 尤日华 on 14-12-6.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CricleButton : UIButton

@property(nonatomic,copy) void(^longPressBlock)();
@property(nonatomic,retain) NSString *deviceId;
@property(nonatomic,retain) NSString *iconType;
@property(nonatomic,strong) UIImageView *ivIcon;

-(void)addSmallIcon:(Device *)obj andIndex:(int)idx;
-(void)setImageSel;
-(void)setImageUnSel;
@end

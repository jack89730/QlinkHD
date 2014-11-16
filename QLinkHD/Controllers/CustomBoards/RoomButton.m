//
//  RoomButton.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-15.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "RoomButton.h"

@implementation RoomButton

+(id)buttonWithType:(UIButtonType)buttonType
{
    UIButton *btn = [UIButton buttonWithType:buttonType];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    [btn setBackgroundImage:QLImage(@"left_RoomBtn01") forState:UIControlStateNormal];
    [btn setBackgroundImage:QLImage(@"left_RoomBtn02") forState:UIControlStateHighlighted];
    [btn setBackgroundImage:QLImage(@"left_RoomBtn02") forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

@end

//
//  SenceCell.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-20.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "SenceCell.h"

@implementation SenceCell

-(void)awakeFromNib
{
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPressed:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [self addGestureRecognizer:longPress];
    
    [self.btnIcon addTarget:self action:@selector(btnSingleTapPressed) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if(self.longPressed){
            self.longPressed();
        }
    }
}

-(void)btnSingleTapPressed
{
    if (self.singlePressed) {
        self.singlePressed();
    } else if (self.singleDeviceArPressed) {
        self.singleDeviceArPressed(self);
    }
}



@end

//
//  IconCollectionCell.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-13.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "IconCollectionCell.h"

@implementation IconCollectionCell

//设备主页面
-(void)fillDeviceValue:(Device *)deviceObj
{
    self.userInteractionEnabled = YES;
    self.curDeviceObj = deviceObj;
    
    self.lName.text = deviceObj.DeviceName;
    NSString *imgSel = [NSString stringWithFormat:@"%@02",deviceObj.IconType];
    [self.btnIcon setBackgroundImage:QLImage(deviceObj.IconType) forState:UIControlStateNormal];
    [self.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateHighlighted];
    [self.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateSelected];
    [self.btnIcon addTarget:self action:@selector(btnIconPressed:) forControlEvents:UIControlEventTouchUpInside];
    
        //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPressed:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [self.btnIcon addGestureRecognizer:longPress];
}

//场景主页面
-(void)fillSenceValue:(Sence *)senceObj
{
    self.userInteractionEnabled = YES;
    self.curSenceObj = senceObj;
    
    self.lName.text = senceObj.SenceName;
    NSString *imgSel = [NSString stringWithFormat:@"%@02",senceObj.IconType];
    [self.btnIcon setBackgroundImage:QLImage(senceObj.IconType) forState:UIControlStateNormal];
    [self.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateHighlighted];
    [self.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateSelected];
    [self.btnIcon addTarget:self action:@selector(btnIconPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPressed:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [self.btnIcon addGestureRecognizer:longPress];
}

//添加设备
-(void)fillViewValue:(NSString *)img andImgSel:(NSString *)imgSel andTitle:(NSString *)title
{
    self.userInteractionEnabled = YES;
    
    self.lName.text = title;
    [self.btnIcon setBackgroundImage:QLImage(img) forState:UIControlStateNormal];
    [self.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateHighlighted];
    [self.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateSelected];
    [self.btnIcon addTarget:self action:@selector(btnIconPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnIconPressed:(UIButton *)sender
{
    if (self.singlePressed) {
        self.singlePressed(sender);
    }
}

-(void)btnLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        NSLog(@"长按事件");
        if (self.longPressed) {
            self.longPressed();
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.btnIcon.selected = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.btnIcon.selected = NO;
}

@end

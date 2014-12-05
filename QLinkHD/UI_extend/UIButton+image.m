//
//  UIButton+image.m
//  KangShiFu_Elearnning
//
//  Created by Lin Yawen on 14-7-7.
//  Copyright (c) 2014年 Lin Yawen. All rights reserved.
//

#import "UIButton+image.h"

@implementation UIButton (image)

+(instancetype)buttonWithImage:(UIImage *)img1 withHighLightImage:(UIImage *)img2
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = img1.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    btn.frame = rect;
    [btn setImage:img1 forState:UIControlStateNormal];
    [btn setImage:img2 forState:UIControlStateHighlighted];
    return btn;
}

-(void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end

@implementation UIBarButtonItem(image)

+(instancetype)barItemWithImage:(UIImage *)img1
                 highlightImage:(UIImage *)img2
                         target:(id)target
                     withAction:(SEL)action
{
    UIButton * btn = [UIButton buttonWithImage:img1 withHighLightImage:img2];
    btn.imageEdgeInsets = UIEdgeInsetsMake(-15,-35,0,0);
    [btn addTarget:target action:action];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

+(instancetype)barItemWithImage1:(UIImage *)img1
                 highlightImage1:(UIImage *)img2
                         target1:(id)target
                     withAction1:(SEL)action
{
    UIButton * btn = [UIButton buttonWithImage:img1 withHighLightImage:img2];
    btn.imageEdgeInsets = UIEdgeInsetsMake(-15,0,0,0);
    [btn addTarget:target action:action];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

@end
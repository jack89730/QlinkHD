//
//  UIButton+image.h
//  KangShiFu_Elearnning
//
//  Created by Lin Yawen on 14-7-7.
//  Copyright (c) 2014年 Lin Yawen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (image)

+(instancetype)buttonWithImage:(UIImage *)img1 withHighLightImage:(UIImage *)img2;
-(void)addTarget:(id)target action:(SEL)action;
@end


@interface UIBarButtonItem(image)
/**
 *  creator
 *
 *  @param img1
 *  @param img2
 *  @param target
 *  @param action
 *
 *  @return UIBarButtonItem *
 */
+(instancetype)barItemWithImage:(UIImage *)img1
                 highlightImage:(UIImage *)img2
                         target:(id)target
                     withAction:(SEL)action;
@end

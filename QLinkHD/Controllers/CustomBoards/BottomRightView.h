//
//  BottomRightView.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-16.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomRightViewDelegate <NSObject>

-(void)writeToZk;

@end

@interface BottomRightView : UIView

@property(nonatomic,assign) id<BottomRightViewDelegate>delegate;

@end

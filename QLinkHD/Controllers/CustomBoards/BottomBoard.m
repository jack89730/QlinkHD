//
//  BottomBoard.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-5.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "BottomBoard.h"
#import "BottomView.h"
#import "BottomRightView.h"
#import "UIView+xib.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

static BottomBoard *__board = nil;

@interface BottomBoard()<BottomViewDelegate>

@end

@implementation BottomBoard
{
    UIWindow        *_boardWindow;
    BottomView      *_boardLeftView;
    BottomRightView *_boardRightView;
}

+ (BottomBoard *)defaultBottomBoard{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        __board = [[BottomBoard alloc] init];
    });
    return __board;
}

- (id)init{
    self = [super init];
    if (self) {
        NSInteger height = [[UIScreen mainScreen] bounds].size.height;
        
        _boardWindow = [UIApplication sharedApplication].keyWindow;
        _boardLeftView = [BottomView viewFromDefaultXib];
        _boardRightView = [BottomRightView viewFromDefaultXib];
        if (!IOS8_OR_LATER) {
            _boardLeftView.frame = CGRectMake(-279, 279, 728, 169);
            _boardLeftView.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
            
            _boardRightView.frame = CGRectMake(-11, 739, 296, 272);
            _boardRightView.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
        } else {
            _boardLeftView.frame = CGRectMake(0, height - 169, 728, 169);
            _boardRightView.frame = CGRectMake(728, height - 272, 296, 272);
        }
        _boardLeftView.userInteractionEnabled = YES;
        _boardLeftView.delegate = self;
        [_boardWindow addSubview:_boardLeftView];
        [_boardWindow addSubview:_boardRightView];
    }
    return self;
}

#pragma mark -
#pragma mark BottomViewDelegate

-(void)sendSenceOrder:(Order *)order
{
    if (self.sendSenceOrderPressed) {
        self.sendSenceOrderPressed(order);
    }
}

@end

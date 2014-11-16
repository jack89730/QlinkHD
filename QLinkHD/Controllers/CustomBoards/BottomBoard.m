//
//  BottomBoard.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-5.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "BottomBoard.h"
#import "BottomView.h"
#import "UIView+xib.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

static BottomBoard *__board = nil;

@implementation BottomBoard
{
    UIWindow        *_boardWindow;
    BottomView      *_boardView;
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
        NSInteger width = [[UIScreen mainScreen] bounds].size.width;
        
        _boardWindow = [UIApplication sharedApplication].keyWindow;
        _boardView = [BottomView viewFromDefaultXib];
        if (!IOS8_OR_LATER) {
            _boardView.frame = CGRectMake(-376, 376, height, 272);
            _boardView.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
            _boardView.backgroundColor = [UIColor clearColor];
        } else {
            _boardView.frame = CGRectMake(0, height - 272, width, 272);
        }
        _boardView.userInteractionEnabled = YES;
        [_boardWindow addSubview:_boardView];
    }
    return self;
}

@end

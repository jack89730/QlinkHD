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
        
        NSLog(@"w=%f,h=%f",[[UIScreen mainScreen] applicationFrame].size.width,[[UIScreen mainScreen] applicationFrame].size.height);
        
//        _boardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] applicationFrame].size.height - 272,[[UIScreen mainScreen] applicationFrame].size.width, 272)];
        
//        _boardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(height-272,0,272,width)];
//        _boardWindow.backgroundColor = [UIColor greenColor];
//        _boardWindow.windowLevel = 3000;
//        _boardWindow.clipsToBounds = NO;
//        [_boardWindow makeKeyAndVisible];
        
        _boardWindow = [UIApplication sharedApplication].keyWindow;
        _boardView = [BottomView viewFromDefaultXib];
        _boardView.frame = CGRectMake(0, height - 272, width, 272);
//        _boardView.autoresizingMask = UIViewAutoresizingNone;
        _boardView.userInteractionEnabled = YES;
        [_boardWindow addSubview:_boardView];
    }
    return self;
}

@end

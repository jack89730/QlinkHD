//
//  LeftBoard.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-9.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "LeftBoard.h"
#import "LeftView.h"
#import "UIView+xib.h"

static LeftBoard *__board = nil;

@implementation LeftBoard
{
    UIWindow        *_boardWindow;
    LeftView      *_boardView;
}

+ (LeftBoard *)defaultLeftBoard{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        __board = [[LeftBoard alloc] init];
    });
    return __board;
}

- (id)init{
    self = [super init];
    if (self) {
        NSInteger height = [[UIScreen mainScreen] bounds].size.height;
//        NSInteger width = [[UIScreen mainScreen] bounds].size.width;
        
        NSLog(@"w=%f,h=%f",[[UIScreen mainScreen] applicationFrame].size.width,[[UIScreen mainScreen] applicationFrame].size.height);
        
        //        _boardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] applicationFrame].size.height - 272,[[UIScreen mainScreen] applicationFrame].size.width, 272)];
        
        //        _boardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(height-272,0,272,width)];
        //        _boardWindow.backgroundColor = [UIColor greenColor];
        //        _boardWindow.windowLevel = 3000;
        //        _boardWindow.clipsToBounds = NO;
        //        [_boardWindow makeKeyAndVisible];
        
        _boardWindow = [UIApplication sharedApplication].keyWindow;
        _boardView = [LeftView viewFromDefaultXib];
        _boardView.frame = CGRectMake(-139, (height - 456 - 272 + 66), 189, 456);
        _boardView.userInteractionEnabled = YES;
//        _boardView.isHidden = YES;
        [_boardView setActionRightPressed:^(BOOL isHidden) {
            if (isHidden) {//要隐藏
                [UIView animateWithDuration:0.2 animations:^{
                    _boardView.frame = CGRectMake(-139, (height - 456 - 272 + 66), 189, 456);
                }completion:^(BOOL finished) {
                    _boardView.frame = CGRectMake(0, (height - 456 - 272 + 66), 189, 456);
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    _boardView.frame = CGRectMake(0, (height - 456 - 272 + 66), 189, 456);
                }completion:^(BOOL finished) {
                    _boardView.frame = CGRectMake(-139, (height - 456 - 272 + 66), 189, 456);
                }];
            }
        }];
        [_boardWindow addSubview:_boardView];
    }
    return self;
}
@end

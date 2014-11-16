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

#define degreesToRadian(x) (M_PI * (x) / 180.0)

static LeftBoard *__board = nil;

@interface LeftBoard()

@property (nonatomic,retain) LeftView *boardView;

@end

@implementation LeftBoard
{
    UIWindow        *_boardWindow;
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
        
        define_weakself;
        
        _boardWindow = [UIApplication sharedApplication].keyWindow;
        _boardWindow.backgroundColor = [UIColor blackColor];
        self.boardView = [LeftView viewFromDefaultXib];
        if (!IOS8_OR_LATER) {
            self.boardView.frame = CGRectMake(340, -276, 189, 456);
            self.boardView.backgroundColor = [UIColor clearColor];
            self.boardView.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
            [self.boardView setActionRightPressed:^() {
                float y = weakSelf.boardView.frame.origin.y;
                if ( y < 0) {//显示
                    [UIView animateWithDuration:0.2 animations:^{
                        weakSelf.boardView.frame = CGRectMake(200, 0,456,189);
                    }completion:nil];
                } else {//隐藏
                    [UIView animateWithDuration:0.2 animations:^{
                        weakSelf.boardView.frame = CGRectMake(200, -139 , 456,189);
                    }completion:nil];
                }
            }];
        } else {
            int x = -139,y = height - 456 - 272 + 66;
            self.boardView.frame = CGRectMake(x, y, 189, 456);
            [self.boardView setActionRightPressed:^() {
                float x = weakSelf.boardView.frame.origin.x;
                if (x < 0) {
                    [UIView animateWithDuration:0.2 animations:^{
                        weakSelf.boardView.frame = CGRectMake(0, (height - 456 - 272 + 66), 189, 456);
                    }completion:nil];
                } else {
                    [UIView animateWithDuration:0.2 animations:^{
                        weakSelf.boardView.frame = CGRectMake(-139, (height - 456 - 272 + 66), 189, 456);
                    }completion:nil];
                }
            }];
        }
        [_boardWindow addSubview:self.boardView];
//        [_boardWindow makeKeyAndVisible];
    }
    return self;
}
@end

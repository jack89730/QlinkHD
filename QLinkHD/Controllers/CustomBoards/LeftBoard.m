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

        _boardWindow = [UIApplication sharedApplication].keyWindow;
        _boardWindow.backgroundColor = [UIColor redColor];
        self.boardView = [LeftView viewFromDefaultXib];
        self.boardView.frame = CGRectMake(-139, (height - 456 - 272 + 66), 189, 456);
        define_weakself;
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
        [_boardWindow addSubview:self.boardView];
    }
    return self;
}
@end

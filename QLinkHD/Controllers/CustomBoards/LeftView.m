//
//  LeftView.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-10.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "LeftView.h"

@implementation LeftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnRightPressed:(id)sender
{
    if (self.actionRightPressed) {
        self.actionRightPressed();
    }
}

@end

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
    NSLog(@"33333");
    
    if (self.actionRightPressed) {
        self.isHidden = !self.isHidden;
        self.actionRightPressed(self.isHidden);
    }
}

@end

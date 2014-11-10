//
//  LeftView.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-10.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftView : UIView

@property(nonatomic,assign) BOOL isHidden;
@property (copy, nonatomic) void (^actionRightPressed)(BOOL isHidden);
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@end

//
//  QuickOperDeviceChooseView.h
//  QLinkHD
//
//  Created by 尤日华 on 14-12-4.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickOperDeviceChooseView : UIView

@property(nonatomic,copy) void(^confirmPressed)(NSString *deviceId);

@end

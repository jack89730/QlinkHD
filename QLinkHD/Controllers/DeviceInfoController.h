//
//  DeviceInfoController.h
//  QLinkHD
//
//  Created by 尤日华 on 15-1-31.
//  Copyright (c) 2015年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceInfoController : UIViewController<SBLoader>

@property(nonatomic,retain) NSString *deviceId;
@property(nonatomic,retain) NSString *deviceName;

@end

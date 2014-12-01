//
//  LightViewController.h
//  QLinkHD
//
//  Created by 尤日华 on 14-12-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwView1.h"
#import "BaseViewController.h"
#import "LightBcView.h"
#import "LightBbView.h"
#import "LightBriView.h"

@interface LightViewController : BaseViewController<Sw1Delegate,LightBcViewDelegate,LightBbViewDelegate,LightBriViewDelegate>

@end

//
//  RemoteViewController.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-30.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwView.h"
#import "DtView.h"
#import "McView.h"
#import "PlView.h"
#import "SdView.h"
#import "OtView.h"
#import "HsView.h"
#import "NmView.h"
#import "BsTcView.h"
#import "TrView.h"
#import "BaseViewController.h"
#import "StudyTimerView.h"

@interface RemoteViewController : BaseViewController<SwViewDelegate,DtViewDelegate,McViewDelegate,PlViewDelegate,SdViewDelegate,OtViewDelegate,HsViewDelegate,NmViewDelegate,BsTcViewDelegate,TrViewDelegate>

@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic,strong) NSString *deviceName;

@end

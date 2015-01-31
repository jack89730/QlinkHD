//
//  LoginViewController.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupIpViewController.h"

@interface LoginViewController : SetupIpViewController<UITextFieldDelegate,SBLoader>

@property (weak, nonatomic) IBOutlet UITextField *tfKey;
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfUserPwd;

@end

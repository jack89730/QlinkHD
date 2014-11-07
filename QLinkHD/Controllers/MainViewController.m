//
//  MainViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "MainViewController.h"
#import "BottomBoard.h"
#import "BottomView.h"
#import "UIView+xib.h"

@implementation MainViewController

+(id)loadFromSB
{
    MainViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
    return vc;
}

- (void)viewDidLoad
{
    [self initNavigation];
    
    [self initCommonUI];
}

-(void)initCommonUI
{
    [BottomBoard defaultBottomBoard];
}

//设置导航
-(void)initNavigation
{
    [self.navigationController.navigationBar setHidden:NO];
}

@end

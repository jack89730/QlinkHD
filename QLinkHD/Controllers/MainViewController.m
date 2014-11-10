//
//  MainViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "MainViewController.h"
#import "BottomBoard.h"
#import "LeftBoard.h"
#import "BottomView.h"
#import "UIView+xib.h"
#import "UIButton+image.h"

#import "LeftView.h"

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
    [LeftBoard defaultLeftBoard];
}

//设置导航
-(void)initNavigation
{
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setHidden:NO];
    
//    UIImage * imgOn = [UIImage imageNamed:@"Common_返回键01"];
//    UIImage * imgOff = [UIImage imageNamed:@"Common_返回键02"];
//    UIBarButtonItem * btnBack =  [UIBarButtonItem barItemWithImage:imgOn
//                                                      highlightImage:imgOff
//                                                              target:self
//                                                        withAction:@selector(actionBack)];
//    self.navigationItem.rightBarButtonItem = btnBack;
}

//-(void)actionBack
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end

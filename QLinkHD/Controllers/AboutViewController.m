//
//  AboutViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-12-2.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "AboutViewController.h"
#import "UIButton+image.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

+(id)loadFromSB
{
    AboutViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
}

//设置导航
-(void)initNavigation
{
    self.title = @"关于";
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setHidden:NO];
    
    UIImage * imgOn = [UIImage imageNamed:@"Common_返回键01"];
    UIImage * imgOff = [UIImage imageNamed:@"Common_返回键02"];
    UIBarButtonItem * btnBack =  [UIBarButtonItem barItemWithImage:imgOn
                                                    highlightImage:imgOff
                                                            target:self
                                                        withAction:@selector(actionBack)];
    self.navigationItem.rightBarButtonItem = btnBack;
}

-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

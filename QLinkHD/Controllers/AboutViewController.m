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
@property (weak, nonatomic) IBOutlet UILabel *lblAppVerson;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblCjName;
@property (weak, nonatomic) IBOutlet UILabel *lblCjAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblCjTel;
@property (weak, nonatomic) IBOutlet UILabel *lblPerson;

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
    
    [self initData];
}

-(void)initData
{
    Control *control = [SQLiteUtil getControlObj];
    
    self.lblAppVerson.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    self.lblVersion.text = control.Updatever;
    self.lblCjName.text = control.Jsname;
    self.lblCjAddress.text = control.Jsaddess;
    self.lblCjTel.text = control.Jstel;
    self.lblPerson.text = control.Jsuname;
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

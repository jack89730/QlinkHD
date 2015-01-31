//
//  RegisterViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 15-1-31.
//  Copyright (c) 2015年 SANSAN. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetworkUtil.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "DataUtil.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfKey;
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfUserPwd;
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UITextField *tfUserPwdTwo;

@end

@implementation RegisterViewController

+(id)loadFromSB
{
    RegisterViewController * vc = [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    return vc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUI];
    
    [self registerObserver];
}

-(void)setUI
{
    self.tfUserPwd.secureTextEntry = YES;
    self.tfUserPwdTwo.secureTextEntry = YES;
    [self.tfKey setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    [self.tfUserName setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    [self.tfUserPwd setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    [self.tfUserPwdTwo setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    
    Control *control = [SQLiteUtil getControlObj];
    if (control && control.Jsname) {
        if (control.Jslogo) {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:@"logo.png"]];
            self.ivLogo.image = image;
        }
    }
}

//TODO:初始化
-(void)registerObserver{
    //注册键盘出现与隐藏时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboadWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark -
#pragma mark 通知注册

//键盘出现时候调用的事件
-(void) keyboadWillShow:(NSNotification *)note{
    [UIView animateWithDuration:0.2 animations:^(void){
        self.view.bounds = CGRectMake(0,190, self.view.bounds.size.width,self.view.bounds.size.height);
    }];
}

//键盘消失时候调用的事件
-(void)keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.2 animations:^(void){
        self.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    }];
}

- (IBAction)actionRegister:(id)sender
{
    NSString *mobile = self.tfUserName.text;
    NSString *pwd = self.tfUserPwd.text;
    NSString *pwd1 = self.tfUserPwdTwo.text;
    if ([DataUtil checkNullOrEmpty:mobile] || [DataUtil checkNullOrEmpty:pwd] || [DataUtil checkNullOrEmpty:pwd1]) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"请输入完整信息"];
        return;
    }
    if (![DataUtil isValidateMobile:mobile]) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"请输入正确的手机号"];
        return;
    }
    if (pwd.length < 6) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"密码最少6位"];
        return;
    }
    if (![pwd isEqualToString:pwd1]) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"两次密码输入不一致"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    
    NSString *sUrl = [NetworkUtil getRegisterUrl:mobile andPwd:pwd andICode:self.tfKey.text];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    define_weakself;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *sConfig = [[NSString alloc] initWithData:responseObject encoding:[DataUtil getGB2312Code]];
         NSRange range = [sConfig rangeOfString:@"error"];
         if (range.location != NSNotFound)
         {
             NSArray *errorArr = [sConfig componentsSeparatedByString:@":"];
             if (errorArr.count > 1) {
                 [SVProgressHUD showErrorWithStatus:errorArr[1]];
                 return;
             }
         }
         
         [SVProgressHUD showSuccessWithStatus:@"注册成功"];
         
         NSArray *infoArr = [sConfig componentsSeparatedByString:@":"];
         weakSelf.loginVC.tfKey.text = infoArr[1];
         weakSelf.loginVC.tfUserName.text = mobile;
         weakSelf.loginVC.tfUserPwd.text = pwd;
         [self.navigationController popViewControllerAnimated:YES];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         [UIAlertView alertViewWithTitle:@"温馨提示" message:@"请检查网络链接"];
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.background = QLImage(@"login_tfBg02");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.background = QLImage(@"login_tfBg");
}

#pragma mark -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

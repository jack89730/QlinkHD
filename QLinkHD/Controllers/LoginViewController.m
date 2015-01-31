//
//  LoginViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "LoginViewController.h"
#import "Model.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "RegisterViewController.h"

@interface LoginViewController ()
{
    Member *_loginMember;
}

@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnRemeber;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;

@end

@implementation LoginViewController

+(id)loadFromSB
{
    LoginViewController * vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpUI];
    
    [self registerObserver];
}

-(void)setUpUI
{
    self.tfUserPwd.secureTextEntry = YES;
    [self.tfKey setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    [self.tfUserName setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    [self.tfUserPwd setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    
    //设置文本框值
    Member *member = [Member getMember];
    if (member && member.isRemeber) {
        self.tfKey.text = member.uKey;
        self.tfUserName.text = member.uName;
        self.tfUserPwd.text = member.uPwd;
        self.btnRemeber.selected = member.isRemeber;
    }
    
    Control *control = [SQLiteUtil getControlObj];
    if (control && control.Jsname) {
        if (control.Jsname) {
            self.lblCompany.text = control.Jsname;
        }
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
        self.view.bounds = CGRectMake(0,120, self.view.bounds.size.width,self.view.bounds.size.height);
    }];
}

//键盘消失时候调用的事件
-(void)keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.2 animations:^(void){
        self.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    }];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)btnRemeberPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)btnRegisterPressed:(id)sender
{
//    [UIAlertView alertViewWithTitle:@"温馨提示"
//                            message:@"即将跳转浏览器打开QLINK网站\n须从站点注册(需要邀请码)"
//                  cancelButtonTitle:@"取消"
//                  otherButtonTitles:@[@"确定"]
//                          onDismiss:^(int index){
//                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://qlink.cc/?action=apple"]];
//    }onCancel:nil];
    
    RegisterViewController *registerVC = [RegisterViewController loadFromSB];
    registerVC.loginVC = self;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)btnLoginPressed:(UIButton *)sender
{
    //判断登录是否为空
    if ([DataUtil checkNullOrEmpty:self.tfKey.text] || [DataUtil checkNullOrEmpty:self.tfUserName.text] || [DataUtil checkNullOrEmpty:self.tfUserPwd.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请输入完整的信息"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    //当前登录信息
    _loginMember = [Member new];
    _loginMember.uKey = self.tfKey.text;
    _loginMember.uName = self.tfUserName.text;
    _loginMember.uPwd = self.tfUserPwd.text;
    _loginMember.isRemeber = self.btnRemeber.selected;
    self.pLoginMember = _loginMember;
    
    [SVProgressHUD showWithStatus:@"正在验证..."];
    
    NSString *sUrl = [NetworkUtil getActionLogin:self.tfUserName.text andUPwd:self.tfUserPwd.text andUKey:self.tfKey.text];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    define_weakself;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *sConfig = [[NSString alloc] initWithData:responseObject encoding:[DataUtil getGB2312Code]];
         if ([sConfig containsString:@"error"]) {
             NSArray *errorArr = [sConfig componentsSeparatedByString:@":"];
             if (errorArr.count > 1) {
                 [SVProgressHUD showErrorWithStatus:errorArr[1]];
                 return;
             }
         }
         
         NSArray *configArr = [sConfig componentsSeparatedByString:@"|"];
         if ([configArr count] < 2) {
             [SVProgressHUD showErrorWithStatus:@"您输入的信息有误,请联系厂家"];
             return;
         }
         
         //处理返回结果的配置信息
         Config *configTempObj = [Config getTempConfig:configArr];
         weakSelf.pConfigTemp = configTempObj;
         
         if ([DataUtil isWifiNewWork]) {
             if (!configTempObj.isSetIp) {//需要配置ip
                 [weakSelf fetchIp];
             } else {
                 [weakSelf loadActionNULL];
             }
         } else {
             [weakSelf loadActionNULL];
         }
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         weakSelf.pConfigTemp = [Config getConfig];
         [weakSelf loadActionNULL];
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
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
#pragma mark Custom Methods

-(void)fetchIp
{
    [SVProgressHUD showWithStatus:@"正在配置ip..."];
    
    NSString *sUrl = [NetworkUtil handleIpRequest:self.pLoginMember];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    define_weakself;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *strResult = operation.responseString;
         if ([strResult containsString:@"error"]) {
             NSArray *errorArr = [strResult componentsSeparatedByString:@":"];
             if (errorArr.count > 1) {
                 [SVProgressHUD showErrorWithStatus:errorArr[1]];
                 return;
             }
         }
         
         [weakSelf requestSetUpIp];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [weakSelf loadActionNULL];
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)requestSetUpIp
{
    NSString *sUrl = [NetworkUtil getSetUpIp:_loginMember.uName andPwd:_loginMember.uPwd andKey:_loginMember.uKey];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    define_weakself;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *strXML = [[NSString alloc] initWithData:responseObject encoding:[DataUtil getGB2312Code]];
         strXML = [strXML stringByReplacingOccurrencesOfString:@"\"GB2312\"" withString:@"\"utf-8\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,40)];
         NSData *newData = [strXML dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSDictionary dictionaryWithXMLData:newData];
         
         if ([strXML containsString:@"error"]) {
             NSArray *errorArr = [strXML componentsSeparatedByString:@":"];
             if (errorArr.count > 1) {
                 [weakSelf loadActionNULL];
                 return;
             }
         }
         
         if (!dict) {
//             [SVProgressHUD showErrorWithStatus:@"配置ip出错,请重试."];
             
             [weakSelf loadActionNULL];
             
             return;
         }
         
         //设置Ip Socket
         [weakSelf load_setIpSocket:dict];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         [SVProgressHUD showErrorWithStatus:@"配置ip出错,请重试."];
         [weakSelf loadActionNULL];
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}


#pragma mark -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

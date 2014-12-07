//
//  SenceConfigViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "SenceConfigViewController.h"
#import "UIButton+image.h"
#import "SenceConfigCell.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "RenameView.h"
#import "UIView+xib.h"
#import "MainViewController.h"

@interface SenceConfigViewController ()
{
    NSString *senceIdModify;//修改的场景ID
    NSString *senceNameModify;
    
    NSMutableArray *senceConfigArr;
    NSArray *iconArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tbConfig;
@property (weak, nonatomic) RenameView *renameView;

@end

@implementation SenceConfigViewController

+(id)loadFromSB
{
    SenceConfigViewController * vc = [[UIStoryboard storyboardWithName:@"SenceConfig" bundle:nil] instantiateViewControllerWithIdentifier:@"SenceConfigViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setUI];
    
    [self initData];
}

//设置导航
-(void)initNavigation
{
    self.title = @"场景配置";
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

-(void)setUI
{
    [self.tbConfig setEditing:YES animated:YES];
    self.tbConfig.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)initData
{
    iconArr = [DataUtil getIconList:IconTypeAll];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    senceIdModify = [ud objectForKey:@"SenceId"];
    senceNameModify = [ud objectForKey:@"SenceName"];
    
    senceConfigArr = [NSMutableArray array];
    if (![DataUtil checkNullOrEmpty:senceIdModify]) {
        [senceConfigArr addObjectsFromArray:[SQLiteUtil getOrderBySenceId:senceIdModify]];
    }
    
    [senceConfigArr addObjectsFromArray:[SQLiteUtil getShoppingCarOrder]];
    
    [self.tbConfig reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [senceConfigArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SenceConfigCell";
    //自定义UITableGridViewCell，里面加了个NSArray用于放置里面的3个图片按钮
    SenceConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SenceConfigCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Sence *obj = senceConfigArr[indexPath.row];
    NSString *type = obj.IconType;
    if ([DataUtil checkNullOrEmpty:type]) {
        type = obj.Type;
    }
    
    //处理‘点动’和‘翻转’的图标
    if ([@[@"light_1",@"light_check",@"light_bri",@"light_bc"] containsObject:type]) {
        type = @"light";
    }
    if (![iconArr containsObject:type]) {
        type = @"other";
    }
    
    [cell setIcon:type andDeviceName:obj.SenceName andOrderName:obj.OrderName andTime:obj.Timer];
    define_weakself;
    [cell setDeleteCellPressed:^{
        BOOL bResult = [SQLiteUtil removeShoppingCarByOrderId:obj.OrderId];
        if (bResult) {
            [senceConfigArr removeObject:obj];
            [weakSelf.tbConfig reloadData];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //更新数据的顺序
    Sence *objToMove = [senceConfigArr objectAtIndex:sourceIndexPath.row];
    
    [senceConfigArr removeObjectAtIndex:sourceIndexPath.row];
    
    [senceConfigArr insertObject:objToMove atIndex:destinationIndexPath.row];
}


#pragma mark -

- (IBAction)btnSaveSence:(id)sender
{
    if ([senceConfigArr count] == 0) {
        
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"您还没有构建场景"];

        return;
    }
    
    self.renameView = [RenameView viewFromDefaultXib];
    self.renameView.frame = CGRectMake(0, 0, 1024, 768);
    self.renameView.backgroundColor = [UIColor clearColor];
    self.renameView.tfContent.text = senceNameModify;
    define_weakself;
    [self.renameView setCanclePressed:^{
        [weakSelf.renameView removeFromSuperview];
    }];
    [self.renameView setConfirmPressed:^(UILabel *lTitle,NSString *newName){
        NSString *orderIds = @"";
        NSString *times = @"";
        for (int i = 0; i < [senceConfigArr count]; i++) {
            Sence *obj = [senceConfigArr objectAtIndex:i];
            
            if ([DataUtil checkNullOrEmpty:orderIds]) {
                orderIds = obj.OrderId;
            }else{
                orderIds = [NSString stringWithFormat:@"%@,%@",orderIds,obj.OrderId];
            }
            if ([DataUtil checkNullOrEmpty:times]) {
                times = obj.Timer;
            }else{
                times = [NSString stringWithFormat:@"%@,%@",times,obj.Timer];
            }
        }
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeClear];
        
        NSString *sUrl = [NetworkUtil getEditSence:senceIdModify andSenceName:weakSelf.renameView.tfContent.text andCmd:orderIds andTime:times];
        
        NSURL *url = [NSURL URLWithString:sUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString *sResult = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             
             NSString *ordercmd = [NSString stringWithFormat:@"%@|%@",orderIds,times];
             
             NSArray *arr = [sResult componentsSeparatedByString:@","];
             if ([arr count] > 1) {//新增
                 if ([[[arr objectAtIndex:0] lowercaseString] isEqualToString:@"ok"]) {
                     Sence *obj = [[Sence alloc] init];
                     obj.SenceId = [arr objectAtIndex:1];
                     obj.SenceName = newName;
                     obj.Macrocmd = [arr objectAtIndex:2];
                     obj.CmdList = ordercmd;
                     [SQLiteUtil insertSence:obj];
                     
                     //刷新数据库
                     [DataUtil setUpdateInsertSenceInfo:@"" andSenceName:@""];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSenceTab" object:nil];
                     
                     Config *configObj = [Config getConfig];
                     if (configObj.isBuyCenterControl) {
                         //写入中控
                         self.zkOperType = ZkOperSence;
                         [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
                     }else{
                         //页面跳转
                         NSArray * viewcontrollers = self.navigationController.viewControllers;
                         int idxInStack = 0;
                         for (int i=0; i<[viewcontrollers count]; i++) {
                             if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
                                 idxInStack = i;
                                 break;
                             }
                         }
                         
                         [SVProgressHUD dismiss];
                         
                         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
                     }
                 } else {
                     [SVProgressHUD showErrorWithStatus:@"添加场景失败"];
                 }
             } else { //编辑
                 if ([[[arr objectAtIndex:0] lowercaseString] isEqualToString:@"ok"]) {
                     
                     //更新数据库
                     [SQLiteUtil updateCmdListBySenceId:senceIdModify andSenceName:newName andCmdList:ordercmd];
                     
                     [DataUtil setUpdateInsertSenceInfo:@"" andSenceName:@""];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSenceTab" object:nil];
                     
                     Config *configObj = [Config getConfig];
                     if (configObj.isBuyCenterControl) {
                         //写入中控
                         self.zkOperType = ZkOperSence;
                         [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
                     }else{
                         //页面跳转
                         NSArray * viewcontrollers = self.navigationController.viewControllers;
                         int idxInStack = 0;
                         for (int i=0; i<[viewcontrollers count]; i++) {
                             if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
                                 idxInStack = i;
                                 break;
                             }
                         }
                          [SVProgressHUD dismiss];
                         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
                     }
                 } else {
                     [SVProgressHUD showErrorWithStatus:@"更新场景失败"];
                 }
             }
             [weakSelf.renameView removeFromSuperview];
         }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD dismiss];
         }];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.renameView];
}

- (IBAction)btnContinue:(id)sender
{
    if (![DataUtil checkNullOrEmpty:senceIdModify]) {//修改
        [DataUtil setGlobalIsAddSence:YES];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnCancle:(id)sender
{
    [UIAlertView alertViewWithTitle:@"温馨提示"
                            message:@"确定要取消本次操作吗?"
                  cancelButtonTitle:@"取消"
                  otherButtonTitles:@[@"确定"]
                          onDismiss:^(int buttonIndex){
                              BOOL bResult = [SQLiteUtil removeShoppingCar];
                              if (bResult) {
                                  [DataUtil setGlobalIsAddSence:NO];//设置当前为非添加模式
                                  //页面跳转
                                  NSArray * viewcontrollers = self.navigationController.viewControllers;
                                  int idxInStack = 0;
                                  for (int i=0; i<[viewcontrollers count]; i++) {
                                      if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
                                          idxInStack = i;
                                          break;
                                      }
                                  }
                                  [SVProgressHUD dismiss];
                                  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:NO];
                                  
                              } else {
                                  [UIAlertView alertViewWithTitle:@"温馨提示" message:@"操作失败,请稍后再试."];
                              }
                          }onCancel:nil];
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

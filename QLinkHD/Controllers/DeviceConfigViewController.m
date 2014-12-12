//
//  DeviceConfigViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-18.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "DeviceConfigViewController.h"
#import "UIButton+image.h"
#import "IconCollectionCell.h"
#import "DataUtil.h"
#import "ActionNullClass.h"
#import "MainViewController.h"

@interface DeviceConfigViewController () <ActionNullClassDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cvDeviceConfig;

@end

@implementation DeviceConfigViewController
{
    NSArray *deviceArr;
    NSMutableDictionary *deviceConfigIconDic;
    NSMutableArray *iconArr;
    
    NSString *typeTag;
    NSString *tabName;
    UIButton *btnIconSel;
}

+(id)loadFromSB
{
    DeviceConfigViewController * vc = [[UIStoryboard storyboardWithName:@"Icon" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceConfigViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    typeTag = @"_producttype";
    tabName = @"kfsetup";
    
    [self initNavigation];
    
    [self initIconData];
    
    [self initRequest:[NetworkUtil getAction:ACTIONSETUP]];
}

-(void)initIconData
{
    deviceConfigIconDic = [DataUtil getDeviceConfigIconList];
    iconArr = [DataUtil getIconList:IconTypeAll];
}

//设置导航
-(void)initNavigation
{
    self.title = @"您拥有的设备";
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

-(void)initRequest:(NSString *)sUrl
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         btnIconSel.selected = NO;
         
         NSString *sResult = [[NSString alloc] initWithData:responseObject encoding:[DataUtil getGB2312Code]];
         
         if ([sResult containsString:@"error"]) {
             NSArray *errorArr = [sResult componentsSeparatedByString:@":"];
             if (errorArr.count > 1) {
                 [SVProgressHUD showErrorWithStatus:errorArr[1]];
                 return;
             }
         }
         
         if (![DataUtil checkNullOrEmpty:sResult]) {
             if ([sResult isEqualToString:@"ok"]) {
                 ActionNullClass *actionNullClass = [[ActionNullClass alloc] init];
                 actionNullClass.delegate = self;
                 [actionNullClass requestActionNULL];
             } else {
                 if (sResult.length < 40) {
                     [SVProgressHUD showErrorWithStatus:@"返回错误."];
                     
                     return;
                 }
                 sResult = [sResult stringByReplacingOccurrencesOfString:@"\"GB2312\"" withString:@"\"utf-8\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,40)];
                 NSData *newData = [sResult dataUsingEncoding:NSUTF8StringEncoding];
                 
                 NSDictionary *dict = [NSDictionary dictionaryWithXMLData:newData];
                 
                 if (!dict) {
                    [SVProgressHUD showErrorWithStatus:@"配置出错,请重试"];
                     
                     return;
                 }
                 NSDictionary *info = [dict objectForKey:@"info"];
                 deviceArr = [DataUtil changeDicToArray:[info objectForKey:tabName]];
                 [self.cvDeviceConfig reloadData];
                 
                 [SVProgressHUD dismiss];
             }
         } else {
             [SVProgressHUD showErrorWithStatus:@"配置出错,请重试"];
             
             return;
         }
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         btnIconSel.selected = NO;
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"连接失败\n请确认网络是否连接." delegate:nil
                                                   cancelButtonTitle:@"关闭"
                                                   otherButtonTitles:nil, nil];
         [alertView show];
         
         [SVProgressHUD dismiss];
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark - UICollectionViewDataSouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return deviceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *setDic = deviceArr[indexPath.row];
    //功能cell
    IconCollectionCell * iconCell = nil;
    iconCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IconCellIdentifier" forIndexPath:indexPath];
    
    NSString *imgName = @"";
    NSString *imgNameSel = @"";
    if ([tabName isEqualToString:@"kfsdevice"]) {
        NSString *type = [setDic objectForKey:@"_type"];
        if (![iconArr containsObject:type]) {
            type = @"other";
        }
        //处理‘点动’和‘翻转’的图标
        if ([type isEqualToString:@"light_1"] || [type isEqualToString:@"light_check"] || [type isEqualToString:@"light_bri"]) {
            type = @"light";
        }
        imgName = type;
        imgNameSel = [NSString stringWithFormat:@"%@02",type];
    }else{
        NSString *type = [deviceConfigIconDic objectForKey:[setDic objectForKey:typeTag]];
        imgName = type;
        imgNameSel = [NSString stringWithFormat:@"%@02",type];
    }
    
    [iconCell fillViewValue:imgName andImgSel:imgNameSel andTitle:[setDic objectForKey:@"_name"]];
    
    //单击事件
    [iconCell setSinglePressed:^(UIButton *btnIcon){
        //设置图标选中
        btnIconSel.selected = NO;
        btnIcon.selected = YES;
        btnIconSel = btnIcon;
        
        //设置请求类型
        typeTag = @"_type";
        tabName = @"kfsdevice";
        
        //请求
        NSDictionary *setDic = [deviceArr objectAtIndex:indexPath.row];
        NSString *sUrl = [setDic objectForKey:@"_url"];
        [self initRequest:sUrl];
    }];
    return iconCell;
}

#pragma mark -
#pragma mark ActionNullClassDelegate

-(void)failOper
{
    NSString *curVersion = [SQLiteUtil getCurVersionNo];
    if (![DataUtil checkNullOrEmpty:curVersion]) {
        //读取本地配置
        [SQLiteUtil setDefaultLayerIdAndRoomId];
        
        MainViewController *mainVC = [[MainViewController alloc] init];
        [self.navigationController pushViewController:mainVC animated:NO];
    }else{
        [SVProgressHUD showErrorWithStatus:@"配置失败,请重试"];
    }
}

-(void)successOper
{
    [SVProgressHUD showSuccessWithStatus:@"配置完成."];
    [SQLiteUtil setDefaultLayerIdAndRoomId];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDeviceTab" object:nil];
    
    self.zkOperType = ZkOperDevice;
    [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
}

#pragma mark -

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

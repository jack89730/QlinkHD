//
//  RemoteViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-30.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "RemoteViewController.h"
#import "UIButton+image.h"
#import "SenceConfigViewController.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "UIView+xib.h"

#define JG 15

@interface RemoteViewController ()

@property(nonatomic,strong) StudyTimerView *studyView;

@end

@implementation RemoteViewController

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
    
    [self initNavigation];
    
    [self initControl];
}

//设置导航
-(void)initNavigation
{
    self.title = self.deviceName;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setHidden:NO];
    
 
    NSMutableArray *arrItem = [NSMutableArray array];
    BOOL isStudy = NO;
    if (![DataUtil getGlobalIsAddSence]) {
        if ([SQLiteUtil isStudyModel:_deviceId]) {
            UIImage * imgOn = [UIImage imageNamed:@"Bottom_set101"];
            UIImage * imgOff = [UIImage imageNamed:@"Bottom_set102"];
            UIBarButtonItem * btnStudy =  [UIBarButtonItem barItemWithImage1:imgOn
                                                             highlightImage1:imgOff
                                                                     target1:self
                                                                 withAction1:@selector(actionStudy)];
            [arrItem addObject:btnStudy];
            
            isStudy = YES;
        }
    }
    
    UIImage * imgOn = [UIImage imageNamed:@"Common_返回键01"];
    UIImage * imgOff = [UIImage imageNamed:@"Common_返回键02"];
    UIBarButtonItem * btnBack = nil;
    if (isStudy) {
        btnBack = [UIBarButtonItem barItemWithImage1:imgOn
                                     highlightImage1:imgOff
                                             target1:self
                                         withAction1:@selector(actionBack)];
    } else {
        btnBack = [UIBarButtonItem barItemWithImage:imgOn
                                     highlightImage:imgOff
                                             target:self
                                         withAction:@selector(actionBack)];
    }
    [arrItem addObject:btnBack];
 
    self.navigationItem.rightBarButtonItems = arrItem;
}

-(void)initControl
{
    //设置背景图
    UIImageView *ivBg = [[UIImageView alloc] initWithFrame:self.view.frame];
    ivBg.image = QLImage(@"Common_MainBg");
    [self.view addSubview:ivBg];

    int svHeight = [UIScreen mainScreen ].applicationFrame.size.height - 44 - 110 - 60;
    
    UIScrollView *svBg = [[UIScrollView alloc] init];
    svBg.frame = CGRectMake(80, 60, 864, svHeight);
    svBg.backgroundColor = [UIColor clearColor];
    svBg.showsVerticalScrollIndicator = false;
    [self.view addSubview:svBg];
    
    int heightLeft = 0;
    int heightMiddle = 0;
    BOOL isDtTopAddHeight = NO;//音量，频道，方向盘时有判断
    BOOL isDtBottomAddHeight = NO;//音量，频道，方向盘时有判断
    int dtTop = 0;//循环至Dt记录控件 top 距离
    
    BOOL isBsTcTopAddHeight = NO;// 低音，高音，方向盘时有判断
    BOOL isBsTcBottomAddHeight = NO;//低音，高音，方向盘时有判断
    int bsTcTop = 0;//循环至BsTc记录控件 top 距离
    
    NSArray *typeArr = [SQLiteUtil getOrderTypeGroupOrder:self.deviceId];
    for (Order *orderParentObj in typeArr) {
        NSArray *orderArr = [SQLiteUtil getOrderListByDeviceId:orderParentObj.DeviceId andType:orderParentObj.Type];
        
        if ([orderParentObj.Type isEqualToString:@"sw"]) {//sw开关
            heightMiddle += JG;
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"SwView" owner:self options:nil];
            SwView *swView = [controlArr objectAtIndex:0];
            swView.frame = CGRectMake(414, heightMiddle, 450, 49);
            swView.delegate = self;
            [svBg addSubview:swView];
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"on"]) {
                    swView.btnOn.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"off"]){
                    swView.btnOff.orderObj = obj;
                }
            }
            
            heightMiddle += 49;
            
        }else if ([orderParentObj.Type isEqualToString:@"ar"])//音量+-
        {
            if (!isDtTopAddHeight){
                heightMiddle += JG;
                dtTop = heightMiddle;
                isDtTopAddHeight = YES;
            }
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"DtView" owner:self options:nil];
            DtView *dtView = [controlArr objectAtIndex:0];
            dtView.frame = CGRectMake(414, dtTop, 105, 241);
            dtView.delegate = self;
            [svBg addSubview:dtView];
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"ad"]) {
                    dtView.btnAr_ad.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"rd"]){
                    dtView.btnAr_rd.orderObj = obj;
                }
            }
            
            if (!isDtBottomAddHeight){
                heightMiddle += 241;
                isDtBottomAddHeight = YES;
            }
        }else if ([orderParentObj.Type isEqualToString:@"dt"])//方向盘
        {
            if (!isDtTopAddHeight){
                heightMiddle += JG;
                dtTop = heightMiddle;
                isDtTopAddHeight = YES;
            }
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"DtView" owner:self options:nil];
            DtView *dtView = [controlArr objectAtIndex:1];
            dtView.frame = CGRectMake(519, dtTop, 241, 241);
            dtView.delegate = self;
            [svBg addSubview:dtView];
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"up"]) {
                    dtView.btnDt_up.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"down"]){
                    dtView.btnDt_down.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"left"]){
                    dtView.btnDt_left.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"right"]){
                    dtView.btnDt_right.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"ok"]){
                    dtView.btnDt_ok.orderObj = obj;
                }
            }
            
            if (!isDtBottomAddHeight){
                heightMiddle += 241;
                isDtBottomAddHeight = YES;
            }
            
        }else if ([orderParentObj.Type isEqualToString:@"pd"])//频道+-
        {
            if (!isDtTopAddHeight){
                heightMiddle += JG;
                dtTop = heightMiddle;
                isDtTopAddHeight = YES;
            }
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"DtView" owner:self options:nil];
            DtView *dtView = [controlArr objectAtIndex:2];
            dtView.frame = CGRectMake(760, dtTop, 104, 241);
            dtView.delegate = self;
            [svBg addSubview:dtView];
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"ad"]) {
                    dtView.btnPd_ad.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"rd"]){
                    dtView.btnPd_rd.orderObj = obj;
                }
            }
            
            if (!isDtBottomAddHeight){
                heightMiddle += 241;
                isDtBottomAddHeight = YES;
            }
            
        } else if ([orderParentObj.Type isEqualToString:@"tr"]) {//空调温度
            heightMiddle += JG;
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"TrView" owner:self options:nil];
            TrView *trView = [controlArr objectAtIndex:0];
            trView.frame = CGRectMake(414, heightMiddle, 450, 87);
            trView.delegate = self;
            [svBg addSubview:trView];
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"ad"]) {//升温
                    trView.btnSheng.orderObj = obj;
                } else if ([obj.SubType isEqualToString:@"rd"]) {//降温
                    trView.btnJiang.orderObj = obj;
                }
            }
            
            heightMiddle += 87;
            
        }else if ([orderParentObj.Type isEqualToString:@"mc"] || [orderParentObj.Type isEqualToString:@"mo"])//圆形按钮
        {
            heightLeft += JG;
            
            NSInteger iCount = [orderArr count];
            NSInteger iRowCount = iCount%4 == 0 ? iCount/4 : (iCount/4 + 1);
            
            for (int row = 0; row < iRowCount; row ++)
            {
                NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"McView" owner:self options:nil];
                McView *mcView = [controlArr objectAtIndex:0];
                mcView.frame = CGRectMake(0, heightLeft, 343, 65);
                mcView.delegate = self;
                [svBg addSubview:mcView];
                for (int cell = 0; cell < 4; cell ++) {
                    int index = 4 * row + cell;
                    if (index >= iCount) {
                        break;
                    }
                    
                    Order *obj = [orderArr objectAtIndex:index];
                    
                    OrderButton *btn = (OrderButton *)[mcView viewWithTag:(100 + cell)];
                    btn.orderObj = obj;
                    [btn setTitle:obj.OrderName forState:UIControlStateNormal];
                }
                
                heightLeft += 65 + 5;
            }
        }else if ([orderParentObj.Type isEqualToString:@"pl"])//播放器
        {
            heightLeft += JG;
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"PlView" owner:self options:nil];
            PlView *plView = [controlArr objectAtIndex:0];
            plView.frame = CGRectMake(0, heightLeft, 343, 163);
            plView.delegate = self;
            [svBg addSubview:plView];
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"backgo"]) {
                    plView.btnLeftBottom.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"fastgo"]){
                    plView.btnRightBottom.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"pash"]){
                    plView.btnLeftMiddle.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"play"]){
                    plView.btnMiddle.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"stop"]){
                    plView.btnRightMiddle.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"first"]){
                    plView.btnLeftTop.orderObj = obj;
                }else if ([obj.SubType isEqualToString:@"next"]){
                    plView.btnRightTop.orderObj = obj;
                }
            }
            
            heightLeft += 163;
            
        }else if ([orderParentObj.Type isEqualToString:@"sd"])//播放器
        {
            heightMiddle += JG;
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"SdView" owner:self options:nil];
            SdView *sdView = [controlArr objectAtIndex:0];
            sdView.frame = CGRectMake(414, heightMiddle, 450, 134);
            sdView.delegate = self;
            [svBg addSubview:sdView];
            
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"slow"]) {
                    sdView.btnTopLeft.orderObj = obj;
                    [sdView.btnTopLeft setTitle:obj.OrderName forState:UIControlStateNormal];
                }else if ([obj.SubType isEqualToString:@"mi"]){
                    sdView.btnTopMiddle.orderObj = obj;
                    [sdView.btnTopMiddle setTitle:obj.OrderName forState:UIControlStateNormal];
                }else if ([obj.SubType isEqualToString:@"fast"]){
                    sdView.btnTopRight.orderObj = obj;
                    [sdView.btnTopRight setTitle:obj.OrderName forState:UIControlStateNormal];
                }else if ([obj.SubType isEqualToString:@"auto"]){
                    sdView.btnBottomLeft.orderObj = obj;
                    [sdView.btnBottomLeft setTitle:obj.OrderName forState:UIControlStateNormal];
                }else if ([obj.SubType isEqualToString:@"chang"]){
                    sdView.btnBottomRight.orderObj = obj;
                    [sdView.btnBottomRight setTitle:obj.OrderName forState:UIControlStateNormal];
                }
            }
            
            heightMiddle += 134;
            
        }else if ([orderParentObj.Type isEqualToString:@"ot"])//一排两个按钮
        {
            heightMiddle += JG;
            
            NSInteger iCount = [orderArr count];
            NSInteger iRowCount = iCount%2 == 0 ? iCount/2 : (iCount/2 + 1);
            
            for (int row = 0; row < iRowCount; row ++)
            {
                NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"OtView" owner:self options:nil];
                OtView *otView = [controlArr objectAtIndex:0];
                otView.frame = CGRectMake(414, heightMiddle, 328, 45);
                otView.delegate = self;
                [svBg addSubview:otView];
                
                for (int cell = 0; cell < 2; cell ++) {
                    int index = 2 * row + cell;
                    if (index >= iCount) {
                        break;
                    }
                    
                    Order *obj = [orderArr objectAtIndex:index];
                    
                    OrderButton *btn = (OrderButton *)[otView viewWithTag:(100 + cell)];
                    btn.orderObj = [orderArr objectAtIndex:index];
                    [btn setTitle:obj.OrderName forState:UIControlStateNormal];
                }
                
                heightMiddle += 45 + 5;
            }
        }
        else if ([orderParentObj.Type isEqualToString:@"st"] || [orderParentObj.Type isEqualToString:@"gn"] || [orderParentObj.Type isEqualToString:@"hs"])//一排三个按钮
        {
            heightLeft += JG;
            
            NSInteger iCount = [orderArr count];
            NSInteger iRowCount = iCount%3 == 0 ? iCount/3 : (iCount/3 + 1);
            
            for (int row = 0; row < iRowCount; row++)
            {
                NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"HsView" owner:self options:nil];
                HsView *hsView = [controlArr objectAtIndex:0];
                hsView.frame = CGRectMake(0, heightLeft, 343, 45);
                hsView.delegate = self;
                [svBg addSubview:hsView];
                for (int cell = 0; cell < 3; cell ++) {
                    int index = 3 * row + cell;
                    if (index >= iCount) {
                        break;
                    }
                    
                    Order *obj = [orderArr objectAtIndex:index];
                    
                    OrderButton *btn = (OrderButton *)[hsView viewWithTag:(100 + cell)];
                    btn.orderObj = [orderArr objectAtIndex:index];
                    [btn setTitle:obj.OrderName forState:UIControlStateNormal];
                }
                
                heightLeft += 45 + 5;
            }
        }
        else if ([orderParentObj.Type isEqualToString:@"nm"]){//1-9数字键盘
            heightLeft += JG;
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"NmView" owner:self options:nil];
            NmView *nmView = [controlArr objectAtIndex:0];
            nmView.frame = CGRectMake(0, heightLeft, 343, 180);
            nmView.delegate = self;
            [svBg addSubview:nmView];
            
            for (int i = 0; i < [orderArr count]; i ++) {
                Order *obj = [orderArr objectAtIndex:i];
                
                OrderButton *btnOrder = (OrderButton *)[nmView viewWithTag:(100+i)];
                btnOrder.orderObj = obj;
                [btnOrder setTitle:obj.OrderName forState:UIControlStateNormal];
            }
            
            heightLeft += 180;
            
        }else if ([orderParentObj.Type isEqualToString:@"bs"]){// 低音
            
            if (!isBsTcTopAddHeight){
                heightMiddle += JG;
                bsTcTop = heightMiddle;
                isBsTcTopAddHeight = YES;
            }
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"BsTcView" owner:self options:nil];
            BsTcView *bstcView = [controlArr objectAtIndex:0];
            bstcView.frame = CGRectMake(414, bsTcTop, 145, 73);
            bstcView.delegate = self;
            [svBg addSubview:bstcView];
            
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"ad"]) {
                    bstcView.btnAd.orderObj = obj;
                }else if([obj.SubType isEqualToString:@"rd"]){
                    bstcView.btnRd.orderObj = obj;
                }
            }
            
            [bstcView.btnTitle setTitle:@"低音" forState:UIControlStateNormal];
            
            if (!isBsTcBottomAddHeight){
                heightMiddle += 73;
                isBsTcBottomAddHeight = YES;
            }
            
        }else if ([orderParentObj.Type isEqualToString:@"tc"]){// 高音
            if (!isBsTcTopAddHeight){
                heightMiddle += JG;
                bsTcTop = heightMiddle;
                isBsTcTopAddHeight = YES;
            }
            
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"BsTcView" owner:self options:nil];
            BsTcView *bstcView = [controlArr objectAtIndex:0];
            bstcView.frame = CGRectMake(719, bsTcTop, 145, 73);
            bstcView.delegate = self;
            [svBg addSubview:bstcView];
            
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"ad"]) {
                    bstcView.btnAd.orderObj = obj;
                }else if([obj.SubType isEqualToString:@"rd"]){
                    bstcView.btnRd.orderObj = obj;
                }
            }
            
            [bstcView.btnTitle setTitle:@"高音" forState:UIControlStateNormal];
            
            if (!isBsTcBottomAddHeight){
                heightMiddle += 73;
                isBsTcBottomAddHeight = YES;
            }
        }
    }
    
    int height = heightLeft > heightMiddle ? heightLeft : heightMiddle;
    
    [svBg setContentSize:CGSizeMake(864, height + 80)];
}

#pragma mark -
#pragma mark SwViewDelegate,DtViewDelegate,McViewDelegate,PlViewDelegate,SdViewDelegate,OtViewDelegate,HsViewDelegate,NmViewDelegate,BsTcViewDelegate,TrViewDelegate

-(void)orderDelegatePressed:(OrderButton *)sender
{
    if (!sender.orderObj) {
        return;
    }
    
    if ([DataUtil getGlobalIsAddSence]) {//添加场景模式
        if ([SQLiteUtil getShoppingCarCount] >= 40) {
            [UIAlertView alertViewWithTitle:@"温馨提示"
                                    message:@"最多添加40个命令,请删除后再添加."
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil
                                  onDismiss:nil
                                   onCancel:^{
                SenceConfigViewController *senceConfigVC = [SenceConfigViewController loadFromSB];
                [self.navigationController pushViewController:senceConfigVC animated:YES];
            }];
            
            return;
        }
        BOOL bResult = [SQLiteUtil addOrderToShoppingCar:sender.orderObj.OrderId andDeviceId:sender.orderObj.DeviceId];
        if (bResult) {
            [UIAlertView alertViewWithTitle:@"温馨提示"
                                    message:@"已成功添加命令,是否继续?"
                          cancelButtonTitle:@"继续"
                          otherButtonTitles:@[@"完成"]
                                  onDismiss:^(int buttonIndex){
                                      SenceConfigViewController *senceConfigVC = [SenceConfigViewController loadFromSB];
                                      [self.navigationController pushViewController:senceConfigVC animated:YES];
            }onCancel:nil];
        }
    } else {
        if ([[DataUtil getGlobalModel] isEqualToString:Model_Study]) {
            self.studyView = [StudyTimerView viewFromDefaultXib];
            self.studyView.frame = CGRectMake(0, 0, 1024, 768);
            self.studyView.backgroundColor = [UIColor clearColor];
            [self.studyView startTimer];
            define_weakself;
            [self.studyView setDoneBlock:^{
                [weakSelf.studyView removeFromSuperview];
                [DataUtil setGlobalModel:[DataUtil getTempGlobalModel]];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.studyView];
        }
        [self load_typeSocket:999 andOrderObj:sender.orderObj];
    }
}

-(void)actionStudy
{
    [UIAlertView alertViewWithTitle:@"操作"
                            message:@"是否要启用学习模式?"
                  cancelButtonTitle:@"关闭"
                  otherButtonTitles:@[@"学习模式"]
                          onDismiss:^(int buttonIndex){
                              [DataUtil setGlobalModel:Model_Study];
                              [SVProgressHUD showSuccessWithStatus:@"您已处于学习模式状态"];
    }onCancel:nil];
}

-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
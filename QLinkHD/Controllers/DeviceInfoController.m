//
//  DeviceInfoController.m
//  QLinkHD
//
//  Created by 尤日华 on 15-1-31.
//  Copyright (c) 2015年 SANSAN. All rights reserved.
//

#import "DeviceInfoController.h"
#import "UIButton+image.h"
#import "DeviceInfoCell.h"

@interface DeviceInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) NSArray *models;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lblIp;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblPort;

//@property(nonatomic,retain) DeviceInfoCell *propertyCell;

@end

@implementation DeviceInfoController

+(id)loadFromSB
{
    DeviceInfoController * vc = [[UIStoryboard storyboardWithName:@"DeviceInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceInfoController"];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavigation];
    
    [self loadData];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
//    self.propertyCell = [self.tableview dequeueReusableCellWithIdentifier:@"DeviceInfoCell"];
}

-(void)loadData
{
    self.models = [SQLiteUtil getOrderListByDeviceId:self.deviceId];
    
    if (self.models.count <= 0) {
        return;
    }
    
    for (Order *order in self.models) {
        if (![DataUtil checkNullOrEmpty:order.Address]) {
            NSArray *arrayOrderTips = [order.Address componentsSeparatedByString:@":"];
            if ([arrayOrderTips count] > 2) {
                self.lblType.text = arrayOrderTips[0];
                self.lblIp.text = arrayOrderTips[1];
                self.lblPort.text = arrayOrderTips[2];
            }
            break;
        }
    }
    self.lblDeviceName.text = self.deviceName;
}

//设置导航
-(void)initNavigation
{
    self.title = @"设备信息";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell"];
    Order *obj = self.models[indexPath.row];
    [cell bindCell:obj];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell"];
    if (!cell) {
        cell = [[DeviceInfoCell alloc] init];
    }
    Order *obj = self.models[indexPath.row];
    [cell bindCell:obj];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell setNeedsLayout];
//    使用此方法强制立即进行layout,从当前view开始，此方法会遍历整个view层次(包括superviews)请求layout。因此，调用此方法会强制整个view层次布局。
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}
- (IBAction)actionBack
{
     [self.navigationController popViewControllerAnimated:YES];
}


@end

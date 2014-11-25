//
//  IconViewController.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-16.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "IconViewController.h"
#import "UIButton+image.h"
#import "SQLiteUtil.h"

@interface IconViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *cvIcon;

@end

@implementation IconViewController
{
    NSArray *dataArr;
    UIButton *btnSel;
}

+(id)loadFromSB
{
    IconViewController * vc = [[UIStoryboard storyboardWithName:@"Icon" bundle:nil] instantiateViewControllerWithIdentifier:@"IconViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initData];
}

//设置导航
-(void)initNavigation
{
    self.title = @"图标设置";
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

-(void)initData
{
    dataArr = [DataUtil getIconList:self.pIconType];
    [self.cvIcon reloadData];
}

#pragma mark - UICollectionViewDataSouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //功能cell
    UICollectionViewCell * iconCell = nil;
    iconCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IconCellIdentifier" forIndexPath:indexPath];
    
    NSString *imgSel = [NSString stringWithFormat:@"%@02",dataArr[indexPath.row]];
    UIButton *btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnIcon.frame = CGRectMake(15, 10, 110, 110);
    btnIcon.tag = indexPath.row;
    [btnIcon setBackgroundImage:QLImage(dataArr[indexPath.row]) forState:UIControlStateNormal];
    [btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateSelected];
    [btnIcon addTarget:self action:@selector(btnIconPressed:) forControlEvents:UIControlEventTouchUpInside];
    [iconCell.contentView addSubview:btnIcon];
    
    return iconCell;
}

#pragma mark -

-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCancle:(id)sender
{
    [self actionBack];
}
- (IBAction)btnConfirm:(id)sender
{
    if (!btnSel) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请选择要更新的图标."
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    BOOL bResult = NO;
    if (self.pIconType == IconTypeDevice) {
        bResult = [SQLiteUtil changeIcon:self.pDeviceObj.DeviceId andType:self.pDeviceObj.Type andNewType:[dataArr objectAtIndex:btnSel.tag]];
    } else if(self.pIconType == IconTypeSence) {
        bResult = [SQLiteUtil changeIcon:self.pSenceObj.SenceId andType:self.pSenceObj.Type andNewType:[dataArr objectAtIndex:btnSel.tag]];
    }
    if (bResult) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"图标设置成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        if (self.delegate) {
            [self.delegate refreshTable];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"操作失败,请稍后再试."
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)btnIconPressed:(UIButton *)sender
{
    btnSel.selected = NO;
    sender.selected = YES;
    btnSel = sender;
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

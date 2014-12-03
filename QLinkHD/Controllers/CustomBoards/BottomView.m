//
//  BottomView.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-5.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "BottomView.h"
#import "IconCollectionCell.h"
#import "SenceCell.h"
#import "IconViewController.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "RenameView.h"
#import "UIView+xib.h"
#import "SenceConfigViewController.h"

@interface BottomView()<IconViewControllerDelegate>

@property (nonatomic, retain) RenameView *renameView;

@end

@implementation BottomView
{
    NSArray *dataArr;
    NSInteger sumPage;
    NSInteger pageIdx;
}

-(void)awakeFromNib
{
    UINib *cellNib = [UINib nibWithNibName:@"SenceCell" bundle:nil];
    [self.cvSence registerNib:cellNib forCellWithReuseIdentifier:@"SenceCell"];
    
    self.cvSence.delegate = self;
    self.cvSence.dataSource = self;
    
    [self initData];
}

-(void)initData
{
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    dataArr = [SQLiteUtil getSenceList:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId];
    
    [self.cvSence reloadData];
    
    pageIdx = 1;
    NSString *sWidth = [NSString stringWithFormat:@"%f",self.cvSence.collectionViewLayout.collectionViewContentSize.width];
    NSString *sFrameWidth = [NSString stringWithFormat:@"%f",self.cvSence.frame.size.width];
    NSInteger yu = [sWidth integerValue] % [sFrameWidth integerValue];
    sumPage = self.cvSence.collectionViewLayout.collectionViewContentSize.width/self.cvSence.frame.size.width;
    if (yu > 0) {
        sumPage += 1;
    }
}

#pragma mark - UICollectionViewDataSouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Sence *obj = dataArr[indexPath.row];
    //功能cell
    SenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SenceCell" forIndexPath:indexPath];

    NSString *imgSel = [NSString stringWithFormat:@"%@02",obj.IconType];
    [cell.btnIcon setBackgroundImage:QLImage(obj.IconType) forState:UIControlStateNormal];
    [cell.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateHighlighted];
    [cell.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateSelected];
    cell.lName.text = obj.SenceName;
    
    [cell setLongPressed:^{
        //弹出操作框
        [UIAlertView alertViewWithTitle:@"请选择操作"
                                message:nil
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@[@"重命名",@"图标重置",@"删除",@"编辑"]
                              onDismiss:^(int btnIdx){
                                  switch (btnIdx) {
                                      case 0://重命名
                                      {
                                          self.renameView = [RenameView viewFromDefaultXib];
                                          self.renameView.frame = CGRectMake(0, 0, 1024, 768);
                                          self.renameView.backgroundColor = [UIColor clearColor];
                                          self.renameView.tfContent.text = obj.SenceName;
                                          define_weakself;
                                          [self.renameView setCanclePressed:^{
                                              [weakSelf.renameView removeFromSuperview];
                                          }];
                                          [self.renameView setConfirmPressed:^(UILabel *lTitle,NSString *newName){
                                              NSString *sUrl = [NetworkUtil getChangeSenceName:newName andSenceId:obj.SenceId];
                                              
                                              NSURL *url = [NSURL URLWithString:sUrl];
                                              NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                                              NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                              NSString *sResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
                                              if ([[sResult lowercaseString] isEqualToString:@"ok"]) {
                                                  [SQLiteUtil renameSenceName:obj.SenceId andNewName:newName];
                                                  
                                                  [UIAlertView alertViewWithTitle:@"温馨提示"
                                                                          message:@"更新成功"
                                                                cancelButtonTitle:@"确定"];
                                                  
                                                  [weakSelf.renameView removeFromSuperview];
                                                  
                                                  [weakSelf initData];
                                              }else{
                                                  [UIAlertView alertViewWithTitle:@"温馨提示"
                                                                          message:@"更新失败,请稍后再试."
                                                                cancelButtonTitle:@"关闭"];
                                              }
                                          }];
                                          [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.renameView];
                                          
                                          break;
                                      }
                                      case 1://图标重置
                                      {
                                          IconViewController *iconVC = [IconViewController loadFromSB];
                                          iconVC.pIconType = IconTypeSence;
                                          iconVC.pSenceObj = obj;
                                          iconVC.delegate = self;
                                          NSDictionary * notiInfo = @{@"VC": iconVC};
                                          [[NSNotificationCenter defaultCenter] postNotificationName:NDNotiMainUiJump
                                                                                              object:nil
                                                                                            userInfo:notiInfo];
                                          break;
                                      }
                                      case 2://删除
                                      {
                                          NSString *sUrl = [NetworkUtil getDelSence:obj.SenceId];
                                          
                                          NSURL *url = [NSURL URLWithString:sUrl];
                                          NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                                          NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                          NSString *sResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
                                          if ([[sResult lowercaseString] isEqualToString:@"ok"]) {
                                              [SQLiteUtil removeSence:obj.SenceId];
                                              [self initData];
                                              
                                              [UIAlertView alertViewWithTitle:@"温馨提示"
                                                                      message:@"删除成功"
                                                            cancelButtonTitle:@"确定"];
                                              
                                          }else{
                                              [UIAlertView alertViewWithTitle:@"温馨提示"
                                                                      message:@"删除失败.请稍后再试."
                                                            cancelButtonTitle:@"关闭"];
                                          }
                                          
                                          break;
                                      }
                                      case 3://编辑
                                      {
                                          [DataUtil setUpdateInsertSenceInfo:obj.SenceId andSenceName:obj.SenceName];
                                          
                                          SenceConfigViewController *configVC = [SenceConfigViewController loadFromSB];
                                          NSDictionary * notiInfo = @{@"VC": configVC};
                                          [[NSNotificationCenter defaultCenter] postNotificationName:NDNotiMainUiJump
                                                                                              object:nil
                                                                                            userInfo:notiInfo];
                                          
                                          break;
                                      }
                                      default:
                                          break;
                                  }
                              }onCancel:nil];
    }];
    
    if ([obj.Type isEqualToString:add_oper]) {//添加场景
        [cell setSinglePressed:^{
            [DataUtil setUpdateInsertSenceInfo:@"" andSenceName:@""];
            [DataUtil setGlobalIsAddSence:YES];
            [UIAlertView alertViewWithTitle:@"温馨提示" message:@"您已进入选择模式,所有按键失效,请选择您要构成场景的动作." ];
            [[NSNotificationCenter defaultCenter] postNotificationName:NDNotiMainUiPop
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    } else {//执行命令
        [cell setSinglePressed:^{
            Order *orderObj = [[Order alloc] init];
            orderObj.OrderCmd = obj.Macrocmd;
            orderObj.senceId = obj.SenceId;
            if (self.delegate) {
                [self.delegate sendSenceOrder:orderObj];
            }
        }];
    }
    
    return cell;
}

#pragma mark -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Snaps into the cell
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageIdx = page+1;
}

#pragma mark - IconViewControllerDelegate

-(void)refreshTable
{
    [self initData];
}

#pragma mark -

- (IBAction)btnLeftPressed:(id)sender
{
    if (pageIdx <= 1) {
        return;
    }
    
    pageIdx--;
    
    [self.cvSence scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageIdx*1 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:YES];
}
- (IBAction)btnRightPressed:(id)sender
{
    if (pageIdx >= sumPage) {
        return;
    }
    
    pageIdx++;
    
    [self.cvSence scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageIdx*1 inSection:0]
                         atScrollPosition:UICollectionViewScrollPositionLeft
                                 animated:YES];
}

@end

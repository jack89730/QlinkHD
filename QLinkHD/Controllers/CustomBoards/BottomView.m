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

@implementation BottomView
{
    NSArray *dataArr;
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
//    UIButton *ivIcon = (UIButton *)[cell viewWithTag:101];
    
    NSString *imgSel = [NSString stringWithFormat:@"%@02",obj.IconType];
    [cell.btnIcon setBackgroundImage:QLImage(obj.IconType) forState:UIControlStateNormal];
    [cell.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateHighlighted];
    [cell.btnIcon setBackgroundImage:QLImage(imgSel) forState:UIControlStateSelected];
    [cell.btnIcon addTarget:self action:@selector(btnIconPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPressed:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [cell.btnIcon addGestureRecognizer:longPress];
    
//    UILabel *lTitle = (UILabel *)[cell viewWithTag:102];
//    lTitle.text = obj.SenceName;
    cell.lName.text = obj.SenceName;
    
    return cell;
}

-(void)btnIconPressed:(UIButton *)sender
{
    
}

-(void)btnLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    
}

- (IBAction)btnLeftPressed:(id)sender
{
    int page = self.cvSence.contentOffset.x / self.cvSence.frame.size.width;
    NSLog(@"%f",self.cvSence.frame.size.width);
    if (page <= 1) {
        return;
    }
    
    page--;
    
    CGRect rect = CGRectMake(0, 0,
                             self.cvSence.frame.size.width*page, self.cvSence.frame.size.height);
    [self.cvSence scrollRectToVisible:rect animated:YES];
}
- (IBAction)btnRightPressed:(id)sender
{
    int page = self.cvSence.contentOffset.x / self.cvSence.frame.size.width;
}

- (IBAction)btnSettingPressed:(id)sender
{
    NSLog(@"oooo");
}

@end

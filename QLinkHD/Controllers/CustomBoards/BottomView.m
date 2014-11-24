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
    NSMutableArray *dataArr;
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
//    dataArr = [SQLiteUtil getSenceList:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId];
    dataArr = [NSMutableArray arrayWithArray:[SQLiteUtil getSenceList:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId]];
    
    [dataArr addObjectsFromArray:dataArr];
    [dataArr addObjectsFromArray:dataArr];
    [self.cvSence reloadData];
    
    NSLog(@"-----%f,%f",self.cvSence.collectionViewLayout.collectionViewContentSize.width,self.cvSence.frame.size.width);
    
    pageIdx = 1;
    sumPage = self.cvSence.collectionViewLayout.collectionViewContentSize.width/self.cvSence.frame.size.width;
    NSLog(@"--sumPage--%d",sumPage);
    NSLog(@"%f",self.cvSence.contentSize.width);
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
    [cell.btnIcon addTarget:self action:@selector(btnIconPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPressed:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [cell.btnIcon addGestureRecognizer:longPress];
    
    cell.lName.text = obj.SenceName;
    
    return cell;
}

#pragma mark -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Snaps into the cell
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    NSLog(@"~~~%d",page);
    pageIdx = page+1;
}

-(void)btnIconPressed:(UIButton *)sender
{
    
}

-(void)btnLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    
}

- (IBAction)btnLeftPressed:(id)sender
{
    if (pageIdx <= 1) {
        return;
    }
    
    pageIdx--;
    
    [self.cvSence scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageIdx*5 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:YES];
}
- (IBAction)btnRightPressed:(id)sender
{
    if (pageIdx >= sumPage) {
        return;
    }
    
    pageIdx++;
    
    [self.cvSence scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageIdx*5 inSection:0]
                         atScrollPosition:UICollectionViewScrollPositionLeft
                                 animated:YES];
}

- (IBAction)btnSettingPressed:(id)sender
{
    NSLog(@"oooo");
}

@end

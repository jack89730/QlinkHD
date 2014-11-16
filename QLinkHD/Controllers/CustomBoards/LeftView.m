//
//  LeftView.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-10.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "LeftView.h"
#import "RoomButton.h"

@interface LeftView()

@end

@implementation LeftView
{
    NSArray *dataArr;//数据源
    RoomButton *btnSel;//上一次选中按钮
}

-(void)awakeFromNib
{
    self.tbRoom.delegate = self;
    self.tbRoom.dataSource = self;
    
//    [self loadLayerData];
    //第一次进入默认加载第一个房间
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    [self loadRoomDataByHouseId:obj.HouseId andLayerId:obj.LayerId];
}

#pragma mark -

-(void)loadLayerData
{
    dataArr = [SQLiteUtil getLayerList];
    [self.tbRoom reloadData];
}

-(void)loadRoomDataByHouseId:(NSString *)houseId andLayerId:(NSString *)layerId
{
    dataArr = [SQLiteUtil getRoomList:houseId andLayerId:layerId];
    [self.tbRoom reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    //自定义UITableGridViewCell，里面加了个NSArray用于放置里面的3个图片按钮
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSObject *obj = dataArr[indexPath.row];
    
    RoomButton *btn = [RoomButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnRoomPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = indexPath.row + 100;
    btn.frame = CGRectMake(0, 0, 109, 57);
    
    if ([obj isKindOfClass:[Room class]]) {
        Room *roomObj = (Room *)obj;
        [btn setTitle:roomObj.RoomName forState:UIControlStateNormal];
    } else if ([obj isKindOfClass:[Layer class]]){//楼层
        Layer *layerObj = (Layer *)obj;
        [btn setTitle:[NSString stringWithFormat:@"第%@层",layerObj.LayerId] forState:UIControlStateNormal];
    }
    if (indexPath.row == 0) {
        btnSel = btn;
        btn.selected = YES;
    }
    
    [cell.contentView addSubview:btn];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不让tableviewcell有选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark action

-(void)btnRoomPressed:(RoomButton *)sender
{
    btnSel.selected = NO;
    sender.selected = YES;
    btnSel = sender;
    
    NSObject *obj = dataArr[sender.tag-100];
    if ([obj isKindOfClass:[Room class]]) {//重新加载右侧设备和底部场景
        Room *roomObj = (Room *)obj;
        if ([roomObj.RoomId isEqualToString:@""]) {//返回楼层
            [self loadLayerData];
        }
    } else if ([obj isKindOfClass:[Layer class]]){//楼层
        Layer *layerObj = (Layer *)obj;
        [self loadRoomDataByHouseId:layerObj.HouseId andLayerId:layerObj.LayerId];
    }
}

- (IBAction)btnRightPressed:(id)sender
{
    if (self.actionRightPressed) {
        self.actionRightPressed();
    }
}



@end

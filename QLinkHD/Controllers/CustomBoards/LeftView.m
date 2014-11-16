//
//  LeftView.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-10.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "LeftView.h"
#import "RoomButton.h"

@implementation LeftView

-(void)awakeFromNib
{
    
}

#pragma mark -

-(void)loadData
{
    
}

#pragma mark -
#pragma mark IBAction

- (IBAction)btnRightPressed:(id)sender
{
    if (self.actionRightPressed) {
        self.actionRightPressed();
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    RoomButton *btn = [RoomButton buttonWithType:UIButtonTypeCustom];
    [cell.contentView addSubview:btn];
    
    return nil;
}

@end

//
//  CricleButton.m
//  QLinkHD
//
//  Created by 尤日华 on 14-12-6.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "CricleButton.h"
#import "UIAlertView+MKBlockAdditions.h"

@implementation CricleButton

-(void)awakeFromNib
{
    [self setLongPressEvent];
//    self.ivIcon = [[UIImageView alloc] init];
//    self.ivIcon.image = [UIImage imageNamed:@"other_small"];
//    [self addSubview:self.ivIcon];
}

//设置长按事件
-(void)setLongPressEvent
{
    //实例化长按手势监听
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    longPress.minimumPressDuration = 1.0;//表示最短长按的时间
    //将长按手势添加到需要实现长按操作的视图里
    [self addGestureRecognizer:longPress];
}

-(void)addSmallIcon:(Device *)obj andIndex:(int)idx
{
    self.deviceId = obj.DeviceId;
    self.iconType = obj.IconType;
    
    self.ivIcon = [[UIImageView alloc] init];
    self.ivIcon.tag = 999;
    switch (idx) {
        case 0:
            self.ivIcon.frame = CGRectMake(17, 38, 21, 21);
            break;
        case 1:
            self.ivIcon.frame = CGRectMake(36, 17, 21, 21);
            break;
        case 2:
            self.ivIcon.frame = CGRectMake(28, 19, 21, 21);
            break;
        case 3:
            self.ivIcon.frame = CGRectMake(22, 38, 21, 21);
            break;
        case 4:
            self.ivIcon.frame = CGRectMake(23, 30, 21, 21);
            break;
        case 5:
            self.ivIcon.frame = CGRectMake(27, 23, 21, 21);
            break;
        case 6:
            self.ivIcon.frame = CGRectMake(34, 24, 21, 21);
            break;
        case 7:
            self.ivIcon.frame = CGRectMake(18, 28, 21, 21);
            break;
        default:
            break;
    }
    NSString *icon = [NSString stringWithFormat:@"%@_small01",obj.IconType];
    self.ivIcon.image = QLImage(icon);
    [self addSubview:self.ivIcon];
}

-(void)setImageSel
{
    NSString *icon = [NSString stringWithFormat:@"%@_small02",self.iconType];
    self.ivIcon.image = QLImage(icon);
}

-(void)setImageUnSel
{
    NSString *icon = [NSString stringWithFormat:@"%@_small01",self.iconType];
    self.ivIcon.image = QLImage(icon);
}

#pragma mark -
#pragma mark Custom Methods

//长按事件的实现方法
- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if ([DataUtil checkNullOrEmpty:self.deviceId]) {
            [UIAlertView alertViewWithTitle:@"温馨提示" message:@"长按无效"];
            return;
        }
        define_weakself;
        [UIAlertView alertViewWithTitle:@"温馨提示"
                                message:@"确定要删除该快捷设备吗?"
                      cancelButtonTitle:@"关闭"
                      otherButtonTitles:@[@"删除"]
                              onDismiss:^(int buttonIndex){
                                  if (weakSelf.longPressBlock) {
                                      weakSelf.longPressBlock();
                                  }
                              }onCancel:nil];
    }
}

@end

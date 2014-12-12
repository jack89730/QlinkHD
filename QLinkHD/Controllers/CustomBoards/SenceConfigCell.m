//
//  SenceConfigCell.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-27.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "SenceConfigCell.h"
#import "UIAlertView+MKBlockAdditions.h"

@implementation SenceConfigCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIcon:(NSString *)icon
 andDeviceName:(NSString *)deviceName
  andOrderName:(NSString *)orderName
       andTime:(NSString *)timer
{
    self.ivIcon.image = QLImage(icon);
    self.lDeviceName.text = deviceName;
    self.lOrderName.text = orderName;
    [self.btnNumber setTitle:timer forState:UIControlStateNormal];
    
    //实例化长按手势监听
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    longPress.minimumPressDuration = 1.0;//表示最短长按的时间
    //将长按手势添加到需要实现长按操作的视图里
    [self addGestureRecognizer:longPress];
}

#pragma mark -
#pragma mark Custom Methods

//长按事件的实现方法
- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [UIAlertView alertViewWithTitle:@"温馨提示"
                                message:@"确定要删除该命令吗?"
                      cancelButtonTitle:@"关闭"
                      otherButtonTitles:@[@"删除"]
                              onDismiss:^(int buttonIndex){
                                  if (self.deleteCellPressed) {
                                      self.deleteCellPressed();
                                  }
        }onCancel:nil];
    }
}


- (IBAction)btnJian
{
    int iNum = [self.btnNumber.titleLabel.text intValue];
    if (iNum == 1) {
        return;
    }
    
    iNum --;
    NSString *sNum = [NSString stringWithFormat:@"%d",iNum];
    [self.btnNumber setTitle:sNum forState:UIControlStateNormal];
    
    if (self.numberPressed) {
        self.numberPressed(sNum);
    }
}

- (IBAction)btnJia
{
    int iNum = [self.btnNumber.titleLabel.text intValue];
    if (iNum >= 50) {
        return;
    }
    
    iNum ++;
    NSString *sNum = [NSString stringWithFormat:@"%d",iNum];
    [self.btnNumber setTitle:sNum forState:UIControlStateNormal];
    
    if (self.numberPressed) {
        self.numberPressed(sNum);
    }
}
- (IBAction)btnNumberPressed:(UIButton *)sender
{
    [UIAlertView alertViewWithTitle:@"选择时间间隔"
                            message:nil
                  cancelButtonTitle:@"关闭"
                  otherButtonTitles:@[@"10",@"20",@"30",@"40",@"50"]
                          onDismiss:^(int buttonIndex){
                              NSString *value = [NSString stringWithFormat:@"%d",(buttonIndex+1)*10];
                              
                              [self.btnNumber setTitle:value forState:UIControlStateNormal];
                              
                              if (self.numberPressed) {
                                  self.numberPressed(value);
                              }
    }onCancel:nil];
}

@end

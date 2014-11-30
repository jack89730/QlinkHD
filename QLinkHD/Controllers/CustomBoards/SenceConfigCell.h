//
//  SenceConfigCell.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-27.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenceConfigCell : UITableViewCell

@property (weak, nonatomic) void(^deleteCellPressed)();

@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lOrderName;
@property (weak, nonatomic) IBOutlet UIButton *btnNumber;

- (IBAction)btnJian;
- (IBAction)btnJia;
- (IBAction)btnNumberPressed:(UIButton *)sender;

-(void)setIcon:(NSString *)icon
 andDeviceName:(NSString *)deviceName
  andOrderName:(NSString *)orderName
       andTime:(NSString *)timer;

@end

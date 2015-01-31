//
//  DeviceInfoCell.m
//  QLinkHD
//
//  Created by 尤日华 on 15-1-31.
//  Copyright (c) 2015年 SANSAN. All rights reserved.
//

#import "DeviceInfoCell.h"
#import "NSString+NSStringHexToBytes.h"

@interface DeviceInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *lblOrderName;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderValue;

@end

@implementation DeviceInfoCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    如果要立即刷新，要先调用[view setNeedsLayout]，把标记设为需要布局，然后马上调用[view layoutIfNeeded]，实现布局
//    [self.contentView setNeedsLayout];//标记需要重新布局
//    [self.contentView layoutIfNeeded];
    
    self.lblOrderValue.preferredMaxLayoutWidth = CGRectGetWidth(self.lblOrderValue.bounds); //self.lblOrderValue.bounds.size.width;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)bindCell:(Order *)obj
{
    self.backgroundColor = [UIColor clearColor];
    
    self.lblOrderName.text = obj.OrderName;
    
    NSString *orderValue = @"";
    
    if ([[DataUtil getGlobalModel] isEqualToString:Model_ZKDOMAIN] ||[[DataUtil getGlobalModel] isEqualToString:Model_ZKIp] || [DataUtil checkNullOrEmpty:obj.OrderCmd]) {//中控模式 不变
        NSString *orderValue1 = [DataUtil checkNullOrEmpty:obj.OrderCmd] ? @"暂无" : obj.OrderCmd;
        self.lblOrderValue.text = orderValue1;
        orderValue = orderValue1;
    } else { //紧急模式(修改Order取值显示出来的时候省略4个字节；之后如果返回命令冒号后为“1”表示为ASCII码，将省略4字节后的报文，转化为ASCII码，2个为一组；“0”表示原声为16进制，无需更改)
        NSString *handleOrderCmd = [obj.OrderCmd substringFromIndex:4];
        if ([obj.Hora isEqualToString:@"1"]) { //转ASCII
            NSData *data = [handleOrderCmd hexToBytes];
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            self.lblOrderValue.text = [NSString stringWithFormat:@"%@(A)",result];
            orderValue = [NSString stringWithFormat:@"%@(A)",result];
        } else { //0
            self.lblOrderValue.text = [NSString stringWithFormat:@"%@(H)",handleOrderCmd];
            orderValue = [NSString stringWithFormat:@"%@(H)",handleOrderCmd];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

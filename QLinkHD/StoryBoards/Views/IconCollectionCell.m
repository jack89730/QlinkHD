//
//  IconCollectionCell.m
//  QLinkHD
//
//  Created by 尤日华 on 14-11-13.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "IconCollectionCell.h"

@implementation IconCollectionCell

-(void)fillViewValue:(Device *)deviceObj
{
    self.curObj = deviceObj;
    
    self.lName.text = deviceObj.DeviceName;
    [self.btnIcon setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

@end

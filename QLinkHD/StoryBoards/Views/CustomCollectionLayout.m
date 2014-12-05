//
//  CustomCollectionLayout.m
//  QLinkHD
//
//  Created by 尤日华 on 14-12-5.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "CustomCollectionLayout.h"

@implementation CustomCollectionLayout

- (CGSize)collectionViewContentSize
{
    CGSize size = [super collectionViewContentSize];
    
    size.height += 100;
    
    return size;
}

@end

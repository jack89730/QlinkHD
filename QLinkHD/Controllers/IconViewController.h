//
//  IconViewController.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-16.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryBoardLoader.h"
#import "DataUtil.h"
#import "Model.h"

@protocol IconViewControllerDelegate <NSObject>

-(void)refreshTable;

@end

@interface IconViewController : UIViewController<SBLoader>

@property(nonatomic,assign) id<IconViewControllerDelegate>delegate;
@property(nonatomic,assign) IconType pIconType;
@property(nonatomic,retain) Device *pObj;

@end

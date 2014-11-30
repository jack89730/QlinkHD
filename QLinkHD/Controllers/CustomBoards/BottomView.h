//
//  BottomView.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-5.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

-(void)sendSenceOrder:(Order *)order;

@end

@interface BottomView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cvSence;
@property (nonatomic,assign) id<BottomViewDelegate>delegate;

@end

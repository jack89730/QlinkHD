//
//  BottomBoard.h
//  QLinkHD
//
//  Created by 尤日华 on 14-11-5.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BottomBoard : NSObject

@property(nonatomic,copy) void(^sendSenceOrderPressed)(Order *obj);
@property(nonatomic,copy) void(^writeZkPressed)();
@property(nonatomic, copy) void(^bottomSoundChangePressed)(Order *order);

//使用单例类，方便在全局控制
+ (BottomBoard *)defaultBottomBoard;

@end

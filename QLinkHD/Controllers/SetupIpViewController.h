//
//  SetupIpViewController.h
//  QLink
//
//  Created by 尤日华 on 14-10-19.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "SimplePingHelper.h"
#import "ActionNullClass.h"

@interface SetupIpViewController : UIViewController<SimplePingDelegate,ActionNullClassDelegate>
{
    GCDAsyncUdpSocket *udpSocket_;
    GCDAsyncSocket *asyncSocket_;
}

@property(nonatomic,assign) int iRetryCount;
@property(nonatomic,weak) Member *pLoginMember;
@property(nonatomic,strong) Config *pConfigTemp;

-(void)load_setIpSocket:(NSDictionary *)dic;
-(void)loadActionNULL;

@end


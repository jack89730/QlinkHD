//
//  SetupIpViewController.m
//  QLink
//
//  Created by 尤日华 on 14-10-19.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "SetupIpViewController.h"
#import "NSString+NSStringHexToBytes.h"
#import "MainViewController.h"
#import "NetworkUtil.h"

@interface SetupIpViewController ()
{
    NSMutableArray *infoTagReadArr_;
    NSMutableArray *infoTagArr_;
    NSMutableArray *orderDicArr_;
    
    NSString *sendContent_;
    NSDictionary *sendDic_;
    
    NSString *ip_;
    NSString *port_;
}
@end

@implementation SetupIpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loadActionNULL
{
    NSString *curVersion = [SQLiteUtil getCurVersionNo];
    
    Member *curMember = [Member getMember];
    Member *tempMember = [Member getTempLoginMember];
    
    //重新解析配置文件
    if ((curMember && ![curMember.uKey isEqualToString:tempMember.uKey])) {//更换用户
        //清除本地配置数据
        [SQLiteUtil clearData];
    }
    
    //设置登录信息
    [Member setUdMember:tempMember.uName
                andUPwd:tempMember.uPwd
                andUKey:tempMember.uKey
           andIsRemeber:tempMember.isRemeber];
    
    if ((curMember && ![curMember.uKey isEqualToString:tempMember.uKey]) || ![_pConfigTemp.configVersion isEqualToString:curVersion])//更换用户或者版本号不同则重新请求配置文件
    {
        ActionNullClass *actionNullClass = [[ActionNullClass alloc] init];
        actionNullClass.delegate = self;
        [actionNullClass requestActionNULL];
        
    }else{//读取本地数据配置
        NSLog(@"读取本地");
        
        //解析存储成功，覆盖本地配置数据
        if (_pConfigTemp) {
            [Config setConfigObj:_pConfigTemp];
        }
        [SVProgressHUD dismiss];
        
        [SQLiteUtil setDefaultLayerIdAndRoomId];
        
        MainViewController *mainVC = [MainViewController loadFromSB];
        [self.navigationController pushViewController:mainVC animated:YES];
    }
}

-(void)load_setIpSocket:(NSDictionary *)dic
{
    self.iRetryCount = 1;
    
    NSDictionary *info = [dic objectForKey:@"info"];
    
    infoTagReadArr_ = [NSMutableArray arrayWithObjects:@"_onecmd",@"_twocmd",@"_threecmd",@"_send_this_cmd",@"_send_this_cmd1",@"_send_this_cmd2", nil];
    
    orderDicArr_ = [NSMutableArray arrayWithArray:[DataUtil changeDicToArray:[info objectForKey:@"kfsdevice"]]];
    [orderDicArr_ insertObject:info atIndex:0];
    
    [self sendLoopOrder];
}

-(void)sendLoopOrder
{
    infoTagArr_ = [NSMutableArray arrayWithArray:infoTagReadArr_];
    sendDic_ = [orderDicArr_ objectAtIndex:0];
    
    for (NSString *tag in infoTagReadArr_) {
        if ([DataUtil checkNullOrEmpty:[sendDic_ objectForKey:tag]]) {
            [infoTagArr_ removeObject:tag];
        }
    }
    
    [self sendLoopTag];
}

-(void)sendLoopTag
{
    sendContent_ = [sendDic_ objectForKey:[infoTagArr_ objectAtIndex:0]];
    
    NSString *toHera = [DataUtil checkNullOrEmpty:[sendDic_ objectForKey:@"_to_here"]] ? [sendDic_ objectForKey:@"_toip"] : [sendDic_ objectForKey:@"_to_here"];
    NSArray *to_hereArr = [toHera componentsSeparatedByString:@":"];
    NSArray *local_portArr = [[sendDic_ objectForKey:@"_local_port"] componentsSeparatedByString:@":"];

    [self initUdp:[to_hereArr objectAtIndex:1]
          andPort:[to_hereArr objectAtIndex:2]
      andBindPort:[local_portArr objectAtIndex:1]
     andBroadcast:YES];
}

#pragma mark -
#pragma mark 发送方法（UDP／TCP）

-(void)initUdp:(NSString *)host
       andPort:(NSString *)port
   andBindPort:(NSString *)bindPort
  andBroadcast:(BOOL)enable
{
    /**************创建连接**************/
    
    NSError *error = nil;
    
    if (udpSocket_ != nil) {
        [udpSocket_ close];
        udpSocket_ = nil;
    }
    
    udpSocket_ = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    if (bindPort != nil && ![udpSocket_ bindToPort:[bindPort integerValue] error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    
	if (![udpSocket_ beginReceiving:&error])
	{
		NSLog(@"Error receiving: %@", error);
		return;
	}
    if (enable && ![udpSocket_ enableBroadcast:YES error:&error])
    {
        NSLog(@"Error enableBroadcast: %@", error);
		return;
    }
    
    /**************发送数据**************/
    
    NSData *data = [sendContent_ hexToBytes];
    [udpSocket_ sendData: data
                  toHost: host
                    port: [port integerValue]
             withTimeout:-1
                     tag: -1];
}

-(void)initTcp:(NSString *)host
       andPort:(NSString *)port
{
    /**************创建连接**************/
    
    asyncSocket_ = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if (![asyncSocket_ connectToHost:host onPort:[port integerValue] error:&error])
    {
        NSLog(@"Error connecting");
        return;
    }
}

#pragma mark -
#pragma mark UDP 响应方法

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    [NSThread sleepForTimeInterval:1];
    
    // 移除命令
    [infoTagArr_ removeObjectAtIndex:0];
    
    // 发完完毕, ping一下
    if ([infoTagArr_ count] == 0) {
        NSArray *testIpArr = [[sendDic_ objectForKey:@"_testip"] componentsSeparatedByString:@":"];
        NSString *pingIp = nil;
        if ([testIpArr count] > 1) {
            pingIp = [testIpArr objectAtIndex:1];
        } else {
            pingIp =[sendDic_ objectForKey:@"_testip"];
        }
        
        [NSThread sleepForTimeInterval:2];
        
        [SimplePingHelper ping:pingIp
                        target:self
                           sel:@selector(pingResult:)];
    } else {
        [self sendLoopTag];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    [self pingFailure];
}

//接收UDP数据
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    
}

#pragma mark -
#pragma mark TCP 响应方法

//当成功连接上，delegate 的 socket:didConnectToHost:port: 方法会被调用
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝\n");
    NSLog(@"连接成功\n");
	NSLog(@"已连接到 －－ socket:%p didConnectToHost:%@ port:%hu \n", sock, host, port);
}

//未成功连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        NSLog(@"连接失败\n");
        NSLog(@"错误信息 －－ socketDidDisconnect:%p withError: %@", sock, err);
    }else{
        NSLog(@"断开连接\n");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

//接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
}

#pragma mark -
#pragma mark ActionNullClassDelegate

-(void)failOper
{
    NSString *curVersion = [SQLiteUtil getCurVersionNo];
    if (![DataUtil checkNullOrEmpty:curVersion]) {
        //读取本地配置
        [SQLiteUtil setDefaultLayerIdAndRoomId];
        
        MainViewController *mainVC = [MainViewController loadFromSB];
        [self.navigationController pushViewController:mainVC animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"第一次配置必须连接Intenet"];
        return;
    }
}

-(void)successOper
{
    //解析存储成功，覆盖本地配置数据
    [Config setConfigObj:_pConfigTemp];
    
    [SVProgressHUD showSuccessWithStatus:@"配置完成."];
    
    [SQLiteUtil setDefaultLayerIdAndRoomId];
    
    MainViewController *mainVC = [MainViewController loadFromSB];
    [self.navigationController pushViewController:mainVC animated:YES];
}


#pragma mark -
#pragma mark SimplePingDelegate

- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
//        [SVProgressHUD dismiss];
        [self pingSuccess];
    } else {
        [self pingFailure];
    }
}

-(void)pingSuccess
{
    self.iRetryCount = 1;
    [orderDicArr_ removeObjectAtIndex:0];
    if ([orderDicArr_ count] == 0) {
        NSString *sUrl = [NetworkUtil getAction:ACTIONSETUPIPOK andMember:[Member getTempLoginMember]];
        NSURL *url = [NSURL URLWithString:sUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString *strResult = operation.responseString;
             if ([strResult containsString:@"error"]) {
                 NSArray *errorArr = [strResult componentsSeparatedByString:@":"];
                 if (errorArr.count > 1) {
                     [SVProgressHUD showErrorWithStatus:errorArr[1]];
                     return;
                 }
             }
             
             [self loadActionNULL];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD dismiss];
         }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    } else {
        [self sendLoopOrder];
    }
}

-(void)pingFailure
{
    if (NumberOfTimeout > [self iRetryCount]) {
        [self setIRetryCount:[self iRetryCount] + 1];
        [self sendLoopOrder];
    } else if ([self iRetryCount] >= NumberOfTimeout) {
        [SVProgressHUD showErrorWithStatus:@"配置ip失败"];
        
        [self loadActionNULL];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

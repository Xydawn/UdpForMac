//
//  UdpSocket.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/5.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "UdpSocket.h"

#pragma pack (1)
typedef struct _appChargeRequest{
//    char           sign[2];        //'QD'
//    unsigned char  type;
    char           orderId[32];
//    char           payToken[32];
    
}appChargeRequest;

#pragma pack ()

@interface UdpSocket ()
@property (nonatomic)       AsyncUdpSocket *asy;
@property (nonatomic)       AsyncUdpSocket *send;
// 服务器socket
@property (nonatomic) BOOL sendBool;
@property (nonatomic) GCDAsyncSocket *sendMessage;
@property (nonatomic) NSString *socketID;
@property (nonatomic,copy) NSMutableString *strWithHost;
@end

@implementation UdpSocket

-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeALLUDP) name:@"closeUDP" object:nil];
    }
    return self;
}

+(instancetype)shareUdpScoket{
    static UdpSocket *udp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        udp = [[UdpSocket alloc]init];
        udp.asy =  [[AsyncUdpSocket alloc]initWithDelegate:udp];
        NSError *err = nil;
        BOOL reuslt = [udp.asy bindToPort:9998 error:&err];
        //启动接收线程
        [udp.asy receiveWithTimeout:-1 tag:200];
    });
    return udp;
}

-(NSMutableDictionary *)selecorArr{
    if (!_selecorArr) {
        _selecorArr = [[NSMutableDictionary alloc]init];
    }
    return _selecorArr;
}


-(void)closeALLUDP{
    self.delegate = nil;
    self.sendDelegate = nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)creatUdpSocketWith:(id<UdpSocketDelegate>)delegate{
    
    self.delegate = delegate;
    
}




//接口已修改为Udp
-(void)creatTCPSendWithMsg:(NSString *)msg  andHost:(NSString *)host andPort:(NSInteger )port{
    self.send = [[AsyncUdpSocket alloc]initWithDelegate:self];
    // 我想给ip的机器发送消息msg
    // 给ip的机器端口0x1234发送数据msgData;
    // sendData只是告诉系统发送，但是这个内容还没有发完
    // 我们怎么知道什么时候发送完成
    [self.send enableBroadcast:YES error:nil];
    NSData *objData = [msg dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [self.send sendData:objData toHost:host port:port withTimeout:-1 tag:200];

}

#pragma mark - UDP
//已接收到消息
/*
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{

    CHQLog(@"%hu",port);
    
    if (tag == 200) {
        NSString *sData = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        
        NSMutableString *strWithHost = [[NSMutableString alloc]initWithString:sData];
        
        [strWithHost appendString:[NSString stringWithFormat:@"|%@",host]];
//        CHQLog(@"udp服务已经接受");
        CHQLog(@"%@",strWithHost);
        CHQLog(@"%@",self.selecorArr);
        UDPModel *model = [[UDPModel alloc]init];
        
        [model setModelWithArr:strWithHost];
        
        if (model.DevId.length == 0) {
            return YES;
        }
        
        model.port = port;
        
        if (![self.socketID isEqualToString:model.DevId]) {
            [self.selecorArr removeAllObjects];
            self.socketID = model.DevId;
        }
        
        NSMutableArray *typeArr = [[NSMutableArray alloc]initWithArray:self.selecorArr];
        
        model.selecor = NO;
        
        NSInteger i = 0;
        
        BOOL add = YES;
        
        for (UDPModel *udpStr in self.selecorArr) {
            
            if ([udpStr.DevId isEqualToString:model.DevId]&&[udpStr.PortNo isEqualToString:model.PortNo]) {
                
                model.selecor = udpStr.selecor;
                
                [typeArr replaceObjectAtIndex:i withObject:model];
                
                add = NO;
                
                break;
                
            }
            i++;
        }
        
        [self.selecorArr removeAllObjects];
        
        [self.selecorArr addObjectsFromArray:typeArr];
        
        if (add) {
            [self.selecorArr addObject:model];
        }
        
        if (![objc_getAssociatedObject(self.selecorArr, @"Kcount") isEqualToNumber:@(self.selecorArr.count)] )
        {
            
            
            if (self.delegate) {
                [self.delegate getUdpReslut:self.selecorArr andHost:host];
            }
            objc_setAssociatedObject(self.selecorArr, @"Kcount", @(self.selecorArr.count), OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        

        
    }
    [sock receiveWithTimeout:-1 tag:tag];
    
    return YES;
}
*/
//已接收到消息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    

    
    [sock receiveWithTimeout:-1 tag:tag];
    
    if (tag == 200) {
        
//        NSString *sData = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
//        
//        self.strWithHost = [[NSMutableString alloc]initWithString:sData];
//        
//        NSArray *arr = [self.strWithHost componentsSeparatedByString:@","];
//        
//        NSMutableArray *modelArr = [[NSMutableArray alloc]init];
//        
//        NSString *key;
//        
//        for (NSString *str in arr) {
//            
//            NSMutableString *muStr = [[NSMutableString alloc]initWithString:str];
//            
//            [muStr appendString:[NSString stringWithFormat:@"|%@",host]];
//            //        CHQLog(@"udp服务已经接受");
//            CHQLog(@"%@",muStr);
//            CHQLog(@"%@",self.selecorArr);
//            UDPModel *model = [[UDPModel alloc]init];
//            
//            [model setModelWithArr:muStr];
//            
//            if (model.DevId.length != 1) {
//                continue;
//            }
//
//            if ([model.DevStatus integerValue]!=1) {
//                continue;
//            }
//            
//            if(!key){
//                key = model.DevId;
//            }
//            
//            model.port = port;
//            
//            [modelArr addObject:model];
//            
//        }
//        
//        [self.selecorArr setValue:modelArr forKey:key];
//        
//        if (self.delegate) {
//            [self.delegate getUdpReslut:self.selecorArr andHost:host];
//        }
        
    }
    
    return YES;
}

//没有接受到消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"未收到连接");
}
//没有发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"未发出");
    
//    if (self.sendBool) {
//        return;
//    }
//    self.sendBool = YES;
    if (self.sendDelegate) {
        [self.sendDelegate sendUdpDefaue];
    }
    self.send = nil;
}
//已发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"已发出");
//    if (self.sendBool) {
//        return;
//    }
//    self.sendBool = YES;
    if (self.sendDelegate) {
        [self.sendDelegate sendUdpSuccessed];
    }
    self.send = nil;
}
//断开连接
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"已断开连接");
}

#pragma mark - TCPGCDAsyncSocketDelegate

// 客户端链接服务器端成功, 客户端获取地址和端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%@",[NSString stringWithFormat:@"链接服务器%@", host]);
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    
    NSLog(@"连接失败 %@", err);
//    [self.sendMessage connectToHost:@"192.168.0.17" onPort:9999 error:&err];
    // 断线重连
}

// 客户端已经获取到内容
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",content);

}




@end

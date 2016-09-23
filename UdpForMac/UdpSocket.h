//
//  UdpSocket.h
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/5.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

@protocol UdpSocketDelegate <NSObject>

-(void)getUdpReslut:(NSObject *)data andHost:(NSString *)host;

@end

@protocol sendUdpSocketDelegate <NSObject>

-(void)sendUdpSuccessed;

-(void)sendUdpDefaue;

@end


@interface UdpSocket : NSObject<AsyncUdpSocketDelegate,GCDAsyncSocketDelegate>

@property id<UdpSocketDelegate> delegate;
@property id<sendUdpSocketDelegate>sendDelegate;
@property (nonatomic) NSMutableDictionary *selecorArr;
+(instancetype)shareUdpScoket;

-(void)creatUdpSocketWith:(id<UdpSocketDelegate>)delegate;



-(void)creatTCPSendWithMsg:(NSString *)msg  andHost:(NSString *)host andPort:(NSInteger )port;

@end

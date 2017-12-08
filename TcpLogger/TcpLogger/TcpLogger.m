//
//  TcpLogger.m
//  TcpLogger
//
//  Created by MKolesov on 29/08/2017.
//  Copyright © 2017 Mikhail Kolesov. All rights reserved.
//

#import "TcpLogger.h"

#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <pthread.h>

#define PORT 7771

@interface TcpLogger ()
@property (nonatomic, assign) int sock;
@property (nonatomic, strong) dispatch_queue_t messageQueue;
@property (nonatomic, assign) BOOL connected;
@end

@implementation TcpLogger

+ (TcpLogger *) shared
{
    static TcpLogger *logger = nil;
    if (logger == nil) {
        logger = [TcpLogger new];
        logger.connected = NO;
    }
    return logger;
}

- (void) connectWithAddress:(NSString*)serverAddress {
    
    // create sync queue for messages
    self.messageQueue = dispatch_queue_create("MessageQueue", DISPATCH_QUEUE_SERIAL);
    if (self.messageQueue) {
        dispatch_async(self.messageQueue, ^{
            struct sockaddr_in server;
            //Create socket
            self.sock = socket(AF_INET , SOCK_STREAM , 0);
            if (self.sock == -1)
            {
                perror("Log Server. Could not create socket.");
                return;
            }
            int     kOne = 1;
            setsockopt(self.sock, SOL_SOCKET, SO_NOSIGPIPE, &kOne, sizeof(kOne));
            puts("Log Server. Socket created");
            
            server.sin_addr.s_addr = inet_addr([serverAddress UTF8String]);
            server.sin_family = AF_INET;
            server.sin_port = htons( PORT );
            
            //Connect to remote server
            if (connect(self.sock , (struct sockaddr *)&server , sizeof(server)) < 0)
            {
                perror("Log Server. Connect failed.");
                return;
            }
            
            puts("Log Server. Connected!\n");
            
            self.connected = YES;
        });
    }
}

-(void)sendMessage:(NSString*)message {
    if (self.connected) {
        dispatch_async(self.messageQueue, ^{
            
            const char *UTF8String = [message UTF8String];
            if( send(self.sock ,  UTF8String, strlen(UTF8String), 0) < 0)
            {
                puts("Log Server. Send failed");
                return;
            }
        });
    }
}

- (void) close {
    close(self.sock);
}


@end

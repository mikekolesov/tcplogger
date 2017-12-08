//
//  TcpLogger.h
//  TcpLogger
//
//  Created by MKolesov on 29/08/2017.
//  Copyright © 2017 Mikhail Kolesov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TcpLogger : NSObject

+ (TcpLogger *) shared;

- (void) connectWithAddress:(NSString*)serverAddress;
- (void) sendMessage:(NSString*)message;
- (void) close;

@end

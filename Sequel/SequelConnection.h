//
//  SequelConnection.h
//  Sequel
//
//  Created by Wess Cope on 11/8/13.
//  Copyright (c) 2013 Nudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mysql.h"

@interface SequelConnection : NSObject
@property (copy, nonatomic) NSString                *socket;
@property (copy, nonatomic) NSString                *host;
@property (copy, nonatomic) NSString                *database;
@property (nonatomic) NSInteger                     port;
@property (copy, nonatomic) NSString                *username;
@property (copy, nonatomic) NSString                *password;
@property (readonly, nonatomic) BOOL                isConnected;
@property (readonly, nonatomic) NSUInteger          lastInsertedId;
@property (readonly, nonatomic) NSString            *clientInfo;
@property (readonly, nonatomic) MYSQL               *mysql;
@property (readonly, nonatomic) dispatch_queue_t    queue;

- (void)connect:(NSError **)error;
- (void)disconnect;

@end

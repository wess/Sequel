//
//  SequelQuery.h
//  Sequel
//
//  Created by Wess Cope on 11/8/13.
//  Copyright (c) 2013 Nudge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SequelQueryHandler)(NSArray *results, NSError *error);

@class SequelConnection;
@interface SequelQuery : NSObject
@property (readonly, nonatomic) NSString    *query;
@property (readonly, nonatomic) NSInteger   numberOfRows;


+ (instancetype)queryWithConnection:(SequelConnection *)connection;
+ (void)executeQuery:(NSString *)query withConnection:(SequelConnection *)connection completionHandler:(SequelQueryHandler)completionHandler;

- (instancetype)initWithConnection:(SequelConnection *)connection;
- (void)executeQuery:(NSString *)query completionHandler:(SequelQueryHandler)completionHandler;

- (NSArray *)executeQuery:(NSString *)query;

@end

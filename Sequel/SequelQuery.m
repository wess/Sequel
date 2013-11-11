//
//  SequelQuery.m
//  Sequel
//
//  Created by Wess Cope on 11/8/13.
//  Copyright (c) 2013 Nudge. All rights reserved.
//

#import "SequelQuery.h"
#import "SequelConnection.h"
#import "mysql.h"

@interface SequelQuery()
@property (strong, nonatomic) SequelConnection  *connection;
@property (strong, nonatomic) NSMutableArray    *rows;
@property (nonatomic) NSString                  *queryError;
@property (nonatomic) MYSQL                     *database;
@property (copy, nonatomic) SequelQueryHandler  handler;

@end

@implementation SequelQuery
@synthesize query           = _query;
@synthesize numberOfRows    = _numberOfRows;

+ (instancetype)queryWithConnection:(SequelConnection *)connection
{
    return [[self alloc] initWithConnection:connection];
}

+ (void)executeQuery:(NSString *)query withConnection:(SequelConnection *)connection completionHandler:(SequelQueryHandler)completionHandler
{
    
}

- (instancetype)initWithConnection:(SequelConnection *)connection
{
    self = [super init];
    if(self)
    {
        self.connection = connection;
        self.database   = self.connection.mysql;
        self.rows       = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)queryError
{
    return [NSString stringWithUTF8String:mysql_error(self.database)];
}

- (NSArray *)executeQuery:(NSString *)query
{
    if(mysql_query(self.database, [query UTF8String]))
    {
        printf("mysql error: %s", mysql_error(self.database));
        return nil;
    }

    MYSQL_RES   *result     = mysql_use_result(self.database);
    NSInteger   numFields   = mysql_num_fields(result);
    NSInteger   index       = 0;
    
    MYSQL_FIELD *field;
    MYSQL_ROW   row;
    
    NSMutableArray *results         = [[NSMutableArray alloc] init];
    NSMutableDictionary *columns    = [[NSMutableDictionary alloc] init];
    
    while((field = mysql_fetch_field(result)))
    {
        NSString *fieldName = [[NSString alloc] initWithUTF8String:field->name];
        columns[@(index)]   = fieldName;
        
        index++;
    }
    
    while((row = mysql_fetch_row(result)))
    {
        NSMutableDictionary *rowDictionary = [[NSMutableDictionary alloc] init];
        for(index = 0; index < numFields; index++)
        {
            if(row[index])
            {
                NSString *val = [[NSString alloc] initWithUTF8String:row[index]];
                NSString *name = columns[@(index)];
                
                rowDictionary[name] = val;
            }
        }
        
        [results addObject:rowDictionary];
    }
    
    mysql_free_result(result);
    
    return [results copy];
}

- (void)executeQuery:(NSString *)query completionHandler:(SequelQueryHandler)completionHandler
{
    self.handler = completionHandler;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.connection.queue, ^{
        NSArray *results = [self executeQuery:query];
        
        __block SequelQueryHandler handler = [weakSelf.handler copy];
        if(weakSelf.handler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                    handler(results, nil);
            });
        }
    });
}

@end

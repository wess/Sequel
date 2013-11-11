//
//  SequelConnection.m
//  Sequel
//
//  Created by Wess Cope on 11/8/13.
//  Copyright (c) 2013 Nudge. All rights reserved.
//

#import "SequelConnection.h"

@interface SequelConnection()
@property (nonatomic)  MYSQL *db;
@property (readonly, nonatomic) NSString *mysqlError;
@end

@implementation SequelConnection
@synthesize queue = _queue;

- (id)init
{
    self = [super init];
    if (self)
    {
        NSAssert(!mysql_library_init(0, NULL, NULL), @"Unable to initalize MySQL");
    }
    return self;
}

- (void)finalize
{
    mysql_library_end();
}

- (dispatch_queue_t)queue
{
    if(_queue)
        return _queue;
    
    _queue = dispatch_queue_create("sequal.connection.queue", NULL);
    
    return _queue;
}

- (MYSQL *)mysql
{
    return self.db;
}

- (NSUInteger)lastInsertedId
{
    return mysql_insert_id(self.db);
}

- (NSString *)clientInfo
{
    NSString *info = [[NSString alloc] initWithCString:mysql_get_client_info() encoding:NSUTF8StringEncoding];
    
    return info;
}

- (BOOL)isConnected
{
    return mysql_stat(self.db)? YES : NO;
}

- (NSString *)mysqlError
{
    return [NSString stringWithUTF8String:mysql_error(self.db)];
}

- (void)connect:(NSError **)error
{
    NSParameterAssert(self.database);
    
    self.db = mysql_init(NULL);

    const char *host        = self.host? [self.host UTF8String] : "localhost";
    const char *username    = self.username? [self.username UTF8String] : "root";
    const char *password    = self.password? [self.password UTF8String] : "";
    const char *database    = self.database? [self.database UTF8String] : NULL;
    const char *socket      = self.socket? [self.socket UTF8String] : NULL;
    unsigned int port       = (unsigned int)self.port;
    
    if(!mysql_real_connect(self.db, host, username, password, database, port, socket, 0))
    {
        NSLog(@"Connection error: %@", self.mysqlError);
        return;
    }
    
    if(mysql_set_character_set(self.db, "utf8"))
    {
        NSLog(@"Connection error: %@", self.mysqlError);
        return;
    }
}

- (void)disconnect
{
    if(self.db)
    {
        mysql_close(self.db);
        self.db = nil;
    }
}


@end

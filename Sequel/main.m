//
//  main.m
//  Sequel
//
//  Created by Wess Cope on 11/8/13.
//  Copyright (c) 2013 Nudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SequelConstants.h"
#import "SequelConnection.h"
#import "SequelQuery.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        
        NSLog(@"Hello, World!");
        
        SequelConnection *connection    = [[SequelConnection alloc] init];
        connection.host                 = @"localhost";
        connection.username             = @"root";
        connection.database             = @"paid";
        
        NSError *error = nil;
        [connection connect:&error];
        
        SequelQuery *query = [SequelQuery queryWithConnection:connection];
        [query executeQuery:@"SELECT * FROM settings" completionHandler:^(NSArray *results, NSError *error) {
            NSLog(@"Results: %@", results);
        }];

    }
    
    dispatch_main();
    
    return 0;
}


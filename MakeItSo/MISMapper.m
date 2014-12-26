//
//  MISMapper.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISMapper.h"

@implementation MISMapper

- (void)dealloc {
    self.tableName = nil;
    self.columnList = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SELECT

- (id)findObject:(NSNumber *)key {
    TDAssert(0);
    return nil;
}


- (NSSet *)findObjectsWhere:(NSString *)whereClause {
    TDAssert([self.tableName length]);
    TDAssert([self.columnList length]);
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", self.columnList, self.tableName, whereClause];
    
    
    NSMutableSet *result = [NSMutableSet set];
    
    return result;
    
}


#pragma mark -
#pragma mark UPDATE

- (void)update:(DomainObject *)obj {
    
}


#pragma mark -
#pragma mark INSERT

- (NSNumber *)insert:(DomainObject *)obj {
    TDAssert(0);
    return nil;
}


#pragma mark -
#pragma mark DELETE

- (void)delete:(DomainObject *)obj {
    TDAssert(0);
}


#pragma mark -
#pragma mark LOAD

- (DomainObject *)load:(FMResultSet *)rs {
    TDAssert(0);
    return nil;
}


@end

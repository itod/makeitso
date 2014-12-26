//
//  MISMapper.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISMapper.h"
#import "MISUnitOfWork.h"

#import <fmdb/FMDatabase.h>
#import <fmdb/FMResultSet.h>

@interface MISMapper ()
@property (nonatomic, retain) MISUnitOfWork *unitOfWork;
@end

@implementation MISMapper

- (void)dealloc {
    self.tableName = nil;
    self.columnList = nil;
    self.unitOfWork = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SELECT

- (id)findObject:(NSNumber *)objID {
    TDAssertDatabaseThread();
    TDAssert(0);
    return nil;
}


- (NSSet *)findObjectsWhere:(NSString *)whereClause {
    TDAssertDatabaseThread();
    TDAssert([self.tableName length]);
    TDAssert([self.columnList length]);
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", self.columnList, self.tableName, whereClause];
    
    
    NSMutableSet *result = [NSMutableSet set];
    
    return result;
    
}


#pragma mark -
#pragma mark UPDATE

- (void)update:(DomainObject *)obj {
    TDAssertDatabaseThread();
    
}


#pragma mark -
#pragma mark INSERT

- (NSNumber *)insert:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(0);
    return nil;
}


#pragma mark -
#pragma mark DELETE

- (void)delete:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(0);
}


#pragma mark -
#pragma mark LOAD

- (DomainObject *)load:(FMResultSet *)rs {
    TDAssertDatabaseThread();
    TDAssert(0);
    return nil;
}


@end

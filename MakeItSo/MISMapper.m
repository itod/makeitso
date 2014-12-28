//
//  MISMapper.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISMapper.h"
#import "MISUnitOfWork.h"

#import "DomainObject.h"

#import <fmdb/FMDatabase.h>
#import <fmdb/FMResultSet.h>

@interface DomainObject ()
@property (nonatomic, retain, readwrite) NSNumber *objectID;
@end

@interface MISUnitOfWork ()
@property (nonatomic, retain, readonly) FMDatabase *database;
@end

@interface MISMapper ()
@property (nonatomic, retain) MISUnitOfWork *unitOfWork;
@end

@implementation MISMapper

- (id)initWithDomainClass:(Class)cls {
    self = [super init];
    if (self) {
        self.domainClass = cls;
    }
    return self;
}


- (void)dealloc {
    self.domainClass = Nil;
    self.tableName = nil;
    self.selectColumnList = nil;
    self.columnNames = nil;
    self.unitOfWork = nil;
    [super dealloc];
}


- (FMDatabase *)database {
    TDAssertDatabaseThread();
    TDAssert(_unitOfWork);
    FMDatabase *db = _unitOfWork.database;
    TDAssert(db);
    return db;
}


#pragma mark -
#pragma mark SELECT

- (DomainObject *)findObject:(NSNumber *)objID {
    TDAssertDatabaseThread();
    
    DomainObject *obj = [_unitOfWork objectForID:objID];
    if (obj) return obj;

    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE objectID = ?", self.selectColumnList, self.tableName];
    
    FMResultSet *rs = nil;
    @try {
        rs = [self.database executeQuery:sql, objID];
        [rs next];
        obj = [self load:rs];
    }
    @catch (NSException *ex) {
        NSLog(@"%@", ex);
    }
    @finally {

    }

    return obj;
}


- (NSSet *)findObjectsWhere:(NSString *)whereClause {
    TDAssertDatabaseThread();
    TDAssert([self.tableName length]);
    TDAssert([self.selectColumnList length]);
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", self.selectColumnList, self.tableName, whereClause];
    
    
    NSMutableSet *result = [NSMutableSet set];
    
    return result;
    
}


#pragma mark -
#pragma mark UPDATE

- (void)update:(DomainObject *)obj {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


#pragma mark -
#pragma mark INSERT

- (NSNumber *)insert:(DomainObject *)obj {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


#pragma mark -
#pragma mark DELETE

- (void)delete:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj.objectID);
    if (!obj.objectID) return;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE objectID = ?", self.tableName];
    
    FMResultSet *rs = nil;
    @try {
        rs = [self.database executeQuery:sql, obj.objectID];
        [rs next];
        obj = [self load:rs];
    }
    @catch (NSException *ex) {
        NSLog(@"%@", ex);
    }
    @finally {
        
    }
}


#pragma mark -
#pragma mark LOAD

- (DomainObject *)load:(FMResultSet *)rs {
    TDAssertDatabaseThread();
    TDAssert(rs);
    TDAssert(_unitOfWork);
    TDAssert(_domainClass);
    
    NSNumber *objID = [rs objectForColumnName:@"objectID"];
    DomainObject *obj = [_unitOfWork objectForID:objID];
    if (obj) return obj;

    obj = [[[self domainClass] new] autorelease];
    obj.objectID = objID;
    
    [self loadFields:rs inObject:obj];
    
    return obj;
}


- (void)loadFields:(FMResultSet *)rs inObject:(DomainObject *)obj {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
//    TDAssertDatabaseThread();
//    TDAssert(_columnNames);
//    
//    for (NSString *colName in self.columnNames) {
//        id val = [rs objectForColumnName:colName];
//        [obj setValue:val forKey:colName];
//    }
}

@end

//
//  MISMapper.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISMapper.h"
#import "MISUnitOfWork.h"
#import "MISKeyGenerator.h"

#import "DomainObject.h"

#import <fmdb/FMDatabase.h>
#import <fmdb/FMResultSet.h>

@interface DomainObject ()
- (void)markClean;
- (void)markDirty;

@property (nonatomic, retain, readwrite) NSNumber *objectID;
@end

@interface MISUnitOfWork ()
- (void)wasLoaded:(DomainObject *)obj;
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
    self.persistentFieldNames = nil;
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
#pragma mark OBSERVING

- (void)startObservingObject:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj);
    TDAssert(_persistentFieldNames);
    
    for (NSString *propName in _persistentFieldNames) {
        [obj addObserver:self forKeyPath:propName options:0 context:NULL];
    }
}


- (void)stopObservingObject:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj);
    TDAssert(_persistentFieldNames);
    
    for (NSString *propName in _persistentFieldNames) {
        [obj removeObserver:self forKeyPath:propName];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)obj change:(NSDictionary *)change context:(void *)ctx {
    TDAssertDatabaseThread(); // ??
    TDAssert([obj isKindOfClass:[DomainObject class]]);
    TDAssert([_persistentFieldNames containsObject:keyPath]);

    [obj markDirty];
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


- (void)updateForeignKeys:(NSArray *)memIDs forObject:(DomainObject *)obj inTable:(NSString *)tableName {
    [self deleteForeignKeysForObject:obj inTable:tableName];
    [self insertForeignKeys:memIDs forObject:obj inTable:tableName];
}


#pragma mark -
#pragma mark INSERT

- (NSNumber *)insert:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj);

    NSNumber *objID = [self nextDatabaseKey];
    obj.objectID = objID;
    [self performInsert:obj];
    TDAssert([objID isEqualToNumber:obj.objectID]);
    return objID;
}


- (void)performInsert:(DomainObject *)obj {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (NSNumber *)nextDatabaseKey {
    return [[MISKeyGenerator instance] nextKey];
}


- (void)insertForeignKeys:(NSArray *)memIDs forObject:(DomainObject *)obj inTable:(NSString *)tableName {
    TDAssertDatabaseThread();
    TDAssert([memIDs count]);
    TDAssert(obj);
    TDAssert([tableName length]);
    TDAssert(self.unitOfWork);
    if (!obj.objectID) return;
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (ownerID, memberID) VALUES (?, ?)", tableName];
    
    BOOL success = NO;
    @try {
        for (NSString *memID in memIDs) {
            NSArray *args = @[obj.objectID, memID];
            success = [self.database executeUpdate:sql withArgumentsInArray:args];
        }
    }
    @catch (NSException *ex) {
        NSLog(@"%@", ex);
    }
    @finally {
        
    }
}


#pragma mark -
#pragma mark DELETE

- (void)delete:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj.objectID);
    if (!obj.objectID) return;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE objectID = ?", self.tableName];
    NSArray *args = @[obj.objectID];
    
    BOOL success = NO;
    @try {
        success = [self.database executeUpdate:sql withArgumentsInArray:args];
    }
    @catch (NSException *ex) {
        NSLog(@"%@", ex);
    }
    @finally {
        
    }
}


- (void)deleteForeignKeysForObject:(DomainObject *)obj inTable:(NSString *)tableName {
    TDAssertDatabaseThread();
    TDAssert(obj);
    TDAssert([tableName length]);
    TDAssert(self.unitOfWork);
    if (!obj.objectID) return;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ownerID = ?", self.tableName];
    NSArray *args = @[obj.objectID];
    
    BOOL success = NO;
    @try {
        success = [self.database executeUpdate:sql withArgumentsInArray:args];
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
    
    [obj markClean];
    
    return obj;
}


- (void)loadFields:(FMResultSet *)rs inObject:(DomainObject *)obj {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (NSArray *)loadForeignKeysForObject:(DomainObject *)obj fromTable:(NSString *)tableName {
    TDAssertDatabaseThread();
    TDAssert(obj.objectID);
    if (!obj.objectID) return nil;
    
    NSMutableArray *memIDs = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT foreignID FROM %@ WHERE objectID = ?", self.tableName];
    
    FMResultSet *rs = nil;
    @try {
        rs = [self.database executeQuery:sql, obj.objectID];
        while ([rs hasAnotherRow]) {
            [rs next];
            NSString *memID = [rs stringForColumn:@"foreignID"];
            if (memID) [memIDs addObject:memID];
        }
    }
    @catch (NSException *ex) {
        NSLog(@"%@", ex);
    }
    @finally {
        
    }
    
    return memIDs;
}

@end

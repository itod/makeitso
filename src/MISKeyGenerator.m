//
//  MISKeyGenerator.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/30/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISKeyGenerator.h"
#import "MISUnitOfWork.h"

#import <fmdb/FMDatabase.h>
#import <fmdb/FMResultSet.h>

static MISKeyGenerator *sInstance = nil;

@interface MISUnitOfWork ()
@property (nonatomic, retain, readonly) FMDatabase *database;
@end

@interface MISKeyGenerator ()
@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, assign) NSUInteger increment;
@property (nonatomic, assign) NSUInteger nextId;
@property (nonatomic, assign) NSUInteger maxId;
@end

@implementation MISKeyGenerator

+ (instancetype)instance {
    TDAssertDatabaseThread();
    
    if (!sInstance) {
        sInstance = [[MISKeyGenerator alloc] initWithDatabase:[[MISUnitOfWork current] database] keyName:@"global" incrementBy:5];
    }
    
    return sInstance;
}


- (instancetype)initWithDatabase:(FMDatabase *)db keyName:(NSString *)name incrementBy:(NSUInteger)inc {
    TDAssert(db);
    TDAssert([name length]);
    TDAssert(inc > 0);

    self = [super init];
    if (self) {
        self.database = db;
        self.keyName = name;
        self.increment = inc;
        self.nextId = 1;
        self.maxId = 1;
    }
    return self;
}


- (void)dealloc {
    self.database = nil;
    self.keyName = nil;
    [super dealloc];
}


- (NSNumber *)nextKey {
    TDAssertDatabaseThread();
    
    if (_nextId == _maxId) {
        [self reserveIds];
    }
    
    return @(self.nextId++);
}


- (void)reserveIds {
    TDAssertDatabaseThread();
    TDAssert(_database);
    TDAssert([_keyName length]);
    
    FMResultSet *rs = nil;
    NSUInteger newNextID = 0;
    
    @try {
        rs = [_database executeQuery:@"SELECT nextID FROM keys WHERE name = ?", _keyName];
        [rs next];
        newNextID = [rs longLongIntForColumn:@"nextID"];
    }
    @catch (NSException *ex) {
        
    }
    @finally {
        
    }
    
    NSUInteger newMaxID = newNextID + _increment;
    
    @try {
        [_database executeUpdate:@"UPDATE keys SET nextID = ? WHERE name = ?", newMaxID, _keyName];
        self.nextId = newNextID;
        self.maxId = newMaxID;
    }
    @catch (NSException *ex) {
        
    }
    @finally {
        
    }
}


@end

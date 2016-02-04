//
//  MISUnitOfWork.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISUnitOfWork.h"
#import "MISMapper.h"

#import "DomainObject.h"

#import <fmdb/FMDatabase.h>

#define THREAD_LOCAL_KEY @"MISUnitOfWork"

NSString *const MISErrorDomainRemote = @"MISErrorDomainRemote";
NSString *const MISErrorDomainLocal = @"MISErrorDomainLocal";

//static dispatch_queue_t sDatabaseQueue = NULL;
//
//void MISPerformOnDatabaseThread(void (^block)(void)) {
//    //assert(block);
//    
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        sDatabaseQueue = dispatch_queue_create("com.celestialteapot.MakeItSo", 0);
//    });
//    
//    dispatch_async(sDatabaseQueue, block);
//}

void MISPerformOnDatabaseThread(void (^block)(void)) {
    //assert(block);
    dispatch_async(dispatch_get_main_queue(), block);
}

void MISPerformOnMainThread(void (^block)(void)) {
    //assert(block);
    dispatch_async(dispatch_get_main_queue(), block);
}

void MISPerformOnBackgroundThread(void (^block)(void)) {
    //assert(block);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

@interface MISMapper ()
- (void)startObservingObject:(DomainObject *)obj;
- (void)stopObservingObject:(DomainObject *)obj;
@end

@interface MISUnitOfWork ()
@property (nonatomic, retain) FMDatabase *database;

@property (nonatomic, retain) NSMutableDictionary *objectTab;
@property (nonatomic, retain) NSMutableDictionary *mapperTab;

@property (nonatomic, retain) NSMutableSet *pristineObjects;
@property (nonatomic, retain) NSMutableSet *dirtyObjects;
@property (nonatomic, retain) NSMutableSet *removedObjects;
@end

@implementation MISUnitOfWork

- (instancetype)init {
    self = [super init];
    if (self) {
        self.database = [FMDatabase databaseWithPath:@""];
        TDAssert(_database);
        [_database open];
        
        self.objectTab = [NSMutableDictionary dictionary];
        self.mapperTab = [NSMutableDictionary dictionary];
        
        self.pristineObjects = [NSMutableSet set];
        self.dirtyObjects = [NSMutableSet set];
        self.removedObjects = [NSMutableSet set];
    }
    return self;
}


- (void)dealloc {
    TDAssert(_database);
    [_database close];
    
    self.database = nil;
    self.objectTab = nil;
    self.mapperTab = nil;
    
    self.pristineObjects = nil;
    self.dirtyObjects = nil;
    self.removedObjects = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Setup

+ (void)makeCurrent {
    MISUnitOfWork *uow = [[[MISUnitOfWork alloc] init] autorelease];
    [self setCurrent:uow];
}


+ (MISUnitOfWork *)current {
    TDAssertDatabaseThread();
    NSThread *thread = [NSThread currentThread];
    MISUnitOfWork *uow = thread.threadDictionary[THREAD_LOCAL_KEY];
    TDAssert(uow);
    return uow;
}


+ (void)setCurrent:(MISUnitOfWork *)uow {
    TDAssertDatabaseThread();
    TDAssert(uow);
    NSThread *thread = [NSThread currentThread];
    thread.threadDictionary[THREAD_LOCAL_KEY] = uow;
}


#pragma mark -
#pragma mark Mapper Registration

- (void)registerMapper:(MISMapper *)mapper forDomainClass:(Class)cls {
    TDAssertDatabaseThread();
    TDAssert([cls isSubclassOfClass:[DomainObject class]]);
    TDAssert(mapper);
    TDAssert(_mapperTab);
    _mapperTab[NSStringFromClass(cls)] = mapper;
}


- (MISMapper *)mapperForDomainClass:(Class)cls {
    TDAssertDatabaseThread();
    TDAssert([cls isSubclassOfClass:[DomainObject class]]);
    TDAssert(_mapperTab);
    MISMapper *mapper = _mapperTab[NSStringFromClass(cls)];
    TDAssert(mapper);
    return mapper;
}


#pragma mark -
#pragma mark Object Registration

- (void)registerPristine:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj.objectID);
    TDAssert(_pristineObjects);
    TDAssert(_dirtyObjects);
    TDAssert(_removedObjects);
    TDAssert(![_pristineObjects containsObject:obj]);
    TDAssert(![_dirtyObjects containsObject:obj]);
    TDAssert(![_removedObjects containsObject:obj]);

    [_pristineObjects addObject:obj];

    [self addObject:obj];
}


- (void)registerClean:(DomainObject *)obj {
    TDAssert(obj.objectID);

    [_pristineObjects removeObject:obj];
    
    [self addObject:obj];
}


- (void)registerDirty:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj.objectID);
    TDAssert(_pristineObjects);
    TDAssert(_dirtyObjects);
    TDAssert(_removedObjects);
    TDAssert(![_removedObjects containsObject:obj]);

    if (![_dirtyObjects containsObject:obj] && ![_pristineObjects containsObject:obj]) {
        [_dirtyObjects addObject:obj];
    }
}


- (void)registerRemoved:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj.objectID);
    TDAssert(_pristineObjects);
    TDAssert(_dirtyObjects);
    TDAssert(_removedObjects);
    
    [self removeObject:obj];
    
    if ([_pristineObjects containsObject:obj]) {
        [_pristineObjects removeObject:obj];
        return;
    }
    
    [_dirtyObjects removeObject:obj];
    [_removedObjects addObject:obj];
}


#pragma mark -
#pragma mark Commiting

- (void)commitWithCompletion:(void (^)(BOOL success, NSError *err))callback {
    TDAssertMainThread();
    
    [self doRemoteCommit:^(BOOL success, NSError *err) {
        TDAssertMainThread();
        
        if (!success) {
            callback(success, err);
            return;
        }
        
        [self doLocalCommit:^(BOOL success, NSError *err) {
            TDAssertMainThread();
            
            callback(success, err);
        }];
    }];
}


- (void)doRemoteCommit:(void (^)(BOOL success, NSError *err))callback {
    TDAssertMainThread();
    
    MISPerformOnBackgroundThread(^{
        
        // do network request
        NSError *err = nil;
        BOOL success = YES;
        
        if (!success) {
            NSString *errMsg = @"";
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
            err = [NSError errorWithDomain:MISErrorDomainRemote code:0 userInfo:userInfo];
        }

        MISPerformOnMainThread(^{
            callback(success, err);
        });
    });
}


- (void)doLocalCommit:(void (^)(BOOL success, NSError *err))callback {
    TDAssertMainThread();
    
    MISPerformOnDatabaseThread(^{
        NSError *err = nil;
        BOOL success = [self commit:&err];
        
        MISPerformOnMainThread(^{
            callback(success, err);
        });
    });
}


- (BOOL)commit:(NSError **)outErr {
    TDAssertDatabaseThread();
    TDAssert(_database);

    [_database beginTransaction];
    
    [self insertPristine];
    [self updateDirty];
    [self deleteRemoved];
    
    BOOL success = [_database commit];
    if (!success) {
        if (outErr) *outErr = [self lastDatabaseError];
        return NO; // return early ??
    }
    
    [_pristineObjects removeAllObjects];
    [_dirtyObjects removeAllObjects];
    [_removedObjects removeAllObjects];

    // clear memory cache
    for (DomainObject *obj in [[_objectTab copy] autorelease]) {
        [self removeObject:obj];
    }
    
    return YES;
}


- (NSError *)lastDatabaseError {
    TDAssertDatabaseThread();
    TDAssert(_database);
    
    NSString *errMsg = _database.lastErrorMessage;
    NSDictionary *userInfo = nil;
    if (errMsg) userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:MISErrorDomainLocal code:_database.lastErrorCode userInfo:userInfo];
}


- (void)insertPristine {
    TDAssertDatabaseThread();
    TDAssert(_pristineObjects);
    
    for (DomainObject *obj in _pristineObjects) {
        [[self mapperForDomainClass:[obj class]] insert:obj];
    }
}


- (void)updateDirty {
    TDAssertDatabaseThread();
    TDAssert(_dirtyObjects);
    
    for (DomainObject *obj in _dirtyObjects) {
        [[self mapperForDomainClass:[obj class]] update:obj];
    }
}


- (void)deleteRemoved {
    TDAssertDatabaseThread();
    TDAssert(_removedObjects);
    
    for (DomainObject *obj in _removedObjects) {
        [[self mapperForDomainClass:[obj class]] delete:obj];
    }
}


#pragma mark -
#pragma mark Object Lookup

- (BOOL)isLoaded:(NSNumber *)objID {
    BOOL res = nil != [self objectForID:objID];
    return res;
}


- (DomainObject *)objectForID:(NSNumber *)objID {
    TDAssertDatabaseThread();
    TDAssert(objID);
    TDAssert(_objectTab);
    
    DomainObject *obj = _objectTab[objID];
    return obj;
}


- (void)addObject:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj);
    TDAssert(_objectTab);
    
    _objectTab[obj.objectID] = obj;
    
    [[self mapperForDomainClass:[obj class]] startObservingObject:obj];
}


- (void)removeObject:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj);
    TDAssert(nil != _objectTab[obj.objectID]);
    
    [[obj retain] autorelease];
    
    [[self mapperForDomainClass:[obj class]] stopObservingObject:obj];

    [_objectTab removeObjectForKey:obj.objectID];
}

@end

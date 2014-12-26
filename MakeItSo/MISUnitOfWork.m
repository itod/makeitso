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

#define THREAD_LOCAL_KEY @"MISUnitOfWork"

@interface MISUnitOfWork ()
@property (nonatomic, retain) NSMutableDictionary *mapperTab;

@property (nonatomic, retain) NSMutableSet *pristineObjects;
@property (nonatomic, retain) NSMutableSet *dirtyObjects;
@property (nonatomic, retain) NSMutableSet *removedObjects;
@end

@implementation MISUnitOfWork

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mapperTab = [NSMutableDictionary dictionary];
        
        self.pristineObjects = [NSMutableSet set];
        self.dirtyObjects = [NSMutableSet set];
        self.removedObjects = [NSMutableSet set];
    }
    return self;
}


- (void)dealloc {
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

    NSThread *thread = [NSThread currentThread];
    thread.threadDictionary[THREAD_LOCAL_KEY] = uow;
}


+ (MISUnitOfWork *)current {
    NSThread *thread = [NSThread currentThread];
    MISUnitOfWork *uow = thread.threadDictionary[THREAD_LOCAL_KEY];
    TDAssert(uow);
    return uow;
}


#pragma mark -
#pragma mark Mapper Registration

- (void)registerMapper:(MISMapper *)mapper forDomainClass:(Class)cls {
    TDAssert([cls isSubclassOfClass:[DomainObject class]]);
    TDAssert(mapper);
    TDAssert(_mapperTab);
    _mapperTab[NSStringFromClass(cls)] = mapper;
}


- (MISMapper *)mapperForDomainClass:(Class)cls {
    TDAssert([cls isSubclassOfClass:[DomainObject class]]);
    TDAssert(_mapperTab);
    MISMapper *mapper = _mapperTab[NSStringFromClass(cls)];
    TDAssert(mapper);
    return mapper;
}


#pragma mark -
#pragma mark Object Registration

- (void)registerPristine:(DomainObject *)obj {
    TDAssert(obj.objectID);
    TDAssert(![_pristineObjects containsObject:obj]);
    TDAssert(![_dirtyObjects containsObject:obj]);
    TDAssert(![_removedObjects containsObject:obj]);
    [_pristineObjects addObject:obj];
}


- (void)registerClean:(DomainObject *)obj {
    TDAssert(obj.objectID);
    // noop
}


- (void)registerDirty:(DomainObject *)obj {
    TDAssert(obj.objectID);
    TDAssert(![_removedObjects containsObject:obj]);
    if (![_dirtyObjects containsObject:obj] && ![_pristineObjects containsObject:obj]) {
        [_dirtyObjects addObject:obj];
    }
}


- (void)registerRemoved:(DomainObject *)obj {
    TDAssert(obj.objectID);
    if ([_pristineObjects containsObject:obj]) {
        [_pristineObjects removeObject:obj];
        return;
    }
    [_dirtyObjects removeObject:obj];
    [_removedObjects addObject:obj];
}


#pragma mark -
#pragma mark Commiting

- (void)commit {
    [self insertPristine];
    [self updateDirty];
    [self deleteRemoved];
}


- (void)insertPristine {
    for (DomainObject *obj in _pristineObjects) {
        MISMapper *mapper = [self mapperForDomainClass:[obj class]];
        TDAssert(mapper);
        [mapper insert:obj];
    }
}


- (void)updateDirty {
    for (DomainObject *obj in _dirtyObjects) {
        MISMapper *mapper = [self mapperForDomainClass:[obj class]];
        TDAssert(mapper);
        [mapper update:obj];
    }
}


- (void)deleteRemoved {
    for (DomainObject *obj in _removedObjects) {
        MISMapper *mapper = [self mapperForDomainClass:[obj class]];
        TDAssert(mapper);
        [mapper delete:obj];
    }
}


#pragma mark -
#pragma mark Object Lookup

- (BOOL)isLoaded:(NSNumber *)objID {
    TDAssert(0);
    return NO;
}


- (DomainObject *)objectForID:(NSNumber *)objID {
    TDAssert(0);
    return nil;
}

@end

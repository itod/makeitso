//
//  MISUnitOfWork.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISUnitOfWork.h"
#import "DomainObject.h"

@interface MISUnitOfWork ()
@property (nonatomic, retain) NSMutableDictionary *mapperTab;

@property (nonatomic, retain) NSMutableSet *brandNewObjects;
@property (nonatomic, retain) NSMutableSet *dirtyObjects;
@property (nonatomic, retain) NSMutableSet *removedObjects;
@end

@implementation MISUnitOfWork

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mapperTab = [NSMutableDictionary dictionary];
        
        self.brandNewObjects = [NSMutableSet set];
        self.dirtyObjects = [NSMutableSet set];
        self.removedObjects = [NSMutableSet set];
    }
    return self;
}


- (void)dealloc {
    self.mapperTab = nil;
    
    self.brandNewObjects = nil;
    self.dirtyObjects = nil;
    self.removedObjects = nil;
    
    [super dealloc];
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

- (void)registerBrandNew:(DomainObject *)obj {
    TDAssert(obj.objectID);
    TDAssert(![_brandNewObjects containsObject:obj]);
    TDAssert(![_dirtyObjects containsObject:obj]);
    TDAssert(![_removedObjects containsObject:obj]);
    [_brandNewObjects addObject:obj];
}


- (void)registerClean:(DomainObject *)obj {
    TDAssert(obj.objectID);
    // noop
}


- (void)registerDirty:(DomainObject *)obj {
    TDAssert(obj.objectID);
    TDAssert(![_removedObjects containsObject:obj]);
    if (![_dirtyObjects containsObject:obj] && ![_brandNewObjects containsObject:obj]) {
        [_dirtyObjects addObject:obj];
    }
}


- (void)registerRemoved:(DomainObject *)obj {
    TDAssert(obj.objectID);
    if ([_brandNewObjects containsObject:obj]) {
        [_brandNewObjects removeObject:obj];
        return;
    }
    [_dirtyObjects removeObject:obj];
    [_removedObjects addObject:obj];
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

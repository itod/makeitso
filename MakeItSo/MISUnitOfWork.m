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

@property (nonatomic, retain) NSMutableArray *brandNewObjects;
@property (nonatomic, retain) NSMutableArray *dirtyObjects;
@property (nonatomic, retain) NSMutableArray *removedObjects;
@end

@implementation MISUnitOfWork

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mapperTab = [NSMutableDictionary dictionary];
        
        self.brandNewObjects = [NSMutableArray array];
        self.dirtyObjects = [NSMutableArray array];
        self.removedObjects = [NSMutableArray array];
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

- (void)registerClean:(DomainObject *)obj {
    TDAssert(0);
}


- (void)registerDirty:(DomainObject *)obj {
    TDAssert(0);
}


- (void)registerBrandNew:(DomainObject *)obj {
    TDAssert(0);
}


- (void)registerRemoved:(DomainObject *)obj {
    TDAssert(0);
}


#pragma mark -
#pragma mark Object Lookup

- (BOOL)isLoaded:(NSNumber *)key {
    TDAssert(0);
    return NO;
}


- (DomainObject *)objectForKey:(NSNumber *)key {
    TDAssert(0);
    return nil;
}

@end

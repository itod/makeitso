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
@end

@implementation MISUnitOfWork

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mapperTab = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.mapperTab = nil;
    [super dealloc];
}


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


- (void)registerClean:(DomainObject *)obj {
    TDAssert(0);
}

@end

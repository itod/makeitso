//
//  DomainObject.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "DomainObject.h"

#import "MISUnitOfWork.h"

@implementation DomainObject

- (void)dealloc {
    self.objectID = nil;
    [super dealloc];
}


- (void)markPristine {
    [[MISUnitOfWork current] registerPristine:self];
}


- (void)markClean {
    [[MISUnitOfWork current] registerClean:self];
}


- (void)markDirty {
    [[MISUnitOfWork current] registerDirty:self];
}


- (void)markRemoved {
    [[MISUnitOfWork current] registerRemoved:self];
}

@end

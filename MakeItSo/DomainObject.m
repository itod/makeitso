//
//  DomainObject.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "DomainObject.h"

#import "MISUnitOfWork.h"

@interface DomainObject ()
@property (nonatomic, retain, readwrite) NSNumber *objectID;
@end

@implementation DomainObject

+ (NSString *)collectionName {
    NSString *str = NSStringFromClass(self);
    str = [NSString stringWithFormat:@"%@%@", [[str substringToIndex:1] lowercaseString], [str substringFromIndex:1]];
    return str;
}


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

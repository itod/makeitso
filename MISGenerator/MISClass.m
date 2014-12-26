//
//  MISClass.m
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISClass.h"

@interface MISClass ()
@property (nonatomic, retain) NSMutableArray *allFields;
@end

@implementation MISClass

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allFields = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.allFields = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, self.name];
}


- (void)addField:(MISField *)field {
    TDAssert(_allFields);
    TDAssert(field);
    
    [_allFields addObject:field];
}


- (NSArray *)fields {
    return [[_allFields copy] autorelease];
}

@end

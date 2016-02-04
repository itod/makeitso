//
//  MISClass.m
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISClass.h"
#import "MISField.h"

@interface MISClass ()
@property (nonatomic, retain) NSMutableArray *allFields;
@property (nonatomic, retain) NSMutableSet *allRelationshipClassNames;
@end

@implementation MISClass

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allFields = [NSMutableArray array];
        self.allRelationshipClassNames = [NSMutableSet set];
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.allFields = nil;
    self.allRelationshipClassNames = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, self.name];
}


- (void)addField:(MISField *)field {
    TDAssert(_allFields);
    TDAssert(field);
    
    [_allFields addObject:field];
    //[_allFields sortedArrayUsingSelector:@selector(compare:)];
}


- (void)addRelationshipClassName:(NSString *)str {
    TDAssert(_allRelationshipClassNames);
    TDAssert(str);
    
    [_allRelationshipClassNames addObject:str];
}


- (NSArray *)fields {
    return [[_allFields copy] autorelease];
}


- (NSArray *)oneToOneFields {
    NSMutableArray *result = [NSMutableArray array];
    for (MISField *field in _allFields) {
        if (MISFieldRelationshipOneToOne == field.relationship) {
            [result addObject:field];
        }
    }
    return [[result copy] autorelease];
}


- (NSArray *)oneToManyFields {
    NSMutableArray *result = [NSMutableArray array];
    for (MISField *field in _allFields) {
        if (MISFieldRelationshipOneToMany == field.relationship) {
            [result addObject:field];
        }
    }
    return [[result copy] autorelease];
}


- (NSArray *)relationshipClassNames {
    NSMutableArray *v = [[[_allRelationshipClassNames allObjects] mutableCopy] autorelease];
    [v sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return [[v copy] autorelease];
}

@end

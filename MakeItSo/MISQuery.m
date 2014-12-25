//
//  MISQuery.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISQuery.h"

@interface MISQuery ()
@property (nonatomic, retain) NSMutableArray *crits;
@end

@implementation MISQuery

+ (instancetype)queryForWith:(Class)cls {
    return [[[self alloc] initWithClass:cls] autorelease];
}


- (instancetype)initWithClass:(Class)cls {
    self = [super init];
    if (self) {
        self.crits = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}


- (void)dealloc {
    self.crits = nil;
    [super dealloc];
}


- (void)addCriteria:(MISCriteria *)crit {
    TDAssert(_crits);
    [_crits addObject:crit];
}


- (NSArray *)criteria {
    TDAssert(_crits);
    return [[_crits copy] autorelease];
}

@end

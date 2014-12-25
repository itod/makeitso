//
//  MISCriteria.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISCriteria.h"

@interface MISCriteria ()
@property (nonatomic, assign) MISCriteriaOperator operator;
@property (nonatomic, retain) id argument;
@end

@implementation MISCriteria

+ (instancetype)equalTo:(id)arg {
    return [[[self alloc] initWithOperator:MISCriteriaOperatorEqualTo argument:arg] autorelease];
}


+ (instancetype)lessThan:(id)arg {
    return [[[self alloc] initWithOperator:MISCriteriaOperatorLessThan argument:arg] autorelease];
}


+ (instancetype)greaterThan:(id)arg {
    return [[[self alloc] initWithOperator:MISCriteriaOperatorGreaterThan argument:arg] autorelease];
}


+ (instancetype)lessThanOrEqualTo:(id)arg {
    return [[[self alloc] initWithOperator:MISCriteriaOperatorLessThanOrEqualTo argument:arg] autorelease];
}


+ (instancetype)greaterThanOrEqualTo:(id)arg {
    return [[[self alloc] initWithOperator:MISCriteriaOperatorGreaterThanOrEqualTo argument:arg] autorelease];
}


- (instancetype)initWithOperator:(MISCriteriaOperator)op argument:(id)arg {
    TDAssert(arg);
    self = [super init];
    if (self) {
        self.operator = op;
        self.argument = arg;
    }
    return self;
}


- (void)dealloc {
    self.argument = nil;
    [super dealloc];
}

@end

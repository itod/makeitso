//
//  MISCriteria.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISCriteria.h"

@interface MISCriteria ()
@property (nonatomic, assign, readwrite) MISCriteriaType type;
@property (nonatomic, assign, readwrite) MISCriteriaOperator op;
@property (nonatomic, copy, readwrite) NSString *lhs;
@property (nonatomic, retain, readwrite) NSString *rhs;
@end

@implementation MISCriteria

+ (instancetype)criteriaWithType:(MISCriteriaType)type lhs:(NSString *)lhs op:(MISCriteriaOperator)op rhs:(id)rhs {
    return [[[self alloc] initWithType:type lhs:lhs op:op rhs:rhs] autorelease];
}


- (instancetype)initWithType:(MISCriteriaType)type lhs:(NSString *)lhs op:(MISCriteriaOperator)op rhs:(id)rhs {
    TDAssert([lhs length]);
    TDAssert(rhs);
    self = [super init];
    if (self) {
        self.type = type;
        self.lhs = lhs;
        self.op = op;
        self.rhs = rhs;
    }
    return self;
}


- (void)dealloc {
    self.lhs = nil;
    self.rhs = nil;
    [super dealloc];
}


- (NSString *)generateSql {
    NSString *sql = nil;
    
    switch (_op) {
        case MISCriteriaOperatorEqualTo:
            sql = [NSString stringWithFormat:@"%@ = %@", _lhs, _rhs];
            break;
        case MISCriteriaOperatorNotEqualTo:
            sql = [NSString stringWithFormat:@"%@ != %@", _lhs, _rhs];
            break;
        case MISCriteriaOperatorLessThan:
            sql = [NSString stringWithFormat:@"%@ < %@", _lhs, _rhs];
            break;
        case MISCriteriaOperatorGreaterThan:
            sql = [NSString stringWithFormat:@"%@ > %@", _lhs, _rhs];
            break;
        case MISCriteriaOperatorLessThanOrEqualTo:
            sql = [NSString stringWithFormat:@"%@ <= %@", _lhs, _rhs];
            break;
        case MISCriteriaOperatorGreaterThanOrEqualTo:
            sql = [NSString stringWithFormat:@"%@ >= %@", _lhs, _rhs];
            break;
        case MISCriteriaOperatorLike:
            sql = [NSString stringWithFormat:@"UPPER(%@) LIKE UPPER('%@')", _lhs, _rhs];
            break;
        default:
            TDAssert(0);
            break;
    }
    
    return sql;
}

@end

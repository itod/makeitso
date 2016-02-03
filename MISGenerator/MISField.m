//
//  MISField.m
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISField.h"

@implementation MISField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sqlType = MISFieldSqlTypeInvalid;
    }
    return self;
}


- (void)dealloc {
    self.sourceString = nil;
    self.name = nil;
    self.type = nil;
    self.className = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, self.name];
}


- (NSString *)sqlTypeString {
    NSString *str = nil;
    
    switch (self.sqlType) {
        case MISFieldSqlTypeNull:
            str = @"NULL";
            break;
        case MISFieldSqlTypeText:
            str = @"TEXT";
            break;
        case MISFieldSqlTypeInteger:
            str = @"INTEGER";
            break;
        case MISFieldSqlTypeReal:
            str = @"REAL";
            break;
        case MISFieldSqlTypeDate:
            str = @"INTEGER";
            break;
        case MISFieldSqlTypeData:
            str = @"BLOB";
            break;
        case MISFieldSqlTypeDomainObject:
            str = @"INTEGER";
            break;
        default:
            TDAssert(0);
            break;
    }
    
    return str;
}

@end

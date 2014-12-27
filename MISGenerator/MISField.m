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
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, self.name];
}


- (MISFieldSqlType)sqlType {
    if (MISFieldSqlTypeInvalid == _sqlType) {
        MISFieldSqlType type = MISFieldSqlTypeInvalid;
        
        if ([self.type hasPrefix:@"NSString"]) {
            type = MISFieldSqlTypeString;
        } else if ([self.type hasPrefix:@"NSNumber"]) {
            type = MISFieldSqlTypeNumber;
        } else if ([self.type hasPrefix:@"NSDate"]) {
            type = MISFieldSqlTypeDate;
        } else if ([self.type hasPrefix:@"NSData"]) {
            type = MISFieldSqlTypeData;
        } else {
            TDAssert(0);
        }
        
        _sqlType = type;
    }
    TDAssert(MISFieldSqlTypeInvalid != _sqlType);
    return _sqlType;
}


- (NSString *)sqlTypeString {
    NSString *str = nil;
    
    switch (self.sqlType) {
        case MISFieldSqlTypeNull:
            str = @"null";
            break;
        case MISFieldSqlTypeString:
            str = @"string";
            break;
        case MISFieldSqlTypeNumber:
            str = @"int";
            break;
        case MISFieldSqlTypeDate:
            str = @"date";
            break;
        case MISFieldSqlTypeData:
            str = @"blob";
            break;
        default:
            TDAssert(0);
            break;
    }
    
    return str;
}

@end

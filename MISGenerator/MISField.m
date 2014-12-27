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


- (NSString *)sqlTypeString {
    NSString *str = nil;
    
    switch (self.sqlType) {
        case MISFieldSqlTypeNull:
            str = @"null";
            break;
        case MISFieldSqlTypeString:
            str = @"string";
            break;
        case MISFieldSqlTypeInteger:
            str = @"integer";
            break;
        case MISFieldSqlTypeReal:
            str = @"real";
            break;
        case MISFieldSqlTypeDate:
            str = @"integer";
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

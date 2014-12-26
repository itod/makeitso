//
//  MISMapper.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISMapper.h"

@implementation MISMapper


- (void)dealloc {
    self.tableName = nil;
    self.columnList = nil;
    [super dealloc];
}


- (NSSet *)findObjectsWhere:(NSString *)whereClause {
    TDAssert([self.tableName length]);
    TDAssert([self.columnList length]);
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", self.columnList, self.tableName, whereClause];
    
    
    NSMutableSet *result = [NSMutableSet set];
    
    return result;
    
}

@end

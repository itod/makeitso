//
//  MISMapper.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MISMapper : NSObject
- (NSSet *)findObjectsWhere:(NSString *)whereClause;

@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *columnList;
@end

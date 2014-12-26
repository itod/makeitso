//
//  MISMapper.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DomainObject;
@class FMResultSet;

@interface MISMapper : NSObject
- (id)findObject:(NSNumber *)key;
- (NSSet *)findObjectsWhere:(NSString *)whereClause;

- (void)update:(DomainObject *)obj;
- (NSNumber *)insert:(DomainObject *)obj;
- (void)delete:(DomainObject *)obj;

- (DomainObject *)load:(FMResultSet *)rs;

@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *columnList;
@end

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

- (id)initWithDomainClass:(Class)cls;

- (DomainObject *)findObject:(NSNumber *)objID;
- (NSSet *)findObjectsWhere:(NSString *)whereClause;

- (void)update:(DomainObject *)obj;
- (NSNumber *)insert:(DomainObject *)obj;
- (void)delete:(DomainObject *)obj;

- (DomainObject *)load:(FMResultSet *)rs;
- (void)loadFields:(FMResultSet *)rs inObject:(DomainObject *)obj;

@property (nonatomic, retain) Class domainClass;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *columnList;
@end

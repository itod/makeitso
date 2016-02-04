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
@class FMDatabase;

@interface MISMapper : NSObject

- (id)initWithDomainClass:(Class)cls;

- (DomainObject *)findObject:(NSNumber *)objID;
- (NSSet *)findObjectsWhere:(NSString *)whereClause;

- (void)update:(DomainObject *)obj;
- (NSNumber *)insert:(DomainObject *)obj;
- (void)delete:(DomainObject *)obj;

- (DomainObject *)load:(FMResultSet *)rs;
- (void)loadFields:(FMResultSet *)rs inObject:(DomainObject *)obj;

- (void)updateForeignKeys:(NSArray *)memIDs forObject:(DomainObject *)obj inTable:(NSString *)tableName;
- (void)insertForeignKeys:(NSArray *)memIDs forObject:(DomainObject *)obj inTable:(NSString *)tableName;
- (void)deleteForeignKeysForObject:(DomainObject *)obj inTable:(NSString *)tableName;

- (NSArray *)loadForeignKeysForObject:(DomainObject *)obj fromTable:(NSString *)tableName;

@property (nonatomic, retain) Class domainClass;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *selectColumnList;
@property (nonatomic, copy) NSString *udpateColumnList;
@property (nonatomic, copy) NSArray *columnNames;
@property (nonatomic, copy) NSArray *persistentPropertyNames;

@property (nonatomic, retain, readonly) FMDatabase *database;
@end

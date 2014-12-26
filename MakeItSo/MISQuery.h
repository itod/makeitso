//
//  MISQuery.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MISCriteria;
@class MISUnitOfWork;

@interface MISQuery : NSObject

+ (instancetype)queryWithDomainClass:(Class)cls;
- (instancetype)initWithDomainClass:(Class)cls;

@property (nonatomic, retain, readonly) Class domainClass;

- (void)addCriteria:(MISCriteria *)crit;
@property (nonatomic, copy, readonly) NSArray *criteria;

- (NSSet *)execute:(MISUnitOfWork *)uow;
@end

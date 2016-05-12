//
//  MISQuery.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISQuery.h"
#import "MISUnitOfWork.h"
#import "MISMapper.h"
#import "MISCriteria.h"

#import "DomainObject.h"

@interface MISQuery ()
@property (nonatomic, retain, readwrite) Class domainClass;
@property (nonatomic, retain) NSMutableArray *crits;
@property (nonatomic, retain) MISUnitOfWork *unitOfWork;

- (NSString *)generateWhereClause;
@end

@implementation MISQuery

+ (instancetype)queryWithDomainClass:(Class)cls {
    return [[[self alloc] initWithDomainClass:cls] autorelease];
}


- (instancetype)init {
    return [self initWithDomainClass:Nil];
}


- (instancetype)initWithDomainClass:(Class)cls {
    TDAssert(!cls || [cls isSubclassOfClass:[DomainObject class]]);
    self = [super init];
    if (self) {
        self.domainClass = cls;
        self.crits = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}


- (void)dealloc {
    self.domainClass = Nil;
    self.crits = nil;
    self.unitOfWork = nil;
    [super dealloc];
}


- (void)addCriteria:(MISCriteria *)crit {
    TDAssert(_crits);
    [_crits addObject:crit];
}


- (NSArray *)criteria {
    TDAssert(_crits);
    return [[_crits copy] autorelease];
}


- (NSSet *)execute:(MISUnitOfWork *)uow {
    TDAssert(uow);
    TDAssert(_domainClass);
    self.unitOfWork = uow;
    MISMapper *mapper = [uow mapperForDomainClass:_domainClass];
    NSSet *objs = [mapper findObjectsWhere:[self generateWhereClause]];
    return objs;
}


#pragma mark -
#pragma mark Private

- (NSString *)generateWhereClause {
    TDAssert([_crits count]);
    
    NSMutableString *buf = [NSMutableString string];
    
    BOOL first = YES;
    for (MISCriteria *crit in _crits) {
        if (!first) {
            [buf appendString:MISCriteriaTypeOr == crit.type ? @" OR " : @" AND "];
        }
        [buf appendString:[crit generateSql]];
        first = NO;
    }
    
    return [[buf copy] autorelease];
}

@end

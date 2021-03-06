//
//  Repository.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "Repository.h"
#import "DomainObject.h"

#import "MISUnitOfWork.h"

#import "MISQueryParser.h"
#import "MISQueryAssembler.h"
#import "MISQuery.h"
#import "MISCriteria.h"

@interface Repository ()
@property (nonatomic, retain) MISQueryAssembler *assembler;
@property (nonatomic, retain) MISQueryParser *parser;
@property (nonatomic, retain) MISUnitOfWork *unitOfWork;
@end

@implementation Repository

- (instancetype)init {
    self = [super init];
    if (self) {
        self.assembler = [[[MISQueryAssembler alloc] init] autorelease];
        self.parser = [[[MISQueryParser alloc] initWithDelegate:_assembler] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.assembler = nil;
    self.parser = nil;
    self.unitOfWork = nil;
    [super dealloc];
}


- (Class)domainClass {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return Nil;
}


- (DomainObject *)find:(NSNumber *)objID {
    TDAssert(objID);
    
    MISQuery *q = [[[MISQuery alloc] init] autorelease];
    [q addCriteria:[MISCriteria criteriaWithType:MISCriteriaTypeAnd lhs:@"objectID" op:MISCriteriaOperatorEqualTo rhs:objID]];
    
    TDAssert(_unitOfWork);
    NSSet *set = [q execute:_unitOfWork];
    TDAssert([set count] <= 1);
    
    DomainObject *obj = [set anyObject];
    
    return obj;
}


- (NSSet *)findAll:(NSString *)queryStr {
    TDAssert([queryStr length]);
    TDAssert(_assembler);
    TDAssert(_parser);
    
    MISQuery *q = [MISQuery queryWithDomainClass:[self domainClass]];
    _assembler.query = q;
    
    NSError *err = nil;
    [_parser parseString:queryStr error:&err];
    
    if (!q) {
        if (err) NSLog(@"%@", err);
        return nil;
    }
    
    NSSet *set = [q execute:_unitOfWork];
    
    return set;
}

@end

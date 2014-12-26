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


- (DomainObject *)find:(NSNumber *)objID {
    MISQuery *q = [[[MISQuery alloc] init] autorelease];
    [q addCriteria:[MISCriteria criteriaWithType:MISCriteriaTypeAnd lhs:@"objectID" op:MISCriteriaOperatorEqualTo rhs:objID]];
    
    NSSet *set = [q execute:_unitOfWork];
    
    DomainObject *obj = [set anyObject];
    
    return obj;
}


- (NSSet *)findAll:(NSString *)queryStr {
    TDAssert([queryStr length]);
    TDAssert(_assembler);
    TDAssert(_parser);
    
    NSError *err = nil;
    MISQuery *q = [_parser parseString:queryStr error:&err];
    
    if (!q) {
        if (err) NSLog(@"%@", err);
        
    }
    
    NSSet *set = [q execute:_unitOfWork];
    
    return set;
}

@end

//
//  QueryParesrTestCase.m
//  MakeItSoTests
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISBaseTestCase.h"

#import "MISQueryParser.h"
#import "MISQueryAssembler.h"
#import "MISQuery.h"
#import "MISCriteria.h"

@interface QueryParesrTestCase : MISBaseTestCase
@property (nonatomic, retain) MISQueryAssembler *assembler;
@property (nonatomic, retain) MISQueryParser *parser;
@end

@implementation QueryParesrTestCase

- (void)setUp {
    [super setUp];

    self.assembler = [[[MISQueryAssembler alloc] init] autorelease];
    
    _assembler.query = [[[MISQuery alloc] init] autorelease];

    self.parser = [[[MISQueryParser alloc] initWithDelegate:_assembler] autorelease];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFooEqBar {
    NSString *queryStr = @"foo == 'bar'";
    
    NSError *err = nil;
    MISQuery *q = [_parser parseString:queryStr error:&err];
    TDNotNil(q);
    
    MISCriteria *crit0 = q.criteria[0];
    TDEquals(MISCriteriaTypeAnd, crit0.type);
    TDEquals(MISCriteriaOperatorEqualTo, crit0.op);
    TDEqualObjects(@"foo", crit0.lhs);
    TDEqualObjects(@"bar", crit0.rhs);
}


- (void)testFooNeBarAndBazEqBat {
    NSString *queryStr = @"foo != 'bar' AND baz == 'bat'";
    
    NSError *err = nil;
    MISQuery *q = [_parser parseString:queryStr error:&err];
    TDNotNil(q);
    
    MISCriteria *crit0 = q.criteria[0];
    TDEquals(MISCriteriaTypeAnd, crit0.type);
    TDEquals(MISCriteriaOperatorNotEqualTo, crit0.op);
    TDEqualObjects(@"foo", crit0.lhs);
    TDEqualObjects(@"bar", crit0.rhs);

    MISCriteria *crit1 = q.criteria[1];
    TDEquals(MISCriteriaTypeAnd, crit1.type);
    TDEquals(MISCriteriaOperatorEqualTo, crit1.op);
    TDEqualObjects(@"baz", crit1.lhs);
    TDEqualObjects(@"bat", crit1.rhs);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end

//
//  QueryParesrTestCase.m
//  MakeItSoTests
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISBaseTest.h"

#import "MISQueryParser.h"
#import "MISQueryAssembler.h"
#import "MISQuery.h"
#import "MISCriteria.h"

@interface QueryParesrTestCase : MISBaseTest
@property (nonatomic, retain) MISQueryAssembler *assembler;
@property (nonatomic, retain) MISQueryParser *parser;
@end

@implementation QueryParesrTestCase

- (void)setUp {
    [super setUp];

    self.assembler = [[[MISQueryAssembler alloc] init] autorelease];
    self.parser = [[[MISQueryParser alloc] initWithDelegate:_assembler] autorelease];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSString *queryStr = @"foo == 'bar'";
    
    NSError *err = nil;
    MISQuery *q = [_parser parseString:queryStr error:&err];
    TDNotNil(q);
    
//    MISCriteria *crit0 = q.criteria[0];
//    TDEquals(MISCriteriaTypeAnd, crit0.type);
//    TDEquals(MISCriteriaOperatorEqualTo, crit0.op);
//    TDEqualObjects(@"foo", crit0.lhs);
//    TDEqualObjects(@"'bar'", crit0.rhs);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//
//  MISTestCase.m
//  MakeItSoTests
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISBaseTestCase.h"
#import "MISKeyGenerator.h"
#import <fmdb/FMDatabase.h>

@interface MISKeyGenerator ()
- (instancetype)initWithDatabase:(FMDatabase *)db keyName:(NSString *)name incrementBy:(NSUInteger)inc;
@end

@interface MISKeyGeneratorTestCase : MISBaseTestCase
@property (nonatomic, retain) MISKeyGenerator *generator;
@end

@implementation MISKeyGeneratorTestCase

- (void)dealloc {
    self.generator = nil;
    [super dealloc];
}


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    self.generator = nil;
    [super tearDown];
}

- (void)testIncremembyBy5 {
    id mockDB = [OCMockObject mockForClass:[FMDatabase class]];
    
    self.generator = [[[MISKeyGenerator alloc] initWithDatabase:mockDB keyName:@"name" incrementBy:5] autorelease];
    
    for (NSUInteger i = 1; i < 247; ++i) {
        TDEqualObjects(@(i), [self.generator nextKey]);
    }
}

- (void)testIncremembyBy1 {
    id mockDB = [OCMockObject mockForClass:[FMDatabase class]];
    
    self.generator = [[[MISKeyGenerator alloc] initWithDatabase:mockDB keyName:@"name" incrementBy:1] autorelease];
    
    for (NSUInteger i = 1; i < 102; ++i) {
        TDEqualObjects(@(i), [self.generator nextKey]);
    }
}

//- (void)testIncremembyBy0 {
//    id mockDB = [OCMockObject mockForClass:[FMDatabase class]];
//    
//    self.generator = [[[MISKeyGenerator alloc] initWithDatabase:mockDB keyName:@"name" incrementBy:0] autorelease];
//    XCTAssertThrows([self.generator nextKey]);
//    XCTFail(@"should not reach");
//}

@end

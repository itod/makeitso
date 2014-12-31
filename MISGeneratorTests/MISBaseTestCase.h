//
//  MISBaseTestCase.h
//  MakeItSoTests
//
//  Created by Todd Ditchendorf on 12/27/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MakeItSoTests.h"

@interface MISBaseTestCase : XCTestCase
@property (nonatomic, retain) OCMockObject *mock;
@end

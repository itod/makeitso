//
//  MISBaseTest.m
//  MakeItSoTests
//
//  Created by Todd Ditchendorf on 12/26/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISBaseTest.h"

@implementation MISBaseTest

- (void)dealloc {
    self.mock = nil;
    [super dealloc];
}

@end

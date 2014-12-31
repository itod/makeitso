//
//  MISBaseTestCase.m
//  MakeItSoTests
//
//  Created by Todd Ditchendorf on 12/26/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISBaseTestCase.h"

@implementation MISBaseTestCase

- (void)dealloc {
    self.mock = nil;
    [super dealloc];
}

@end

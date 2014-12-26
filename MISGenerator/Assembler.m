//
//  Assembler.m
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/6/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "Assembler.h"

@implementation Assembler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.classes = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.classes = nil;
    [super dealloc];
}

@end

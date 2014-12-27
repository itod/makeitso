//
//  Player.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/27/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "Player.h"

@implementation Player

- (void)dealloc {
    self.firstName = nil;
    self.lastName = nil;
    [super dealloc];
}

@end

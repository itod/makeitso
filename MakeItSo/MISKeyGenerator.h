//
//  MISKeyGenerator.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/30/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface MISKeyGenerator : NSObject

+ (instancetype)instance;

- (NSNumber *)nextKey;
@end

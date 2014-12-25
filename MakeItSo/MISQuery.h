//
//  MISQuery.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MISCriteria;

@interface MISQuery : NSObject

+ (instancetype)queryWithClass:(Class)cls;
- (instancetype)initWithClass:(Class)cls;

- (void)addCriteria:(MISCriteria *)crit;

@property (nonatomic, copy, readonly) NSArray *criteria;
@end

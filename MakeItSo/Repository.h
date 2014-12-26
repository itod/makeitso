//
//  Repository.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DomainObject;

@interface Repository : NSObject
- (DomainObject *)find:(NSNumber *)objID;
- (NSSet *)findAll:(NSString *)queryStr;
@end

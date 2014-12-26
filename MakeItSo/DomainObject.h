//
//  DomainObject.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DomainObject : NSObject

@property (nonatomic, retain, readonly) NSNumber *objectID;

// Protected
- (void)markPristine;
- (void)markClean;
- (void)markDirty;
- (void)markRemoved;
@end

//
//  DomainObject.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MIS_ONE_TO_ONE
#define MIS_ONE_TO_MANY
#define MIS_MANY_TO_MANY

@interface DomainObject : NSObject

+ (NSString *)collectionName;

@property (nonatomic, retain, readonly) NSNumber *objectID;

// Protected
- (void)markPristine;
- (void)markClean;
- (void)markDirty;
- (void)markRemoved;
@end

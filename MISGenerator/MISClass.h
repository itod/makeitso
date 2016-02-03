//
//  MISClass.h
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MISField;

@interface MISClass : NSObject
@property (nonatomic, copy) NSString *name;

- (void)addField:(MISField *)attr;
- (void)addRelationshipClassName:(NSString *)str;

@property (nonatomic, retain, readonly) NSArray *fields;
@property (nonatomic, retain, readonly) NSSet *relationshipClassNames;
@end

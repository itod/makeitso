//
//  MISField.h
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MISField : NSObject
@property (nonatomic, copy) NSString *sourceString;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) BOOL isPrimaryKey;
@property (nonatomic, assign) BOOL isForeignKey;
@end

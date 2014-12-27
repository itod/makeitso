//
//  MISGenerator.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/26/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MISGenerator;

@protocol MISGeneratorDelegate <NSObject>
- (void)generator:(MISGenerator *)gen didFail:(NSError *)err;
- (void)generator:(MISGenerator *)gen didSucceed:(NSString *)displayDirPath;
@end

@interface MISGenerator : NSObject

- (instancetype)initWithDelegate:(id <MISGeneratorDelegate>)d;

- (void)execute:(NSDictionary *)args;

@property (nonatomic, assign) id <MISGeneratorDelegate>delegate; // weakfref
@end

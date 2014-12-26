//
//  FilePreviewItem.h
//  Pathological
//
//  Created by Todd Ditchendorf on 6/23/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface FilePreviewItem : NSObject <QLPreviewItem>
+ (instancetype)previewItemWithDictionary:(NSDictionary *)d row:(NSInteger)row;

- (instancetype)initWithDictionary:(NSDictionary *)d row:(NSInteger)row;

@property (nonatomic, assign) NSInteger row;
@end

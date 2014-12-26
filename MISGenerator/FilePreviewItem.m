//
//  FilePreviewItem.m
//  Pathological
//
//  Created by Todd Ditchendorf on 6/23/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "FilePreviewItem.h"

@interface FilePreviewItem ()
@property (nonatomic, retain) NSDictionary *dictionary;
@end

@implementation FilePreviewItem

+ (instancetype)previewItemWithDictionary:(NSDictionary *)d row:(NSInteger)row {
    return [[[self alloc] initWithDictionary:d row:row] autorelease];
}


- (instancetype)initWithDictionary:(NSDictionary *)d row:(NSInteger)row {
    self = [super init];
    if (self) {
        self.dictionary = d;
        self.row = row;
    }
    return self;
}


- (void)dealloc {
    self.dictionary = nil;
    [super dealloc];
}


- (NSString *)previewItemTitle {
    return [_dictionary[@"filePath"] lastPathComponent];
}


//- (id)previewItemDisplayState {
//    
//}


- (NSURL *)previewItemURL {
    NSString *absPath = _dictionary[@"filePath"];
    NSURL *furl = [NSURL fileURLWithPath:absPath];
    return furl;
}

@end

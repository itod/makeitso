//
//  TDHintButton.h
//  TDAppKit
//
//  Created by Todd Ditchendorf on 11/11/10.
//  Copyright 2010 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TDHintButton : NSButton

- (NSRect)hintTextRectForBounds:(NSRect)bounds;

@property (nonatomic, copy) NSString *hintText;
@property (nonatomic, assign) CGFloat hintTextOffsetY;
@end

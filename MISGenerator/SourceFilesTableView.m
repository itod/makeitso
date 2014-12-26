//
//  SourceFilesTableView.m
//  Editor
//
//  Created by Todd Ditchendorf on 12/7/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "SourceFilesTableView.h"
#import <TDAppKit/TDUtils.h>

@implementation SourceFilesTableView

- (void)mouseDown:(NSEvent *)evt {
    [super mouseDown:evt];
    
    if (0 != ([evt modifierFlags] & NSControlKeyMask)) {
        [self rightMouseDown:evt];
        return;
    }
    
    CGPoint locInWin = [evt locationInWindow];
    
    TDPerformOnMainThreadAfterDelay(0.0, ^{
        CGPoint p = [self convertPoint:locInWin fromView:nil];
        NSInteger row = [self rowAtPoint:p];
        NSInteger lastRow = [self numberOfRows] - 1;
        if (row > -1 && row <= lastRow) {
            TDAssert(self.delegate && [self.delegate conformsToProtocol:@protocol(SourceFilesTableViewDelegate)]);
            id <SourceFilesTableViewDelegate>d = (id)self.delegate;
            [d resultsTableView:self didReceiveClickOnRow:row];
        }
    });
}


- (void)rightMouseDown:(NSEvent *)evt {
    [super rightMouseDown:evt];
    
    CGPoint locInWin = [evt locationInWindow];
    
    TDPerformOnMainThreadAfterDelay(0.0, ^{
        CGPoint p = [self convertPoint:locInWin fromView:nil];
        NSInteger row = [self rowAtPoint:p];
        NSInteger lastRow = [self numberOfRows] - 1;
        if (row > -1 && row <= lastRow) {
            TDAssert(self.delegate && [self.delegate conformsToProtocol:@protocol(SourceFilesTableViewDelegate)]);
            id <SourceFilesTableViewDelegate>d = (id)self.delegate;
            [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:YES];
            [d resultsTableView:self didReceiveRightClickOnRow:row];
        }
    });
}


- (void)keyUp:(NSEvent *)evt {
    [super keyUp:evt];

#define SPACE 49
    
    if (SPACE == [evt keyCode]) {
        id <SourceFilesTableViewDelegate>d = (id)self.delegate;
        [d resultsTableViewDidSpacebar:self];
    }
}


- (void)cancelOperation:(id)sender {
    id <SourceFilesTableViewDelegate>d = (id)self.delegate;
    [d resultsTableViewDidEscape:self];
}


//- (void)editColumn:(NSInteger)column row:(NSInteger)row withEvent:(NSEvent *)evt select:(BOOL)select {
//    [super editColumn:column row:row withEvent:evt select:select];
//}
//
//
//- (void)highlightSelectionInClipRect:(NSRect)clipRect {
//    // this method is asking us to draw the hightlights for
//    // all of the selected rows that are visible inside theClipRect
//    
//    // 1. get the range of row indexes that are currently visible
//    // 2. get a list of selected rows
//    // 3. iterate over the visible rows and if their index is selected
//    // 4. draw our custom highlight in the rect of that row.
//    
//    NSRange visRowRange = [self rowsInRect:clipRect];
//    NSIndexSet *selRowIndexes = [self selectedRowIndexes];
//    NSInteger lastVisRow = NSMaxRange(visRowRange);
//    NSColor *color = nil;
//    
//    // if the view is focused, use highlight color, otherwise use the out-of-focus highlight color
//    if ([[self window] isKeyWindow]) {
//        color = _selectionColor;
//    } else {
//        color = [_selectionColor colorWithAlphaComponent:0.7];
//    }
//    
//    TDAssert(color);
//    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
//    
//    // draw highlight for the visible, selected rows
//    for (NSInteger row = visRowRange.location; row < lastVisRow; row++) {
//        
//        if ([selRowIndexes containsIndex:row]) {
//            
//            NSRect rowRect = NSInsetRect([self rectOfRow:row], 0.0, 0.0);
//            
//            [color setFill];
//            CGContextFillRect(ctx, rowRect);
//        }
//    }
//}

@end

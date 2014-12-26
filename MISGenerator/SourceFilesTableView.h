//
//  SourceFilesTableView.h
//  Editor
//
//  Created by Todd Ditchendorf on 12/7/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// this supports clicking on an already selected row to re-highlight
@protocol SourceFilesTableViewDelegate <NSTableViewDelegate>
- (void)resultsTableView:(NSTableView *)tv didReceiveClickOnRow:(NSInteger)row;
- (void)resultsTableView:(NSTableView *)tv didReceiveRightClickOnRow:(NSInteger)row;
- (void)resultsTableViewDidSpacebar:(NSTableView *)tv;
- (void)resultsTableViewDidEscape:(NSTableView *)tv;

@optional
- (void)resultsTableView:(NSTableView *)tv didReceiveRightClickOnHeaderColumnIndex:(NSInteger)colIdx;
@end

@interface SourceFilesTableView : NSTableView

@property (nonatomic, retain) NSColor *selectionColor;
@end

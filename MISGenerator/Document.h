//
//  Document.h
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/26/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>   // Quartz framework provides the QLPreviewPanel public API
#import "SourceFilesTableView.h"

@class TDDropTargetView;
@class TDColorView;

@interface Document : NSDocument <NSTableViewDataSource, NSTableViewDelegate, SourceFilesTableViewDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate>

- (IBAction)browse:(id)sender;
- (IBAction)parse:(id)sender;
- (IBAction)revealSelectedFilePathsInFinder:(id)sender;
- (IBAction)togglePreviewPanel:(id)sender;

@property (nonatomic, retain) IBOutlet TDDropTargetView *dropTargetView;
@property (nonatomic, retain) IBOutlet NSView *tableContainerView;
@property (nonatomic, retain) IBOutlet NSTableView *tableView;
@property (nonatomic, retain) IBOutlet TDColorView *topHorizontalLine;
@property (nonatomic, retain) IBOutlet TDColorView *botHorizontalLine;

@property (nonatomic, retain) IBOutlet NSArrayController *fileArrayController;
@property (nonatomic, retain) NSMutableArray *files;
@end


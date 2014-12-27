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
#import "MISGenerator.h"

@class TDDropTargetView;
@class TDColorView;

@interface Document : NSDocument <NSTableViewDataSource, NSTableViewDelegate, SourceFilesTableViewDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate, MISGeneratorDelegate>

- (IBAction)browseForHeaders:(id)sender;
- (IBAction)generate:(id)sender;
- (IBAction)revealSelectedFilePathsInFinder:(id)sender;
- (IBAction)togglePreviewPanel:(id)sender;

@property (nonatomic, retain) IBOutlet TDDropTargetView *dropTargetView;
@property (nonatomic, retain) IBOutlet NSView *tableContainerView;
@property (nonatomic, retain) IBOutlet NSTableView *tableView;
@property (nonatomic, retain) IBOutlet TDColorView *topHorizontalLine;
@property (nonatomic, retain) IBOutlet TDColorView *botHorizontalLine;

@property (nonatomic, retain) IBOutlet NSArrayController *headerFilesArrayController;
@property (nonatomic, retain) NSMutableArray *headerFiles;

@property (nonatomic, assign) BOOL deleteExisting;
@property (nonatomic, copy) NSString *databaseFilename;
@property (nonatomic, copy) NSString *databaseDirPath;
@property (nonatomic, copy) NSString *outputSourceDirPath;

@property (nonatomic, assign) BOOL busy;
@property (nonatomic, copy) NSString *statusText;
@end
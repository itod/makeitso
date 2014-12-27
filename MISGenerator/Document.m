//
//  Document.m
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/26/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "Document.h"
#import "FilePreviewItem.h"

#import <TDAppKit/TDUtils.h>
#import <TDAppKit/TDColorView.h>
#import <TDAppKit/TDDropTargetView.h>
#import <TDAppKit/TDHintButton.h>

#import <PEGKit/PEGKit.h>
#import <TDTemplateEngine/TDTemplateEngine.h>

#define ICON_KEY @"iconImage"
#define PATH_KEY @"filePath"

@interface Document ()
@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    self.dropTargetView = nil;
    self.tableContainerView = nil;
    self.tableView = nil;
    self.topHorizontalLine = nil;
    self.botHorizontalLine = nil;
    
    self.headerFilesArrayController = nil;
    self.headerFiles = nil;
    
    self.databaseFilename = nil;
    self.databaseDirPath = nil;
    self.outputSourceDirPath = nil;
    
    self.statusText = nil;

    [super dealloc];
}


#pragma mark -
#pragma mark NSDocument

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];

    TDAssert(_tableView);
    TDAssert(_tableView.delegate == self);
    TDAssert(_tableView.dataSource == self);
    
    TDAssert(_tableView);
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(revealSelectedFilePathsInFinder:)];
    
    TDAssert(_dropTargetView);
    TDAssert(_dropTargetView.hintButton);
    _dropTargetView.borderMarginSize = CGSizeMake(20.0, 20.0);
    _dropTargetView.buttonMarginSize = CGSizeMake(40.0, 40.0);
    [_dropTargetView.hintButton setTarget:self];
    [_dropTargetView.hintButton setAction:@selector(browseForHeaders:)];
    [_dropTargetView.hintButton setHintText:NSLocalizedString(@"Add Objective-C Headers", @"")];
    [_dropTargetView registerForDraggedTypes:@[NSFilenamesPboardType]];
    [_dropTargetView setColor:[NSColor windowBackgroundColor]];

    NSColor *borderColor = [NSColor colorWithDeviceWhite:0.67 alpha:1.0];
    
    TDAssert(_topHorizontalLine);
    TDAssert(_botHorizontalLine);
    _topHorizontalLine.color = borderColor;
    _botHorizontalLine.color = borderColor;
    
    if ([_headerFiles count]) {
        [self hideDropTargetView];
    }
}


+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSString *)windowNibName {
    return @"Document";
}


- (NSWindow *)window {
    return [self.windowControllers[0] window];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    
    NSMutableDictionary *plist = [NSMutableDictionary dictionary];
    
    plist[KEY_DELETE_EXISTING] = @(_deleteExisting);
    if (_databaseFilename) plist[KEY_DB_FILENAME] = _databaseFilename;
    if (_databaseDirPath) plist[KEY_DB_DIR_PATH] = _databaseDirPath;
    if (_outputSourceDirPath) plist[KEY_OUTPUT_SRC_DIR_PATH] = _outputSourceDirPath;

    plist[KEY_HEADER_FILE_PATHS] = [self headerFilePaths];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:plist];
    return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    
    NSDictionary *plist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.deleteExisting = [plist[KEY_DELETE_EXISTING] boolValue];
    self.databaseFilename = plist[KEY_DB_FILENAME];
    self.databaseDirPath = plist[KEY_DB_DIR_PATH];
    self.outputSourceDirPath = plist[KEY_OUTPUT_SRC_DIR_PATH];
    
    NSArray *headerFilePaths = plist[KEY_HEADER_FILE_PATHS];
    self.headerFiles = [self headerFilesFromHeaderFilePaths:headerFilePaths];
    
    return YES;
}


- (NSMutableArray *)headerFilesFromHeaderFilePaths:(NSArray *)inFilePaths {
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSString *path in inFilePaths) {
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
        if (!icon) {
            icon = [[NSWorkspace sharedWorkspace] iconForFileType:@"txt"];
        }
        
        TDAssert(icon);
        TDAssert([path length]);
        NSMutableDictionary *item = [[@{ICON_KEY: icon, PATH_KEY: path} mutableCopy] autorelease];
        [items addObject:item];
    }
    
    return items;
}


- (NSArray *)headerFilePaths {
    NSMutableArray *headerFilePaths = [NSMutableArray arrayWithCapacity:[_headerFiles count]];
    for (NSDictionary *d in _headerFiles) {
        NSString *headerFilePath = d[PATH_KEY];
        [headerFilePaths addObject:headerFilePath];
    }
    return headerFilePaths;
}


#pragma mark -
#pragma mark Actions

- (IBAction)browseForDatabase:(id)sender {
    TDAssertMainThread();
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (NSOKButton == result) {
            
            NSURL *furl = [panel URL];
            self.databaseDirPath = [furl relativePath];
        }
    }];
}


- (IBAction)browseForOutputSource:(id)sender {
    TDAssertMainThread();
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (NSOKButton == result) {
            
            NSURL *furl = [panel URL];
            self.outputSourceDirPath = [furl relativePath];
        }
    }];
}


- (IBAction)browseForHeaders:(id)sender {
    TDAssertMainThread();
    
    NSArray *exts = self.allowedHeaderFileExtensions;
    TDAssert([exts count]);
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setAllowedFileTypes:exts];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (NSOKButton == result) {
            
            NSArray *furls = [panel URLs];
            NSMutableArray *paths = [NSMutableArray arrayWithCapacity:[furls count]];
            
            for (NSURL *furl in furls) {
                NSString *path = [furl relativePath];
                if (path) [paths addObject:path];
            }
            
            [self handleAddedFilePaths:paths];
        }
    }];
}


- (IBAction)generate:(id)sender {
    TDAssertMainThread();
    
    self.statusText = nil;
    
    if (![_databaseFilename length] || ![_databaseDirPath length] || ![_outputSourceDirPath length] || ![_headerFiles count]) {
        NSBeep();
        return;
    }
    
    self.busy = YES;

    MISGenerator *gen = [[[MISGenerator alloc] initWithDelegate:self] autorelease];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:4];
    
    //args[KEY_PROJ_NAME] = [[[self window] title] stringByDeletingPathExtension];
    args[KEY_DELETE_EXISTING] = @(_deleteExisting);
    args[KEY_DB_FILENAME] = [[_databaseFilename copy] autorelease];
    args[KEY_DB_DIR_PATH] = [[_databaseDirPath copy] autorelease];
    args[KEY_OUTPUT_SRC_DIR_PATH] = [[_outputSourceDirPath copy] autorelease];
    args[KEY_HEADER_FILE_PATHS] = [[[self headerFilePaths] copy] autorelease];
    
    [gen execute:args];
}


- (IBAction)copyFilePaths:(id)sender {
    TDAssertMainThread();
    NSArray *items = [_headerFilesArrayController selectedObjects];
    
    NSUInteger c = [items count];
    TDAssert(NSNotFound != c);
    if (c == 0) return;
    
    NSUInteger i = 0;
    
    NSMutableString *buf = [NSMutableString string];
    for (NSDictionary *item in items) {
        NSString *path = item[PATH_KEY];
        TDAssert([path length]);
        BOOL isLast = i == c - 1;
        [buf appendFormat:@"%@%@", path, isLast ? @"" : @"\n"];
        ++i;
    }
    
    TDAssert([buf length]);
    
    NSPasteboard *pboard = [NSPasteboard generalPasteboard];
    [pboard declareTypes:@[NSStringPboardType] owner:self];
    [pboard addTypes:@[NSStringPboardType] owner:self];
    [pboard setString:buf forType:NSStringPboardType];
}


- (IBAction)revealSelectedFilePathsInFinder:(id)sender {
    TDAssertMainThread();
    NSArray *items = [_headerFilesArrayController selectedObjects];
    [self revealFilePathsInFinder:items];
}


- (IBAction)filePathTableViewDoubleClick:(id)sender {
    TDAssertMainThread();
    TDAssert(_headerFilesArrayController);
    
    NSInteger row = [_headerFilesArrayController selectionIndex];
    TDAssert(row > -1);
    TDAssert(row < [[_headerFilesArrayController arrangedObjects] count]);
    
    NSString *path = [_headerFilesArrayController arrangedObjects][row];
    TDAssert([path length]);
    
    [self revealFilePathsInFinder:@[path]];
}


- (IBAction)togglePreviewPanel:(id)sender {
    TDAssertMainThread();
    
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    } else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }
}


#pragma mark -
#pragma mark NSMenuValidation

- (BOOL)validateMenuItem:(NSMenuItem *)item {
    BOOL enabled = YES;
    
    SEL action = [item action];
    
    if (action == @selector(togglePreviewPanel:)) {
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
            [item setTitle:NSLocalizedString(@"Close Quick Look panel", @"")];
            enabled = YES;
        } else {
            TDAssert(_headerFilesArrayController);
            NSUInteger c = [[_headerFilesArrayController arrangedObjects] count];
            NSString *title = nil;
            
            switch (c) {
                case 0:
                    enabled = NO;
                    title = NSLocalizedString(@"Open Quick Look panel", @"");
                    break;
                case 1:
                    enabled = YES;
                    NSString *filename = [_headerFilesArrayController.selectedObjects[0][PATH_KEY] lastPathComponent];
                    title = [NSString stringWithFormat:NSLocalizedString(@"Quick Look %@", @""), filename];
                    break;
                default:
                    enabled = YES;
                    title = [NSString stringWithFormat:NSLocalizedString(@"Quick Look %lu items", @""), c];
                    break;
            }
            [item setTitle:title];
        }
    }
    
    return enabled;
}


#pragma mark -
#pragma mark QLPreviewPanelDataSource

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
    return YES;
}


- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
    TDAssertMainThread();
    
    panel.dataSource = self;
    panel.delegate = self;
    
    TDAssert(_tableView);
    NSInteger row = [[_tableView selectedRowIndexes] firstIndex];
    [panel setCurrentPreviewItemIndex:row];
}


- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
    
}


- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    NSUInteger c = [[_headerFilesArrayController arrangedObjects] count];
    return c;
}


- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)i {
    TDAssertMainThread();
    TDAssert(_headerFilesArrayController);
    
    FilePreviewItem *result = nil;
    
    NSArray *objs = [_headerFilesArrayController arrangedObjects];
    NSUInteger c = [objs count];
    
    if (i > -1 && i < c) {
        NSDictionary *d = objs[i];
        
        result = [FilePreviewItem previewItemWithDictionary:d row:i];
        
        NSTableView *tv = _tableView;
        NSInteger row = panel.currentPreviewItemIndex;
        
        [tv selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        NSRect vizRect = [tv visibleRect];
        NSRect rowRect = [tv rectOfRow:i];
        rowRect.size.width = 1.0;
        if (!NSContainsRect(vizRect, rowRect)) {
            [tv scrollRowToVisible:row];
        }
    } else {
        TDAssert(0);
    }
    
    return result;
}


#pragma mark -
#pragma mark QLPreviewPanelDelegate

- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
    TDAssertMainThread();
    TDAssert(_headerFilesArrayController);
    
    FilePreviewItem *previewItem = (FilePreviewItem *)item;
    NSInteger row = previewItem.row;
    NSRect frameInWin = [_tableView convertRect:[_tableView rectOfRow:row] toView:nil];
    frameInWin.size.width = [[_tableView enclosingScrollView] frame].size.width;
    NSRect frameInScreen = [[self window] convertRectToScreen:frameInWin];
    return frameInScreen;
}


// must manually handle up/down arrow keys. just make behavior same as left/right keys
- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)evt {
#define UP_ARROW 126
#define DOWN_ARROW 125
    BOOL handled = NO;
    BOOL isKeyDown = (NSKeyDown == [evt type]);
    
    if (isKeyDown) {
        NSInteger keyCode = [evt keyCode];
        
        if (UP_ARROW == keyCode || DOWN_ARROW == keyCode) {
            handled = YES;
            NSUInteger c = [self numberOfPreviewItemsInPreviewPanel:panel];
            NSInteger row = panel.currentPreviewItemIndex;
            
            if (UP_ARROW == keyCode) {
                row = (0 == row) ? c - 1 : row - 1;
            } else if (DOWN_ARROW == keyCode) {
                row = (row + 1) % c;
            }
            panel.currentPreviewItemIndex = row;
        }
    }
    
    return handled;
}


#pragma mark -
#pragma mark Private

- (NSArray *)allowedHeaderFileExtensions {
    TDAssertMainThread();
    return @[@"h"];
}


- (void)handleAddedFilePaths:(NSArray *)filePaths {
    TDAssertMainThread();
    
    NSArray *exts = self.allowedHeaderFileExtensions;
    TDAssert([exts count]);
    
    if ([filePaths count]) {
        NSMutableArray *filteredFilePaths = [NSMutableArray arrayWithCapacity:[filePaths count]];
        
        for (NSString *filePath in filePaths) {
            if ([exts containsObject:[filePath pathExtension]]) {
                [filteredFilePaths addObject:filePath];
            }
        }
        
        if (![filteredFilePaths count]) {
            NSBeep();
            return;
        }
        
        NSMutableArray *newFiles = [NSMutableArray arrayWithArray:_headerFiles];
        [newFiles addObjectsFromArray:[self headerFilesFromHeaderFilePaths:filteredFilePaths]];
        self.headerFiles = newFiles;
        
        [self hideDropTargetView];
    }
}


- (void)hideDropTargetView {
    TDAssertMainThread();
    TDAssert(_dropTargetView);
    TDAssert(_tableContainerView);
    
    // hide drop target, show table
    [_dropTargetView setHidden:YES];
    [_tableContainerView setHidden:NO];
}


- (void)presentParsingError:(NSError *)err {
    TDAssertMainThread();
    
    NSString *title = nil;
    if ([PEGKitErrorDomain isEqualToString:[err domain]]) {
        title = NSLocalizedString(@"A source header parsing error occured.", @"");
    } else if ([TDTemplateEngineErrorDomain isEqualToString:[err domain]]) {
        title = NSLocalizedString(@"A template rendering error occured.", @"");
    } else if ([@"FMDatabase" isEqualToString:[err domain]]) {
        title = NSLocalizedString(@"A database SQL error occured.", @"");
    } else {
        title = NSLocalizedString(@"A file I/O error occured.", @"");
    }
    
    NSString *reason = [err localizedDescription];
    NSString *desc = [err localizedFailureReason];
    
    NSString *defaultBtn = NSLocalizedString(@"OK", @"");
    NSString *altBtn = nil;
    NSString *otherBtn = nil;
    
    NSRunAlertPanel(title, @"%@\n\n%@", defaultBtn, altBtn, otherBtn, reason, desc);
}


- (void)revealFilePathsInFinder:(NSArray *)items {
    TDAssertMainThread();
    
    NSUInteger c = [items count];
    TDAssert(NSNotFound != c);
    if (c == 0) return;
    
    [self doRevealFilePathsInFinder:items];
}


- (void)doRevealFilePathsInFinder:(NSArray *)items {
    NSUInteger c = [items count];
    TDAssert(c > 0);
    
    NSMutableArray *furls = [NSMutableArray arrayWithCapacity:c];
    for (NSDictionary *item in items) {
        NSString *path = item[PATH_KEY];
        if ([path length]) {
            NSURL *furl = [NSURL fileURLWithPath:path];
            if (furl) [furls addObject:furl];
        }
    }
    
    if ([furls count]) {
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:furls];
    } else {
        NSBeep();
    }
}


- (void)playSuccessSound {
    [self playSoundNamed:@"Hero"];
}


- (void)playErrorSound {
    [self playSoundNamed:@"Basso"];
}


- (void)playWarningSound {
    [self playSoundNamed:@"Morse"];
}


- (void)playSoundNamed:(NSString *)name {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MISSoundEffectsEnabled"]) {
        [[NSSound soundNamed:name] play];
    }
}


#pragma mark -
#pragma mark MISGeneratorDelegate

- (void)generator:(MISGenerator *)gen didFail:(NSError *)err {
    TDAssertMainThread();
    [self playErrorSound];
    [self presentParsingError:err];
    self.busy = NO;
}


- (void)generator:(MISGenerator *)gen didSucceed:(NSString *)msg databaseFilePath:(NSString *)dbFilePath {
    TDAssertMainThread();
    TDAssert([dbFilePath length]);
    [self playSuccessSound];
    self.statusText = msg;
    self.busy = NO;
    
    [[NSWorkspace sharedWorkspace] selectFile:dbFilePath inFileViewerRootedAtPath:nil];
}


#pragma mark -
#pragma mark SourceFilesTableViewDelegate

- (void)resultsTableView:(NSTableView *)tv didReceiveClickOnRow:(NSInteger)row {
    
}


- (void)resultsTableView:(NSTableView *)tv didReceiveRightClickOnRow:(NSInteger)row {
    TDAssertMainThread();
    TDAssert(row > -1);
    
    NSUInteger c = [[_headerFilesArrayController selectionIndexes] count];
    if (0 == c) {
        [_headerFilesArrayController addSelectionIndexes:[NSIndexSet indexSetWithIndex:row]];
    }
    
    if (row > -1 /*&& [[_headerFilesArrayController selectionIndexes] containsIndex:row]*/) {
        TDPerformOnMainThreadAfterDelay(0.0, ^{
            NSMenu *menu = [self resultTableContextMenu];
            [NSMenu popUpContextMenu:menu withEvent:[[self window] currentEvent] forView:tv];
        });
    }
}


- (NSMenu *)resultTableContextMenu {
    TDAssert(_headerFilesArrayController);
    
    NSMenu *menu = [[[NSMenu alloc] init] autorelease];
    
    NSUInteger c = [[_headerFilesArrayController selectionIndexes] count];
    BOOL hasMulti = c > 1;
    
    NSString *revealTitle = nil;
    if (hasMulti) {
        revealTitle = [NSString stringWithFormat:NSLocalizedString(@"Reveal %lu items in the Finder", @""), c];
    } else {
        revealTitle = NSLocalizedString(@"Reveal in Finder", @"");
    }
    
    [menu addItemWithTitle:revealTitle action:@selector(revealSelectedFilePathsInFinder:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Copy Full Path%@", @""), hasMulti ? @"s" : @""] action:@selector(copyFilePaths:) keyEquivalent:@""];
    
    return menu;
}


- (void)resultsTableViewDidEscape:(NSTableView *)tv {
    
}


- (void)resultsTableViewDidSpacebar:(NSTableView *)tv {
    [self togglePreviewPanel:tv];
}

@end

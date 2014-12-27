//
//  AppDelegate.m
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/26/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)load {
    if ([AppDelegate class] == self) {
        @autoreleasepool {
            [self setUpUserDefaults];
        }
    }
}


+ (void)setUpUserDefaults {
    NSBundle *b = [NSBundle bundleForClass:self];
    NSString *path = [b pathForResource:DEFAULT_VALUES_FILENAME ofType:@"plist"];
    NSAssert([path length], @"could not find DefaultValues.plist");
    
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSAssert([defaultValues count], @"could not load DefaultValues.plist");
    
    for (NSString *key in defaultValues) {
        if ([key hasSuffix:@"Path"]) {
            NSString *val = defaultValues[key];
            defaultValues[key] = [val stringByStandardizingPath];
        }
    }
    
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultValues];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}


- (void)dealloc {
    self.preferencesWindowController = nil;
    [super dealloc];
}


- (IBAction)showPreferences:(id)sender {
    self.preferencesWindowController = [[[PreferencesWindowController alloc] init] autorelease];
    [_preferencesWindowController showWindow:nil];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

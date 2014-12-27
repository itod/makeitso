//
//  MISGenerator.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/26/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISGenerator.h"
#import "ObjCAssembler.h"
#import "ObjCParser.h"

#import "MISClass.h"
#import "MISField.h"

#import <TDAppKit/TDUtils.h>

@interface MISGenerator ()
@property (nonatomic, retain) PKParser *parser;
@property (nonatomic, retain) Assembler *assembler;
@end

@implementation MISGenerator

- (instancetype)initWithDelegate:(id<MISGeneratorDelegate>)d {
    self = [super init];
    if (self) {
        self.delegate = d;
    }
    return self;
}


- (void)dealloc {
    self.delegate = nil;
//    self.databaseFilename = nil;
//    self.databaseDirPath = nil;
//    self.outputSourceDirPath = nil;
//    self.headerFilePaths = nil;
    
    self.parser = nil;
    self.assembler = nil;

    [super dealloc];
}


- (void)execute:(NSDictionary *)args {
    TDAssert(_delegate);
    
    TDAssert(args[KEY_DB_FILENAME]);
    TDAssert(args[KEY_DB_DIR_PATH]);
    TDAssert(args[KEY_OUTPUT_SRC_DIR_PATH]);
    TDAssert(args[KEY_HEADER_FILE_PATHS]);
    
    TDPerformOnBackgroundThread(^{
        [self parseHeaderFiles:args];
    });
}


- (void)failWithMessage:(NSString *)msg {
    TDAssertNotMainThread();
    TDPerformOnMainThread(^{
        
    });
}


- (void)succeedWithMessage:(NSString *)msg {
    TDAssertNotMainThread();
    TDPerformOnMainThread(^{
        
    });
}


- (void)parseHeaderFiles:(NSDictionary *)args {
    TDAssertNotMainThread();
    NSMutableArray *classes = [NSMutableArray array];
    
    NSArray *headerFilePaths = args[KEY_HEADER_FILE_PATHS];
    TDAssert([headerFilePaths count]);
    for (NSString *filePath in headerFilePaths) {
        if (![filePath length]) {
            TDAssert(0);
            continue;
        }
        
        NSError *err = nil;
        NSString *source = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
        if (!source) {
            if (err) NSLog(@"%@", err);
            continue;
        }
        
        err = nil;
        NSArray *newClasses = [self parseSourceCode:source error:&err];
        [classes addObjectsFromArray:newClasses];
    }
    
    TDPerformOnMainThread(^{
        if ([classes count]) {
            
            if ([classes count]) {
                TDAssert(0); // DO SOMETHING
            } else {

            }
            
            
        } else {

        }
    });
}


- (NSArray *)parseSourceCode:(NSString *)source error:(NSError **)outErr {
    
    self.assembler = [[[ObjCAssembler alloc] init] autorelease];
    self.parser = [[[ObjCParser alloc] initWithDelegate:_assembler] autorelease];
    
    NSError *err = nil;
    id res = [[[_parser parseString:source error:&err] retain] autorelease];
    
    NSArray *classes = [[_assembler.classes copy] autorelease];
    
    self.parser = nil;
    self.assembler = nil;
    
    if (!res) {
        if (err) {
            NSLog(@"%@", err);
            if (outErr) *outErr = err;
            return nil;
        }
    }
    
    return classes;
}



@end

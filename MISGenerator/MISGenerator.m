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
#import <TDTemplateEngine/TDTemplateEngine.h>

#import <fmdb/FMDatabase.h>
#import <fmdb/FMResultSet.h>

#define EXT_SQLITE @"sqlite"

@interface MISGenerator ()

@end

@implementation MISGenerator

- (instancetype)initWithDelegate:(id <MISGeneratorDelegate>)d {
    self = [super init];
    if (self) {
        self.delegate = d;
    }
    return self;
}


- (void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}


- (void)execute:(NSDictionary *)args {
    TDAssert(_delegate);
    
    //TDAssert(args[KEY_PROJ_NAME]);
    TDAssert(args[KEY_DELETE_EXISTING]);
    TDAssert(args[KEY_DB_FILENAME]);
    TDAssert(args[KEY_DB_DIR_PATH]);
    TDAssert(args[KEY_OUTPUT_SRC_DIR_PATH]);
    TDAssert(args[KEY_HEADER_FILE_PATHS]);
    
    TDPerformOnBackgroundThread(^{
        // parse source code
        NSError *err = nil;
        NSArray *classes = [self classesForHeaderFiles:args error:&err];
        if (!classes) {
            [self failWithError:err];
            return;
        }
        
        // generate source code
        err = nil;
        if (![self generateOutputSourceForClasses:classes args:args error:&err]) {
            [self failWithError:err];
            return;
        }
        
        // generate sql
        err = nil;
        NSString *sqlFilePath = [self generateSqlForClasses:classes args:args error:&err];
        if (![sqlFilePath length]) {
            [self failWithError:err];
            return;
        }

        // create db
        err = nil;
        NSString *dbFilePath = [self createDatabaseForSqlFilePath:sqlFilePath args:args error:&err];
        if (![dbFilePath length]) {
            [self failWithError:err];
            return;
        }
        
        [self succeedWithMessage:@"Yay!" databaseFilePath:dbFilePath];
    });
}


- (void)failWithError:(NSError *)err {
    TDAssertNotMainThread();
    TDPerformOnMainThread(^{
        TDAssert(_delegate);
        [_delegate generator:self didFail:err];
    });
}


- (void)succeedWithMessage:(NSString *)msg databaseFilePath:dbFilePath {
    TDAssertNotMainThread();
    TDPerformOnMainThread(^{
        TDAssert(_delegate);
        [_delegate generator:self didSucceed:msg databaseFilePath:dbFilePath];
    });
}


- (NSArray *)classesForHeaderFiles:(NSDictionary *)args error:(NSError **)outErr {
    TDAssertNotMainThread();
    NSMutableArray *classes = [NSMutableArray array];
    
    // parse headers
    {
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
                if (outErr) *outErr = err;
                return nil;
            }
            
            ObjCAssembler *assembler = [[ObjCAssembler alloc] init]; // +1
            ObjCParser *parser = [[ObjCParser alloc] initWithDelegate:assembler]; // +1
            
            err = nil;
            [[[parser parseString:source error:&err] retain] autorelease];
            
            NSArray *newClasses = [[assembler.classes copy] autorelease];
            
            [assembler release]; // -1
            [parser release]; // -1
            
            if (![newClasses count]) {
                if (outErr) *outErr = err;
                return nil;
            }
            
            [classes addObjectsFromArray:newClasses];
        }
    }
    
    // notate foreign key fields
//    {
//        NSMutableDictionary *classTab = [NSMutableDictionary dictionary];
//        for (MISClass *cls in classes) {
//            classTab[cls.name] = cls;
//        }
//        
//        for (MISClass *cls in classes) {
//            for (MISField *field in cls.fields) {
//                MISClass *foreignClass = classTab[field.className];
//                if (foreignClass) {
//                    field.isForeignKey = YES;
//                }
//            }
//        }
//    }
    
    return classes;
}


- (BOOL)generateOutputSourceForClasses:(NSArray *)classes args:(NSDictionary *)args error:(NSError **)outErr {
    TDAssertNotMainThread();
    
    NSString *mapHeaderPath = [[NSBundle mainBundle] pathForResource:@"MapperTemplate.h" ofType:@"txt"];
    NSString *mapImplPath = [[NSBundle mainBundle] pathForResource:@"MapperTemplate.m" ofType:@"txt"];
    NSString *repoHeaderPath = [[NSBundle mainBundle] pathForResource:@"RepositoryTemplate.h" ofType:@"txt"];
    NSString *repoImplPath = [[NSBundle mainBundle] pathForResource:@"RepositoryTemplate.m" ofType:@"txt"];
    
    TDTemplateEngine *eng = [TDTemplateEngine templateEngine];
    
    // compile the template at a given file path to an AST
    NSError *err = nil;
    
    err = nil;
    TDNode *mapHeaderTree = [eng compileTemplateFile:mapHeaderPath encoding:NSUTF8StringEncoding error:&err];
    if (!mapHeaderTree) {
        if (outErr) *outErr = err;
        return NO;
    }
    err = nil;
    
    TDNode *mapImplTree = [eng compileTemplateFile:mapImplPath encoding:NSUTF8StringEncoding error:&err];
    if (!mapImplTree) {
        if (outErr) *outErr = err;
        return NO;
    }

    err = nil;
    TDNode *repoHeaderTree = [eng compileTemplateFile:repoHeaderPath encoding:NSUTF8StringEncoding error:&err];
    if (!repoHeaderTree) {
        if (outErr) *outErr = err;
        return NO;
    }
    
    err = nil;
    TDNode *repoImplTree = [eng compileTemplateFile:repoImplPath encoding:NSUTF8StringEncoding error:&err];
    if (!repoImplTree) {
        if (outErr) *outErr = err;
        return NO;
    }
    
    NSString *outputDir = args[KEY_OUTPUT_SRC_DIR_PATH];
    
    for (MISClass *cls in classes) {
        NSMutableString *selectColList = [NSMutableString string];
        NSMutableString *insertColList = [NSMutableString string];
        NSMutableString *updateColList = [NSMutableString string];
        
        NSArray *fields = cls.oneToOneFields;
        
        NSUInteger i = 0;
        NSUInteger c = [fields count];
        for (MISField *field in fields) {
            NSString *fmt = c-1 == i ? @"%@" : @"%@, ";
            [selectColList appendFormat:fmt, field.name];
            
            fmt = c-1 == i ? @"?" : @"?, ";
            [insertColList appendString:fmt];

            fmt = c-1 == i ? @"%@ = ?" : @"%@ = ?, ";
            [updateColList appendFormat:fmt, field.name];
            ++i;
        }
        
        NSMutableDictionary *vars = [NSMutableDictionary dictionary];
        vars[@"class"] = cls;
        vars[@"tableName"] = [cls.name lowercaseString];
        vars[@"selectColumnList"] = [[selectColList mutableCopy] autorelease];
        vars[@"insertColumnList"] = [[insertColList mutableCopy] autorelease];
        vars[@"updateColumnList"] = [[updateColList mutableCopy] autorelease];
        
        NSString *mapHeaderPath = [outputDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Mapper.h", cls.name]];
        NSString *mapImplPath = [outputDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Mapper.m", cls.name]];
        NSString *repoHeaderPath = [outputDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Repository.h", cls.name]];
        NSString *repoImplPath = [outputDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Repository.m", cls.name]];
        
        // provide a streaming output destination
        NSOutputStream *mapHeaderStream = [NSOutputStream outputStreamToFileAtPath:mapHeaderPath append:NO];
        NSOutputStream *mapImplStream = [NSOutputStream outputStreamToFileAtPath:mapImplPath append:NO];
        NSOutputStream *repoHeaderStream = [NSOutputStream outputStreamToFileAtPath:repoHeaderPath append:NO];
        NSOutputStream *repoImplStream = [NSOutputStream outputStreamToFileAtPath:repoImplPath append:NO];
        
        err = nil;
        if (![eng renderTemplateTree:mapHeaderTree withVariables:vars toStream:mapHeaderStream error:&err]) {
            if (outErr) *outErr = err;
            return NO;
        }
        
        err = nil;
        if (![eng renderTemplateTree:mapImplTree withVariables:vars toStream:mapImplStream error:&err]) {
            if (outErr) *outErr = err;
            return NO;
        }
        
        err = nil;
        if (![eng renderTemplateTree:repoHeaderTree withVariables:vars toStream:repoHeaderStream error:&err]) {
            if (outErr) *outErr = err;
            return NO;
        }
        
        err = nil;
        if (![eng renderTemplateTree:repoImplTree withVariables:vars toStream:repoImplStream error:&err]) {
            if (outErr) *outErr = err;
            return NO;
        }
    }
    
    return YES;
}


- (NSString *)generateSqlForClasses:(NSArray *)classes args:(NSDictionary *)args error:(NSError **)outErr {
    TDAssertNotMainThread();
    
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"sql" ofType:@"txt"];
    
    TDTemplateEngine *eng = [TDTemplateEngine templateEngine];
    
    // compile the template at a given file path to an AST
    NSError *err = nil;
    TDNode *sqlTree = [eng compileTemplateFile:templateFilePath encoding:NSUTF8StringEncoding error:&err];
    if (!sqlTree) {
        if (outErr) *outErr = err;
        return NO;
    }
    
    NSString *dbFilename = args[KEY_DB_FILENAME];
    NSString *dbDirPath = args[KEY_DB_DIR_PATH];
    
    NSMutableDictionary *vars = [NSMutableDictionary dictionary];
    vars[@"dbFilename"] = dbFilename;
    vars[@"classes"] = classes;
    
    NSString *sqlFilePath = [[dbDirPath stringByAppendingPathComponent:dbFilename] stringByAppendingPathExtension:@"sql"];
    
    // provide a streaming output destination
    NSOutputStream *sqlFileStream = [NSOutputStream outputStreamToFileAtPath:sqlFilePath append:NO];
    
    err = nil;
    if (![eng renderTemplateTree:sqlTree withVariables:vars toStream:sqlFileStream error:&err]) {
        if (outErr) *outErr = err;
        return nil;
    }

    return sqlFilePath;
}


- (NSString *)createDatabaseForSqlFilePath:(NSString *)sqlFilePath args:(NSDictionary *)args error:(NSError **)outErr {
    TDAssertNotMainThread();

    NSError *err = nil;
    NSString *sql = [NSString stringWithContentsOfFile:sqlFilePath encoding:NSUTF8StringEncoding error:&err];
    if (![sql length]) {
        if (outErr) *outErr = err;
        return NO;
    }
    
    NSString *dbFilename = args[KEY_DB_FILENAME];
    NSString *dbDirPath = args[KEY_DB_DIR_PATH];
    
    if (![[dbFilename pathExtension] isEqualToString:EXT_SQLITE]) {
        dbFilename = [dbFilename stringByAppendingPathExtension:EXT_SQLITE];
    }
    
    NSString *dbFilePath = [dbDirPath stringByAppendingPathComponent:dbFilename];
    
    if ([args[KEY_DELETE_EXISTING] boolValue]) {
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        if ([mgr fileExistsAtPath:dbFilePath]) {

            NSError *err = nil;
            NSURL *furl = [NSURL fileURLWithPath:dbFilePath];

            if (![mgr trashItemAtURL:furl resultingItemURL:nil error:&err]) {
                if (outErr) *outErr = err;
                return NO;
            }
        }
    }

    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    BOOL success = [db executeStatements:sql];
    
    if (!success) {
        if (outErr) *outErr = db.lastError;
    }
    
    [db close];
    
    return dbFilePath;
}

@end

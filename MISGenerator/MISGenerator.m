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
        NSArray *classes = [self classesForHeaderFiles:args];
        [self generateOutputSourceForClasses:classes args:args];
        
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


- (NSArray *)classesForHeaderFiles:(NSDictionary *)args {
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
    
    return classes;
}


- (void)generateOutputSourceForClasses:(NSArray *)classes args:(NSDictionary *)args {
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
    err = nil;
    TDNode *mapImplTree = [eng compileTemplateFile:mapImplPath encoding:NSUTF8StringEncoding error:&err];
    err = nil;
    TDNode *repoHeaderTree = [eng compileTemplateFile:repoHeaderPath encoding:NSUTF8StringEncoding error:&err];
    err = nil;
    TDNode *repoImplTree = [eng compileTemplateFile:repoImplPath encoding:NSUTF8StringEncoding error:&err];
    
    NSString *outputDir = args[KEY_OUTPUT_SRC_DIR_PATH];
    
    for (MISClass *cls in classes) {
        NSMutableString *colList = [NSMutableString string];
        
        NSArray *fields = cls.fields;
        
        NSUInteger i = 0;
        NSUInteger c = [fields count];
        for (MISField *field in fields) {
            NSString *fmt = c-1 == i ? @"%@ " : @"%@,";
            [colList appendFormat:fmt, field.name];
            ++i;
        }
        
        NSMutableDictionary *vars = [NSMutableDictionary dictionary];
        vars[@"class"] = cls;
        vars[@"tableName"] = [cls.name lowercaseString];
        vars[@"columnList"] = [[colList mutableCopy] autorelease];
        
        NSString *mapHeaderPath = [outputDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Mapper.h", cls.name]];
        NSString *mapImplPath = [outputDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Mapper.h", cls.name]];
        NSString *repoHeaderPath = [outputDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Repository.h", cls.name]];
        NSString *repoImplPath = [outputDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Repository.h", cls.name]];
        
        // provide a streaming output destination
        NSOutputStream *mapHeaderStream = [NSOutputStream outputStreamToFileAtPath:mapHeaderPath append:NO];
        NSOutputStream *mapImplStream = [NSOutputStream outputStreamToFileAtPath:mapImplPath append:NO];
        NSOutputStream *repoHeaderStream = [NSOutputStream outputStreamToFileAtPath:repoHeaderPath append:NO];
        NSOutputStream *repoImplStream = [NSOutputStream outputStreamToFileAtPath:repoImplPath append:NO];
        
        err = nil;
        [eng renderTemplateTree:mapHeaderTree withVariables:vars toStream:mapHeaderStream error:&err];
        err = nil;
        [eng renderTemplateTree:mapImplTree withVariables:vars toStream:mapImplStream error:&err];
        err = nil;
        [eng renderTemplateTree:repoHeaderTree withVariables:vars toStream:repoHeaderStream error:&err];
        err = nil;
        [eng renderTemplateTree:repoImplTree withVariables:vars toStream:repoImplStream error:&err];
        
    }

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

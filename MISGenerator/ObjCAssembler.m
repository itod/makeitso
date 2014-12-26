//
//  ObjCAssembler.m
//  MISGenerator
//
//  Created by Todd Ditchendorf on 12/6/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "ObjCAssembler.h"

#import "MISClass.h"
#import "MISField.h"

#import <PEGKit/PEGKit.h>

@interface ObjCAssembler ()
@property (nonatomic, retain) PKToken *atTok;
@property (nonatomic, retain) PKToken *minusTok;
@property (nonatomic, retain) PKToken *plusTok;
@property (nonatomic, retain) PKToken *openCurlyTok;
@property (nonatomic, retain) PKToken *openParenTok;
@property (nonatomic, retain) PKToken *closeParenTok;
@property (nonatomic, retain) PKToken *openSquareTok;
@property (nonatomic, retain) PKToken *closeSquareTok;
@property (nonatomic, retain) PKToken *returnTok;
@property (nonatomic, retain) PKToken *methodTok;
@property (nonatomic, retain) PKToken *paramTok;

@property (nonatomic, retain) MISField *currentField;
@property (nonatomic, retain) NSMutableString *currentNameString;

@property (nonatomic, retain) NSMutableArray *classes;
@end

@implementation ObjCAssembler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.atTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"@" doubleValue:0.0];
        self.minusTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];
        self.plusTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"+" doubleValue:0.0];
        self.openCurlyTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"{" doubleValue:0.0];
        self.openParenTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
        self.closeParenTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@")" doubleValue:0.0];
        self.openSquareTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"[" doubleValue:0.0];
        self.closeSquareTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"]" doubleValue:0.0];
        
        self.returnTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"<RETURN_TYPE>" doubleValue:0.0];
        self.methodTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"<METHOD>" doubleValue:0.0];
        self.paramTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"<PARAM>" doubleValue:0.0];
    }
    return self;
}


- (void)dealloc {
    self.atTok = nil;
    self.minusTok = nil;
    self.plusTok = nil;
    self.openCurlyTok = nil;
    self.openParenTok = nil;
    self.closeParenTok = nil;
    self.openSquareTok = nil;
    self.closeSquareTok = nil;
    self.returnTok = nil;
    self.methodTok = nil;
    self.paramTok = nil;
    self.currentField = nil;
    self.currentNameString = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PKParserDelegate


#pragma mark -
#pragma mark Classes

- (void)parser:(PKParser *)p didMatchClassDefn:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    MISClass *cls = a.target;
    TDAssert([cls isKindOfClass:[MISClass class]]);
    
    TDAssert(self.classes);
    [self.classes addObject:cls];
    
}


- (void)parser:(PKParser *)p didMatchClassDefnName:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    PKToken *tok = [a pop];
    TDAssert(tok.isWord);
    
    MISClass *cls = [[[MISClass alloc] init] autorelease];
    cls.name = tok.stringValue;
    
    a.target = cls;
}


#pragma mark -
#pragma mark Ivars

- (void)parser:(PKParser *)p didMatchScalarIvar:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    NSMutableString *srcBuf = [NSMutableString string];
    
    PKToken *nameTok = [a pop];
    TDAssertToken(nameTok);
    
    NSArray *typeToks = [a objectsAbove:_openCurlyTok];
    NSMutableString *typeBuf = [NSMutableString string];
    for (PKToken *typeTok in [typeToks reverseObjectEnumerator]) {
        TDAssertToken(typeTok);
        [typeBuf appendString:typeTok.stringValue];
        [srcBuf appendString:typeTok.stringValue];
    }
    
    [srcBuf appendString:nameTok.stringValue];
    
    MISField *attr = [[[MISField alloc] init] autorelease];
    attr.name = nameTok.stringValue;
    attr.type = [typeBuf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    attr.sourceString = [srcBuf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    MISClass *cls = a.target;
    TDAssert([cls isKindOfClass:[MISClass class]]);
    
    [cls addField:attr];
}


- (BOOL)nextNonWhitespaceToken:(PKAssembly *)a isEqual:(PKToken *)targetTok {
    NSMutableArray *toks = [NSMutableArray array];
    PKToken *nextTok = nil;
    do {
        nextTok = [a pop];
        [toks addObject:nextTok];
    } while (nextTok.isWhitespace);
    
    for (PKToken *tok in [toks reverseObjectEnumerator]) {
        [a push:tok];
    }
    
    return [nextTok isEqual:targetTok]; // TODO
}


#pragma mark -
#pragma mark Properties

- (void)parser:(PKParser *)p didMatchNonBlockPropertyType:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    self.currentField = [[[MISField alloc] init] autorelease];

    NSArray *toks = [a objectsAbove:_closeParenTok];
    
    NSMutableString *typeBuf = [NSMutableString string];
    for (PKToken *tok in [toks reverseObjectEnumerator]) {
        [a push:tok];
        [typeBuf appendString:tok.stringValue];
    }
    
    _currentField.type = [typeBuf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (void)parser:(PKParser *)p didMatchNonBlockProperty:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    MISClass *cls = a.target;
    TDAssert([cls isKindOfClass:[MISClass class]]);
    
    NSMutableArray *suffixToks = [[[a objectsAbove:_closeParenTok] mutableCopy] autorelease];

    [a pop]; // pop ')'
    [suffixToks addObject:_closeParenTok];
    
    PKToken *nameTok = [suffixToks firstObject];
    NSString *name = nameTok.stringValue;

    NSArray *prefixToks = [a objectsAbove:_atTok];
    [a pop]; // pop '@'
    
    [suffixToks addObjectsFromArray:prefixToks];
    [suffixToks addObject:_atTok];

    NSMutableString *srcBuf = [NSMutableString string];

    for (PKToken *tok in [suffixToks reverseObjectEnumerator]) {
        [srcBuf appendString:tok.stringValue];
    }
    
    TDAssert(_currentField);
    TDAssert([_currentField.type length]);
    
    _currentField.sourceString = srcBuf;
    _currentField.name = name;
    
    [cls addField:_currentField];
}


#pragma mark -
#pragma mark Blocks

- (void)parser:(PKParser *)p didMatchBlockPropertyName:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    self.currentField = [[[MISField alloc] init] autorelease];
    
    PKToken *nameTok = [a pop];
    TDAssertToken(nameTok);
    
    _currentField.name = nameTok.stringValue;
    [a push:_paramTok];
}


- (void)parser:(PKParser *)p didMatchBlockPropertyType:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    NSMutableArray *toks = [[[a objectsAbove:_atTok] mutableCopy] autorelease];
    
    // put them right back on the stack for src scan later
    for (PKToken *tok in [toks reverseObjectEnumerator]) {
        [a push:tok];
    }
    
    // drop tokens up to prop spec : `@property (copy)`
    NSUInteger i = [toks count]-1;
    for (PKToken *tok in [[[toks copy] autorelease] reverseObjectEnumerator]) {
        [toks removeObjectAtIndex:i];
        if ([tok isEqual:_closeParenTok]) {
            break;
        }
        --i;
    }
    
    // do type scan
    // now toks should be : ` void (^completionHandler)(void)`
    NSMutableString *typeBuf = [NSMutableString string];
    for (PKToken *tok in [toks reverseObjectEnumerator]) {
        if (tok == _paramTok) continue;
        [typeBuf appendString:tok.stringValue];
    }
    
    TDAssert(_currentField);
    _currentField.type = [typeBuf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (void)parser:(PKParser *)p didMatchBlockProperty:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);

    // do src scan
    TDAssert(_currentField);
    NSArray *toks = [a objectsAbove:_atTok];
    [a pop]; // pop '@'
    
    NSMutableString *srcBuf = [NSMutableString stringWithString:_atTok.stringValue];
    for (PKToken *tok in [toks reverseObjectEnumerator]) {
        if (tok == _paramTok) {
            [srcBuf appendString:_currentField.name];
        } else {
            [srcBuf appendString:tok.stringValue];
        }
    }

    _currentField.sourceString = srcBuf;

    MISClass *cls = a.target;
    TDAssert([cls isKindOfClass:[MISClass class]]);
    [cls addField:_currentField];
    
    self.currentField = nil;
}

@end

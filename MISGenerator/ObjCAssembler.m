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

@property (nonatomic, retain) MISClass *currentClass;
@property (nonatomic, retain) MISField *currentField;
@property (nonatomic, retain) NSMutableString *currentNameString;
@end

@implementation ObjCAssembler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.classes = [NSMutableArray array];
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
    self.classes = nil;
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
    self.currentClass = nil;
    self.currentField = nil;
    self.currentNameString = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Classes

- (void)parser:(PKParser *)p didMatchClassDefn:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    TDAssert(_classes);
    TDAssert(_currentClass);
    [_classes addObject:_currentClass];
    self.currentClass = nil;
}


- (void)parser:(PKParser *)p didMatchClassDefnName:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    PKToken *tok = [a pop];
    TDAssert(tok.isWord);
    
    MISClass *cls = [[[MISClass alloc] init] autorelease];
    cls.name = tok.stringValue;
    
    MISField *field = [[[MISField alloc] init] autorelease];
    field.name = @"objectID";
    field.type = @"NSNumber *";
    field.rawType = @"NSNumber";
    field.sqlType = MISFieldSqlTypeInteger;
    field.isPrimaryKey = YES;
    field.sourceString = @"@property (nonatomic, copy) NSNumber *objectID";
    
    [cls addField:field];
    
    self.currentClass = cls;
}


#pragma mark -
#pragma mark Properties

- (NSString *)rawTypeFromType:(NSString *)type {
    NSString *rawType = type;
    
    NSRange spaceRange = [type rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (spaceRange.length) {
        rawType = [type substringToIndex:spaceRange.location];
    }
    
    return rawType;
}


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
    _currentField.rawType = [self rawTypeFromType:_currentField.type];
    
    MISFieldSqlType sqlType = MISFieldSqlTypeInvalid;
    
    if ([_currentField.type hasPrefix:@"NSString"]) {
        sqlType = MISFieldSqlTypeText;
    } else if ([_currentField.type hasPrefix:@"NSNumber"]) {
        sqlType = MISFieldSqlTypeReal;
    } else if ([_currentField.type hasPrefix:@"NSDate"]) {
        sqlType = MISFieldSqlTypeDate;
    } else if ([_currentField.type hasPrefix:@"NSData"]) {
        sqlType = MISFieldSqlTypeData;
    } else if ([_currentField.type hasPrefix:@"NSNull"]) {
        sqlType = MISFieldSqlTypeNull;
    } else {
        sqlType = MISFieldSqlTypeDomainObject;
        _currentField.isForeignKey = YES;
        //[NSException raise:@"A property in class «%@» has a type that is unsupported by MakeItSo: «%@»." format:_currentClass.name, _currentField.type];
    }
    
    _currentField.sqlType = sqlType;
}


- (void)parser:(PKParser *)p didMatchNonBlockProperty:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    TDAssert(_currentClass);
    
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
    
    [_currentClass addField:_currentField];
    
    // don't set -currentField to nil here. wait for relationship
}


- (void)parser:(PKParser *)p didMatchRelationship:(PKAssembly *)a {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, a);
    
    PKToken *relTok = [a pop];
    TDAssertToken(relTok);
    
    MISFieldRelationship rel = MISFieldRelationshipOneToOne;
    
    if ([@"MIS_ONE_TO_ONE" isEqualToString:relTok.stringValue]) {
        rel = MISFieldRelationshipOneToOne;
    } else if ([@"MIS_ONE_TO_MANY" isEqualToString:relTok.stringValue]) {
        rel = MISFieldRelationshipOneToMany;
    } else if ([@"MIS_MANY_TO_MANY" isEqualToString:relTok.stringValue]) {
        rel = MISFieldRelationshipManyToMany;
    } else {
        TDAssert(0);
    }
    
    TDAssert(_currentField);
    _currentField.relationship = rel;
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

    TDAssert(_currentClass);
    [_currentClass addField:_currentField];
    
    self.currentField = nil;
}

@end

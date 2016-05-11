//
//  MISQueryAssembler.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "MISQueryAssembler.h"
#import "MISQuery.h"
#import "MISCriteria.h"

#import <PEGKit/PEGKit.h>
#import "NSString+PEGKitAdditions.h"

@implementation MISQueryAssembler

- (void)parser:(PKParser *)p didMatchEq:(PKAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [a push:@(MISCriteriaOperatorEqualTo)];
}


- (void)parser:(PKParser *)p didMatchNe:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    [a push:@(MISCriteriaOperatorNotEqualTo)];
}


- (void)parser:(PKParser *)p didMatchTrue:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    [a push:@YES];
}


- (void)parser:(PKParser *)p didMatchFalse:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    [a push:@NO];
}


- (void)parser:(PKParser *)p didMatchNum:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    PKToken *tok = [a pop];
    [a push:@(tok.doubleValue)];
}


- (void)parser:(PKParser *)p didMatchString:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    PKToken *tok = [a pop];
    [a push:[tok.stringValue stringByTrimmingQuotes]];
}


- (void)parser:(PKParser *)p didMatchKeyPath:(PKAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
//    NSArray *toks = [a objectsAbove:nil];
//    
//    NSMutableString *buf = [NSMutableString string];
//    for (PKToken *tok in [toks reverseObjectEnumerator]) {
//        [buf appendFormat:@"%@.", tok.stringValue];
//    }
//    
//    [a push:[[buf copy] autorelease]];
    
    PKToken *tok = [a pop];
    [a push:tok.stringValue];
}



- (void)parser:(PKParser *)p didMatchOperatorAtom:(PKAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    id rhs = [a pop];
    id op = [a pop];
    id lhs = [a pop];
    
    MISCriteria *crit = [[[MISCriteria alloc] initWithType:MISCriteriaTypeAnd lhs:lhs op:[op integerValue] rhs:rhs] autorelease];
    
    TDAssert(_query);
    [_query addCriteria:crit];
}


- (void)parser:(PKParser *)p didMatchQuery:(PKAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    TDAssert(_query);
    a.target = [[_query retain] autorelease];
    self.query = nil;
}

@end

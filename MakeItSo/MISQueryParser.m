#import "MISQueryParser.h"
#import <PEGKit/PEGKit.h>


@interface MISQueryParser ()

@end

@implementation MISQueryParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"query";
        self.tokenKindTab[@"true"] = @(MISQUERYPARSER_TOKEN_KIND_TRUE);
        self.tokenKindTab[@">="] = @(MISQUERYPARSER_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"&&"] = @(MISQUERYPARSER_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"LIKE"] = @(MISQUERYPARSER_TOKEN_KIND_LIKE);
        self.tokenKindTab[@"<"] = @(MISQUERYPARSER_TOKEN_KIND_LT);
        self.tokenKindTab[@"!="] = @(MISQUERYPARSER_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"AND"] = @(MISQUERYPARSER_TOKEN_KIND_AND_UPPER);
        self.tokenKindTab[@"="] = @(MISQUERYPARSER_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"ENDSWITH"] = @(MISQUERYPARSER_TOKEN_KIND_ENDSWITH);
        self.tokenKindTab[@"!"] = @(MISQUERYPARSER_TOKEN_KIND_BANG);
        self.tokenKindTab[@">"] = @(MISQUERYPARSER_TOKEN_KIND_GT);
        self.tokenKindTab[@"<="] = @(MISQUERYPARSER_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"NOT"] = @(MISQUERYPARSER_TOKEN_KIND_NOT_UPPER);
        self.tokenKindTab[@"OR"] = @(MISQUERYPARSER_TOKEN_KIND_OR_UPPER);
        self.tokenKindTab[@"false"] = @(MISQUERYPARSER_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"BEGINSWITH"] = @(MISQUERYPARSER_TOKEN_KIND_BEGINSWITH);
        self.tokenKindTab[@"<>"] = @(MISQUERYPARSER_TOKEN_KIND_NOT_EQUALS);
        self.tokenKindTab[@"CONTAINS"] = @(MISQUERYPARSER_TOKEN_KIND_CONTAINS);
        self.tokenKindTab[@"=<"] = @(MISQUERYPARSER_TOKEN_KIND_EL_SYM);
        self.tokenKindTab[@"MATCHES"] = @(MISQUERYPARSER_TOKEN_KIND_MATCHES);
        self.tokenKindTab[@"("] = @(MISQUERYPARSER_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"=="] = @(MISQUERYPARSER_TOKEN_KIND_DOUBLE_EQUALS);
        self.tokenKindTab[@")"] = @(MISQUERYPARSER_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"=>"] = @(MISQUERYPARSER_TOKEN_KIND_HASH_ROCKET);
        self.tokenKindTab[@"||"] = @(MISQUERYPARSER_TOKEN_KIND_DOUBLE_PIPE);

        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_DOUBLE_AMPERSAND] = @"&&";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_LIKE] = @"LIKE";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_AND_UPPER] = @"AND";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_ENDSWITH] = @"ENDSWITH";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_NOT_UPPER] = @"NOT";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_OR_UPPER] = @"OR";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_BEGINSWITH] = @"BEGINSWITH";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_NOT_EQUALS] = @"<>";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_CONTAINS] = @"CONTAINS";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_EL_SYM] = @"=<";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_MATCHES] = @"MATCHES";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_DOUBLE_EQUALS] = @"==";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_HASH_ROCKET] = @"=>";
        self.tokenKindNameTab[MISQUERYPARSER_TOKEN_KIND_DOUBLE_PIPE] = @"||";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
    
    [t setTokenizerState:t.symbolState from:'\\' to:'\\'];
    
    [t.symbolState add:@"=="];
    [t.symbolState add:@">="];
    [t.symbolState add:@"=>"];
    [t.symbolState add:@"<="];
    [t.symbolState add:@"=<"];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<>"];
    [t.symbolState add:@"&&"];
    [t.symbolState add:@"||"];

    }];

    [self query_]; 
    [self matchEOF:YES]; 

}

- (void)query_ {
    
    do {
        [self expr_]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchQuery:)];
}

- (void)expr_ {
    
    [self orTerm_]; 
    while ([self speculate:^{ [self orOrTerm_]; }]) {
        [self orOrTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)orOrTerm_ {
    
    [self orKeyword_]; 
    [self orTerm_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrOrTerm:)];
}

- (void)orTerm_ {
    
    [self andTerm_]; 
    while ([self speculate:^{ [self andAndTerm_]; }]) {
        [self andAndTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrTerm:)];
}

- (void)andAndTerm_ {
    
    [self andKeyword_]; 
    [self andTerm_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAndAndTerm:)];
}

- (void)andTerm_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_BANG, MISQUERYPARSER_TOKEN_KIND_NOT_UPPER, 0]) {
        [self negatedPrimaryExpr_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_FALSE, MISQUERYPARSER_TOKEN_KIND_OPEN_PAREN, MISQUERYPARSER_TOKEN_KIND_TRUE, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self primaryExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'andTerm'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndTerm:)];
}

- (void)negatedPrimaryExpr_ {
    
    [self notKeyword_]; 
    [self primaryExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchNegatedPrimaryExpr:)];
}

- (void)primaryExpr_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_FALSE, MISQUERYPARSER_TOKEN_KIND_TRUE, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self comparisonExpr_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self compoundExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)compoundExpr_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:MISQUERYPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchCompoundExpr:)];
}

- (void)comparisonExpr_ {
    
    [self atom_]; 
    while ([self speculate:^{ [self operatorAtom_]; }]) {
        [self operatorAtom_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchComparisonExpr:)];
}

- (void)operatorAtom_ {
    
    [self comparisonOperator_]; 
    [self atom_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOperatorAtom:)];
}

- (void)comparisonOperator_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_DOUBLE_EQUALS, MISQUERYPARSER_TOKEN_KIND_EQUALS, 0]) {
        [self eq_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_GT, 0]) {
        [self gt_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_LT, 0]) {
        [self lt_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_GE_SYM, MISQUERYPARSER_TOKEN_KIND_HASH_ROCKET, 0]) {
        [self gtEq_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_EL_SYM, MISQUERYPARSER_TOKEN_KIND_LE_SYM, 0]) {
        [self ltEq_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_NOT_EQUAL, MISQUERYPARSER_TOKEN_KIND_NOT_EQUALS, 0]) {
        [self notEq_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_BEGINSWITH, 0]) {
        [self beginswith_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_CONTAINS, 0]) {
        [self contains_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_ENDSWITH, 0]) {
        [self endswith_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_LIKE, 0]) {
        [self like_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_MATCHES, 0]) {
        [self matches_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'comparisonOperator'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchComparisonOperator:)];
}

- (void)eq_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_EQUALS, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_EQUALS discard:NO]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_DOUBLE_EQUALS, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_DOUBLE_EQUALS discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eq'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)gt_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_GT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)lt_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_LT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)gtEq_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_GE_SYM, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_GE_SYM discard:NO]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_HASH_ROCKET, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_HASH_ROCKET discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'gtEq'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchGtEq:)];
}

- (void)ltEq_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_LE_SYM, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_LE_SYM discard:NO]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_EL_SYM, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_EL_SYM discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'ltEq'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLtEq:)];
}

- (void)notEq_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_NOT_EQUAL discard:NO]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_NOT_EQUALS, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_NOT_EQUALS discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'notEq'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNotEq:)];
}

- (void)beginswith_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_BEGINSWITH discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBeginswith:)];
}

- (void)contains_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_CONTAINS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchContains:)];
}

- (void)endswith_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_ENDSWITH discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEndswith:)];
}

- (void)like_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_LIKE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLike:)];
}

- (void)matches_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_MATCHES discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMatches:)];
}

- (void)andKeyword_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_AND_UPPER, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_AND_UPPER discard:YES]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_DOUBLE_AMPERSAND discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'andKeyword'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndKeyword:)];
}

- (void)orKeyword_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_OR_UPPER, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_OR_UPPER discard:YES]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_DOUBLE_PIPE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'orKeyword'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrKeyword:)];
}

- (void)notKeyword_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_NOT_UPPER, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_NOT_UPPER discard:YES]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_BANG, 0]) {
        [self match:MISQUERYPARSER_TOKEN_KIND_BANG discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'notKeyword'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNotKeyword:)];
}

- (void)atom_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self keyPath_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self string_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_FALSE, MISQUERYPARSER_TOKEN_KIND_TRUE, 0]) {
        [self bool_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)keyPath_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchKeyPath:)];
}

- (void)string_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchString:)];
}

- (void)num_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNum:)];
}

- (void)bool_ {
    
    if ([self predicts:MISQUERYPARSER_TOKEN_KIND_TRUE, 0]) {
        [self true_]; 
    } else if ([self predicts:MISQUERYPARSER_TOKEN_KIND_FALSE, 0]) {
        [self false_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)true_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_TRUE discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)false_ {
    
    [self match:MISQUERYPARSER_TOKEN_KIND_FALSE discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

@end
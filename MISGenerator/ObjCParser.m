#import "ObjCParser.h"
#import <PEGKit/PEGKit.h>


@interface ObjCParser ()

@property (nonatomic, retain) NSMutableDictionary *file_memo;
@property (nonatomic, retain) NSMutableDictionary *p_memo;
@property (nonatomic, retain) NSMutableDictionary *typedef_memo;
@property (nonatomic, retain) NSMutableDictionary *enum_memo;
@property (nonatomic, retain) NSMutableDictionary *extern_memo;
@property (nonatomic, retain) NSMutableDictionary *static_memo;
@property (nonatomic, retain) NSMutableDictionary *const_memo;
@property (nonatomic, retain) NSMutableDictionary *protocolDecl_memo;
@property (nonatomic, retain) NSMutableDictionary *classDecl_memo;
@property (nonatomic, retain) NSMutableDictionary *classDefn_memo;
@property (nonatomic, retain) NSMutableDictionary *classHeader_memo;
@property (nonatomic, retain) NSMutableDictionary *classFooter_memo;
@property (nonatomic, retain) NSMutableDictionary *atInterface_memo;
@property (nonatomic, retain) NSMutableDictionary *classDefnName_memo;
@property (nonatomic, retain) NSMutableDictionary *className_memo;
@property (nonatomic, retain) NSMutableDictionary *superclassName_memo;
@property (nonatomic, retain) NSMutableDictionary *protocolList_memo;
@property (nonatomic, retain) NSMutableDictionary *classBody_memo;
@property (nonatomic, retain) NSMutableDictionary *type_memo;
@property (nonatomic, retain) NSMutableDictionary *nonBlockType_memo;
@property (nonatomic, retain) NSMutableDictionary *namedBlockType_memo;
@property (nonatomic, retain) NSMutableDictionary *anonBlockType_memo;
@property (nonatomic, retain) NSMutableDictionary *blockName_memo;
@property (nonatomic, retain) NSMutableDictionary *funcParam_memo;
@property (nonatomic, retain) NSMutableDictionary *pointerType_memo;
@property (nonatomic, retain) NSMutableDictionary *primitiveType_memo;
@property (nonatomic, retain) NSMutableDictionary *structType_memo;
@property (nonatomic, retain) NSMutableDictionary *unionType_memo;
@property (nonatomic, retain) NSMutableDictionary *ivarList_memo;
@property (nonatomic, retain) NSMutableDictionary *ivar_memo;
@property (nonatomic, retain) NSMutableDictionary *arrayIvar_memo;
@property (nonatomic, retain) NSMutableDictionary *size_memo;
@property (nonatomic, retain) NSMutableDictionary *scalarIvar_memo;
@property (nonatomic, retain) NSMutableDictionary *property_memo;
@property (nonatomic, retain) NSMutableDictionary *nonBlockProperty_memo;
@property (nonatomic, retain) NSMutableDictionary *nonBlockPropertyType_memo;
@property (nonatomic, retain) NSMutableDictionary *blockProperty_memo;
@property (nonatomic, retain) NSMutableDictionary *blockPropertyType_memo;
@property (nonatomic, retain) NSMutableDictionary *blockPropertyName_memo;
@property (nonatomic, retain) NSMutableDictionary *propertySpecList_memo;
@property (nonatomic, retain) NSMutableDictionary *propertySpec_memo;
@property (nonatomic, retain) NSMutableDictionary *strength_memo;
@property (nonatomic, retain) NSMutableDictionary *atomicity_memo;
@property (nonatomic, retain) NSMutableDictionary *magnitiude_memo;
@property (nonatomic, retain) NSMutableDictionary *getter_memo;
@property (nonatomic, retain) NSMutableDictionary *setter_memo;
@property (nonatomic, retain) NSMutableDictionary *propertyName_memo;
@property (nonatomic, retain) NSMutableDictionary *method_memo;
@property (nonatomic, retain) NSMutableDictionary *methodSpec_memo;
@property (nonatomic, retain) NSMutableDictionary *methodNamePart_memo;
@property (nonatomic, retain) NSMutableDictionary *methodColon_memo;
@property (nonatomic, retain) NSMutableDictionary *methodReturnType_memo;
@property (nonatomic, retain) NSMutableDictionary *methodParam_memo;
@property (nonatomic, retain) NSMutableDictionary *methodParamType_memo;
@property (nonatomic, retain) NSMutableDictionary *methodParamName_memo;
@property (nonatomic, retain) NSMutableDictionary *parenType_memo;
@property (nonatomic, retain) NSMutableDictionary *identifier_memo;
@property (nonatomic, retain) NSMutableDictionary *at_memo;
@property (nonatomic, retain) NSMutableDictionary *colon_memo;
@property (nonatomic, retain) NSMutableDictionary *semi_memo;
@property (nonatomic, retain) NSMutableDictionary *ibOutlet_memo;
@end

@implementation ObjCParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"file";
        self.tokenKindTab[@"const"] = @(OBJCPARSER_TOKEN_KIND_CONST);
        self.tokenKindTab[@"IBOutlet"] = @(OBJCPARSER_TOKEN_KIND_IBOUTLET);
        self.tokenKindTab[@"class"] = @(OBJCPARSER_TOKEN_KIND_CLASS);
        self.tokenKindTab[@"{"] = @(OBJCPARSER_TOKEN_KIND_OPEN_CURLY);
        self.tokenKindTab[@"}"] = @(OBJCPARSER_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"assign"] = @(OBJCPARSER_TOKEN_KIND_ASSIGN);
        self.tokenKindTab[@"getter"] = @(OBJCPARSER_TOKEN_KIND_GETTER);
        self.tokenKindTab[@"#,"] = @(OBJCPARSER_TOKEN_KIND_P);
        self.tokenKindTab[@"extern"] = @(OBJCPARSER_TOKEN_KIND_EXTERN);
        self.tokenKindTab[@"weak"] = @(OBJCPARSER_TOKEN_KIND_WEAK);
        self.tokenKindTab[@":"] = @(OBJCPARSER_TOKEN_KIND_METHODCOLON);
        self.tokenKindTab[@"enum"] = @(OBJCPARSER_TOKEN_KIND_ENUM);
        self.tokenKindTab[@";"] = @(OBJCPARSER_TOKEN_KIND_SEMI);
        self.tokenKindTab[@"end"] = @(OBJCPARSER_TOKEN_KIND_END);
        self.tokenKindTab[@"<"] = @(OBJCPARSER_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"readonly"] = @(OBJCPARSER_TOKEN_KIND_READONLY);
        self.tokenKindTab[@"nonatomic"] = @(OBJCPARSER_TOKEN_KIND_ATOMICITY);
        self.tokenKindTab[@"="] = @(OBJCPARSER_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"setter"] = @(OBJCPARSER_TOKEN_KIND_SETTER);
        self.tokenKindTab[@">"] = @(OBJCPARSER_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"property"] = @(OBJCPARSER_TOKEN_KIND_PROPERTY);
        self.tokenKindTab[@"static"] = @(OBJCPARSER_TOKEN_KIND_STATIC);
        self.tokenKindTab[@"("] = @(OBJCPARSER_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@")"] = @(OBJCPARSER_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"@"] = @(OBJCPARSER_TOKEN_KIND_AT);
        self.tokenKindTab[@"*"] = @(OBJCPARSER_TOKEN_KIND_STAR);
        self.tokenKindTab[@"strong"] = @(OBJCPARSER_TOKEN_KIND_STRONG);
        self.tokenKindTab[@"+"] = @(OBJCPARSER_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"["] = @(OBJCPARSER_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@","] = @(OBJCPARSER_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"copy"] = @(OBJCPARSER_TOKEN_KIND_COPY);
        self.tokenKindTab[@"retain"] = @(OBJCPARSER_TOKEN_KIND_RETAIN);
        self.tokenKindTab[@"-"] = @(OBJCPARSER_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"]"] = @(OBJCPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"struct"] = @(OBJCPARSER_TOKEN_KIND_STRUCT);
        self.tokenKindTab[@"^"] = @(OBJCPARSER_TOKEN_KIND_CARET);
        self.tokenKindTab[@"typedef"] = @(OBJCPARSER_TOKEN_KIND_TYPEDEF);
        self.tokenKindTab[@"union"] = @(OBJCPARSER_TOKEN_KIND_UNION);
        self.tokenKindTab[@"readwrite"] = @(OBJCPARSER_TOKEN_KIND_READWRITE);
        self.tokenKindTab[@"interface"] = @(OBJCPARSER_TOKEN_KIND_INTERFACE);
        self.tokenKindTab[@"protocol"] = @(OBJCPARSER_TOKEN_KIND_PROTOCOL);

        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_CONST] = @"const";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_IBOUTLET] = @"IBOutlet";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_CLASS] = @"class";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_OPEN_CURLY] = @"{";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_ASSIGN] = @"assign";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_GETTER] = @"getter";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_P] = @"#,";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_EXTERN] = @"extern";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_WEAK] = @"weak";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_METHODCOLON] = @":";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_ENUM] = @"enum";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_SEMI] = @";";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_END] = @"end";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_READONLY] = @"readonly";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_ATOMICITY] = @"nonatomic";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_SETTER] = @"setter";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_PROPERTY] = @"property";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_STATIC] = @"static";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_AT] = @"@";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_STAR] = @"*";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_STRONG] = @"strong";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_COPY] = @"copy";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_RETAIN] = @"retain";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_STRUCT] = @"struct";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_CARET] = @"^";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_TYPEDEF] = @"typedef";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_UNION] = @"union";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_READWRITE] = @"readwrite";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_INTERFACE] = @"interface";
        self.tokenKindNameTab[OBJCPARSER_TOKEN_KIND_PROTOCOL] = @"protocol";

        self.file_memo = [NSMutableDictionary dictionary];
        self.p_memo = [NSMutableDictionary dictionary];
        self.typedef_memo = [NSMutableDictionary dictionary];
        self.enum_memo = [NSMutableDictionary dictionary];
        self.extern_memo = [NSMutableDictionary dictionary];
        self.static_memo = [NSMutableDictionary dictionary];
        self.const_memo = [NSMutableDictionary dictionary];
        self.protocolDecl_memo = [NSMutableDictionary dictionary];
        self.classDecl_memo = [NSMutableDictionary dictionary];
        self.classDefn_memo = [NSMutableDictionary dictionary];
        self.classHeader_memo = [NSMutableDictionary dictionary];
        self.classFooter_memo = [NSMutableDictionary dictionary];
        self.atInterface_memo = [NSMutableDictionary dictionary];
        self.classDefnName_memo = [NSMutableDictionary dictionary];
        self.className_memo = [NSMutableDictionary dictionary];
        self.superclassName_memo = [NSMutableDictionary dictionary];
        self.protocolList_memo = [NSMutableDictionary dictionary];
        self.classBody_memo = [NSMutableDictionary dictionary];
        self.type_memo = [NSMutableDictionary dictionary];
        self.nonBlockType_memo = [NSMutableDictionary dictionary];
        self.namedBlockType_memo = [NSMutableDictionary dictionary];
        self.anonBlockType_memo = [NSMutableDictionary dictionary];
        self.blockName_memo = [NSMutableDictionary dictionary];
        self.funcParam_memo = [NSMutableDictionary dictionary];
        self.pointerType_memo = [NSMutableDictionary dictionary];
        self.primitiveType_memo = [NSMutableDictionary dictionary];
        self.structType_memo = [NSMutableDictionary dictionary];
        self.unionType_memo = [NSMutableDictionary dictionary];
        self.ivarList_memo = [NSMutableDictionary dictionary];
        self.ivar_memo = [NSMutableDictionary dictionary];
        self.arrayIvar_memo = [NSMutableDictionary dictionary];
        self.size_memo = [NSMutableDictionary dictionary];
        self.scalarIvar_memo = [NSMutableDictionary dictionary];
        self.property_memo = [NSMutableDictionary dictionary];
        self.nonBlockProperty_memo = [NSMutableDictionary dictionary];
        self.nonBlockPropertyType_memo = [NSMutableDictionary dictionary];
        self.blockProperty_memo = [NSMutableDictionary dictionary];
        self.blockPropertyType_memo = [NSMutableDictionary dictionary];
        self.blockPropertyName_memo = [NSMutableDictionary dictionary];
        self.propertySpecList_memo = [NSMutableDictionary dictionary];
        self.propertySpec_memo = [NSMutableDictionary dictionary];
        self.strength_memo = [NSMutableDictionary dictionary];
        self.atomicity_memo = [NSMutableDictionary dictionary];
        self.magnitiude_memo = [NSMutableDictionary dictionary];
        self.getter_memo = [NSMutableDictionary dictionary];
        self.setter_memo = [NSMutableDictionary dictionary];
        self.propertyName_memo = [NSMutableDictionary dictionary];
        self.method_memo = [NSMutableDictionary dictionary];
        self.methodSpec_memo = [NSMutableDictionary dictionary];
        self.methodNamePart_memo = [NSMutableDictionary dictionary];
        self.methodColon_memo = [NSMutableDictionary dictionary];
        self.methodReturnType_memo = [NSMutableDictionary dictionary];
        self.methodParam_memo = [NSMutableDictionary dictionary];
        self.methodParamType_memo = [NSMutableDictionary dictionary];
        self.methodParamName_memo = [NSMutableDictionary dictionary];
        self.parenType_memo = [NSMutableDictionary dictionary];
        self.identifier_memo = [NSMutableDictionary dictionary];
        self.at_memo = [NSMutableDictionary dictionary];
        self.colon_memo = [NSMutableDictionary dictionary];
        self.semi_memo = [NSMutableDictionary dictionary];
        self.ibOutlet_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.file_memo = nil;
    self.p_memo = nil;
    self.typedef_memo = nil;
    self.enum_memo = nil;
    self.extern_memo = nil;
    self.static_memo = nil;
    self.const_memo = nil;
    self.protocolDecl_memo = nil;
    self.classDecl_memo = nil;
    self.classDefn_memo = nil;
    self.classHeader_memo = nil;
    self.classFooter_memo = nil;
    self.atInterface_memo = nil;
    self.classDefnName_memo = nil;
    self.className_memo = nil;
    self.superclassName_memo = nil;
    self.protocolList_memo = nil;
    self.classBody_memo = nil;
    self.type_memo = nil;
    self.nonBlockType_memo = nil;
    self.namedBlockType_memo = nil;
    self.anonBlockType_memo = nil;
    self.blockName_memo = nil;
    self.funcParam_memo = nil;
    self.pointerType_memo = nil;
    self.primitiveType_memo = nil;
    self.structType_memo = nil;
    self.unionType_memo = nil;
    self.ivarList_memo = nil;
    self.ivar_memo = nil;
    self.arrayIvar_memo = nil;
    self.size_memo = nil;
    self.scalarIvar_memo = nil;
    self.property_memo = nil;
    self.nonBlockProperty_memo = nil;
    self.nonBlockPropertyType_memo = nil;
    self.blockProperty_memo = nil;
    self.blockPropertyType_memo = nil;
    self.blockPropertyName_memo = nil;
    self.propertySpecList_memo = nil;
    self.propertySpec_memo = nil;
    self.strength_memo = nil;
    self.atomicity_memo = nil;
    self.magnitiude_memo = nil;
    self.getter_memo = nil;
    self.setter_memo = nil;
    self.propertyName_memo = nil;
    self.method_memo = nil;
    self.methodSpec_memo = nil;
    self.methodNamePart_memo = nil;
    self.methodColon_memo = nil;
    self.methodReturnType_memo = nil;
    self.methodParam_memo = nil;
    self.methodParamType_memo = nil;
    self.methodParamName_memo = nil;
    self.parenType_memo = nil;
    self.identifier_memo = nil;
    self.at_memo = nil;
    self.colon_memo = nil;
    self.semi_memo = nil;
    self.ibOutlet_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_file_memo removeAllObjects];
    [_p_memo removeAllObjects];
    [_typedef_memo removeAllObjects];
    [_enum_memo removeAllObjects];
    [_extern_memo removeAllObjects];
    [_static_memo removeAllObjects];
    [_const_memo removeAllObjects];
    [_protocolDecl_memo removeAllObjects];
    [_classDecl_memo removeAllObjects];
    [_classDefn_memo removeAllObjects];
    [_classHeader_memo removeAllObjects];
    [_classFooter_memo removeAllObjects];
    [_atInterface_memo removeAllObjects];
    [_classDefnName_memo removeAllObjects];
    [_className_memo removeAllObjects];
    [_superclassName_memo removeAllObjects];
    [_protocolList_memo removeAllObjects];
    [_classBody_memo removeAllObjects];
    [_type_memo removeAllObjects];
    [_nonBlockType_memo removeAllObjects];
    [_namedBlockType_memo removeAllObjects];
    [_anonBlockType_memo removeAllObjects];
    [_blockName_memo removeAllObjects];
    [_funcParam_memo removeAllObjects];
    [_pointerType_memo removeAllObjects];
    [_primitiveType_memo removeAllObjects];
    [_structType_memo removeAllObjects];
    [_unionType_memo removeAllObjects];
    [_ivarList_memo removeAllObjects];
    [_ivar_memo removeAllObjects];
    [_arrayIvar_memo removeAllObjects];
    [_size_memo removeAllObjects];
    [_scalarIvar_memo removeAllObjects];
    [_property_memo removeAllObjects];
    [_nonBlockProperty_memo removeAllObjects];
    [_nonBlockPropertyType_memo removeAllObjects];
    [_blockProperty_memo removeAllObjects];
    [_blockPropertyType_memo removeAllObjects];
    [_blockPropertyName_memo removeAllObjects];
    [_propertySpecList_memo removeAllObjects];
    [_propertySpec_memo removeAllObjects];
    [_strength_memo removeAllObjects];
    [_atomicity_memo removeAllObjects];
    [_magnitiude_memo removeAllObjects];
    [_getter_memo removeAllObjects];
    [_setter_memo removeAllObjects];
    [_propertyName_memo removeAllObjects];
    [_method_memo removeAllObjects];
    [_methodSpec_memo removeAllObjects];
    [_methodNamePart_memo removeAllObjects];
    [_methodColon_memo removeAllObjects];
    [_methodReturnType_memo removeAllObjects];
    [_methodParam_memo removeAllObjects];
    [_methodParamType_memo removeAllObjects];
    [_methodParamName_memo removeAllObjects];
    [_parenType_memo removeAllObjects];
    [_identifier_memo removeAllObjects];
    [_at_memo removeAllObjects];
    [_colon_memo removeAllObjects];
    [_semi_memo removeAllObjects];
    [_ibOutlet_memo removeAllObjects];
}

- (void)start {
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
    [t.symbolState add:@"||"];
    [t.symbolState add:@"&&"];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"!=="];
    [t.symbolState add:@"=="];
    [t.symbolState add:@"==="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];
    [t.symbolState add:@"++"];
    [t.symbolState add:@"--"];
    [t.symbolState add:@"+="];
    [t.symbolState add:@"-="];
    [t.symbolState add:@"*="];
    [t.symbolState add:@"/="];
    [t.symbolState add:@"%="];
    [t.symbolState add:@"<<"];
    [t.symbolState add:@">>"];
    [t.symbolState add:@">>>"];
    [t.symbolState add:@"<<="];
    [t.symbolState add:@">>="];
    [t.symbolState add:@">>>="];
    [t.symbolState add:@"&="];
    [t.symbolState add:@"^="];
    [t.symbolState add:@"|="];

    self.silentlyConsumesWhitespace = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    self.assembly.preservesWhitespaceTokens = YES;

    [t setTokenizerState:t.wordState from:'_' to:'_'];
    [t.wordState setWordChars:YES from:'_' to:'_'];

    // setup comments
    t.commentState.reportsCommentTokens = NO;
    [t setTokenizerState:t.commentState from:'/' to:'/'];
    [t.commentState addSingleLineStartMarker:@"//"];
    [t.commentState addMultiLineStartMarker:@"/*" endMarker:@"*/"];

    // preprocessor directives
    [t setTokenizerState:t.delimitState from:'#' to:'#'];
    [t.delimitState addStartMarker:@"#" endMarker:nil allowedCharacterSet:[[NSCharacterSet newlineCharacterSet] invertedSet]];
    
//    while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0])

    }];

    [self file_]; 
    [self matchEOF:YES]; 

}

- (void)__file {
    
    while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]) {
        if ([self speculate:^{ [self classDefn_]; }]) {
            [self classDefn_]; 
        } else if ([self speculate:^{ [self p_]; }]) {
            [self p_]; 
        } else if ([self speculate:^{ [self typedef_]; }]) {
            [self typedef_]; 
        } else if ([self speculate:^{ [self enum_]; }]) {
            [self enum_]; 
        } else if ([self speculate:^{ [self extern_]; }]) {
            [self extern_]; 
        } else if ([self speculate:^{ [self static_]; }]) {
            [self static_]; 
        } else if ([self speculate:^{ [self const_]; }]) {
            [self const_]; 
        } else if ([self speculate:^{ [self protocolDecl_]; }]) {
            [self protocolDecl_]; 
        } else if ([self speculate:^{ [self classDecl_]; }]) {
            [self classDecl_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'file'."];
        }
    }

    [self fireDelegateSelector:@selector(parser:didMatchFile:)];
}

- (void)file_ {
    [self parseRule:@selector(__file) withMemo:_file_memo];
}

- (void)__p {
    
    [self match:OBJCPARSER_TOKEN_KIND_P discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchP:)];
}

- (void)p_ {
    [self parseRule:@selector(__p) withMemo:_p_memo];
}

- (void)__typedef {
    
    [self match:OBJCPARSER_TOKEN_KIND_TYPEDEF discard:NO]; 
    while ([self speculate:^{ if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in typedef"];}}]) {
        if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in typedef"];
        }
    }
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchTypedef:)];
}

- (void)typedef_ {
    [self parseRule:@selector(__typedef) withMemo:_typedef_memo];
}

- (void)__enum {
    
    [self match:OBJCPARSER_TOKEN_KIND_ENUM discard:NO]; 
    while ([self speculate:^{ if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in enum"];}}]) {
        if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in enum"];
        }
    }
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchEnum:)];
}

- (void)enum_ {
    [self parseRule:@selector(__enum) withMemo:_enum_memo];
}

- (void)__extern {
    
    [self match:OBJCPARSER_TOKEN_KIND_EXTERN discard:NO]; 
    while ([self speculate:^{ if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in extern"];}}]) {
        if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in extern"];
        }
    }
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExtern:)];
}

- (void)extern_ {
    [self parseRule:@selector(__extern) withMemo:_extern_memo];
}

- (void)__static {
    
    [self match:OBJCPARSER_TOKEN_KIND_STATIC discard:NO]; 
    while ([self speculate:^{ if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in static"];}}]) {
        if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in static"];
        }
    }
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchStatic:)];
}

- (void)static_ {
    [self parseRule:@selector(__static) withMemo:_static_memo];
}

- (void)__const {
    
    [self match:OBJCPARSER_TOKEN_KIND_CONST discard:NO]; 
    while ([self speculate:^{ if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in const"];}}]) {
        if (![self predicts:OBJCPARSER_TOKEN_KIND_SEMI, 0]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in const"];
        }
    }
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchConst:)];
}

- (void)const_ {
    [self parseRule:@selector(__const) withMemo:_const_memo];
}

- (void)__protocolDecl {
    
    [self at_]; 
    [self match:OBJCPARSER_TOKEN_KIND_PROTOCOL discard:NO]; 
    [self identifier_]; 
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchProtocolDecl:)];
}

- (void)protocolDecl_ {
    [self parseRule:@selector(__protocolDecl) withMemo:_protocolDecl_memo];
}

- (void)__classDecl {
    
    [self at_]; 
    [self match:OBJCPARSER_TOKEN_KIND_CLASS discard:NO]; 
    [self identifier_]; 
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchClassDecl:)];
}

- (void)classDecl_ {
    [self parseRule:@selector(__classDecl) withMemo:_classDecl_memo];
}

- (void)__classDefn {
    
    [self classHeader_]; 
    [self classBody_]; 
    [self classFooter_]; 

    [self fireDelegateSelector:@selector(parser:didMatchClassDefn:)];
}

- (void)classDefn_ {
    [self parseRule:@selector(__classDefn) withMemo:_classDefn_memo];
}

- (void)__classHeader {
    
    [self atInterface_]; 
    [self classDefnName_]; 
    [self colon_]; 
    [self superclassName_]; 
    if ([self speculate:^{ [self protocolList_]; }]) {
        [self protocolList_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchClassHeader:)];
}

- (void)classHeader_ {
    [self parseRule:@selector(__classHeader) withMemo:_classHeader_memo];
}

- (void)__classFooter {
    
    [self at_]; 
    [self match:OBJCPARSER_TOKEN_KIND_END discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchClassFooter:)];
}

- (void)classFooter_ {
    [self parseRule:@selector(__classFooter) withMemo:_classFooter_memo];
}

- (void)__atInterface {
    
    [self at_]; 
    [self match:OBJCPARSER_TOKEN_KIND_INTERFACE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAtInterface:)];
}

- (void)atInterface_ {
    [self parseRule:@selector(__atInterface) withMemo:_atInterface_memo];
}

- (void)__classDefnName {
    
    [self className_]; 

    [self fireDelegateSelector:@selector(parser:didMatchClassDefnName:)];
}

- (void)classDefnName_ {
    [self parseRule:@selector(__classDefnName) withMemo:_classDefnName_memo];
}

- (void)__className {
    
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchClassName:)];
}

- (void)className_ {
    [self parseRule:@selector(__className) withMemo:_className_memo];
}

- (void)__superclassName {
    
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchSuperclassName:)];
}

- (void)superclassName_ {
    [self parseRule:@selector(__superclassName) withMemo:_superclassName_memo];
}

- (void)__protocolList {
    
    [self match:OBJCPARSER_TOKEN_KIND_LT_SYM discard:NO]; 
    [self className_]; 
    while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self className_]; }]) {
        [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; 
        [self className_]; 
    }
    [self match:OBJCPARSER_TOKEN_KIND_GT_SYM discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchProtocolList:)];
}

- (void)protocolList_ {
    [self parseRule:@selector(__protocolList) withMemo:_protocolList_memo];
}

- (void)__classBody {
    
    if ([self speculate:^{ [self ivarList_]; }]) {
        [self ivarList_]; 
    }
    while ([self speculate:^{ if ([self predicts:OBJCPARSER_TOKEN_KIND_AT, 0]) {[self property_]; } else if ([self predicts:OBJCPARSER_TOKEN_KIND_MINUS, OBJCPARSER_TOKEN_KIND_PLUS, 0]) {[self method_]; } else if ([self predicts:OBJCPARSER_TOKEN_KIND_P, 0]) {[self p_]; } else {[self raise:@"No viable alternative found in rule 'classBody'."];}}]) {
        if ([self predicts:OBJCPARSER_TOKEN_KIND_AT, 0]) {
            [self property_]; 
        } else if ([self predicts:OBJCPARSER_TOKEN_KIND_MINUS, OBJCPARSER_TOKEN_KIND_PLUS, 0]) {
            [self method_]; 
        } else if ([self predicts:OBJCPARSER_TOKEN_KIND_P, 0]) {
            [self p_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'classBody'."];
        }
    }

    [self fireDelegateSelector:@selector(parser:didMatchClassBody:)];
}

- (void)classBody_ {
    [self parseRule:@selector(__classBody) withMemo:_classBody_memo];
}

- (void)__type {
    
    if ([self speculate:^{ [self anonBlockType_]; }]) {
        [self anonBlockType_]; 
    } else if ([self speculate:^{ [self nonBlockType_]; }]) {
        [self nonBlockType_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'type'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchType:)];
}

- (void)type_ {
    [self parseRule:@selector(__type) withMemo:_type_memo];
}

- (void)__nonBlockType {
    
    if ([self speculate:^{ [self unionType_]; }]) {
        [self unionType_]; 
    } else if ([self speculate:^{ [self structType_]; }]) {
        [self structType_]; 
    } else if ([self speculate:^{ [self pointerType_]; }]) {
        [self pointerType_]; 
    } else if ([self speculate:^{ [self primitiveType_]; }]) {
        [self primitiveType_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nonBlockType'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNonBlockType:)];
}

- (void)nonBlockType_ {
    [self parseRule:@selector(__nonBlockType) withMemo:_nonBlockType_memo];
}

- (void)__namedBlockType {
    
    [self nonBlockType_]; 
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_CARET discard:NO]; 
    [self blockName_]; 
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self funcParam_]; while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }]) {[self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }}]) {
        [self funcParam_]; 
        while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }]) {
            [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; 
            [self funcParam_]; 
        }
    }
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNamedBlockType:)];
}

- (void)namedBlockType_ {
    [self parseRule:@selector(__namedBlockType) withMemo:_namedBlockType_memo];
}

- (void)__anonBlockType {
    
    [self nonBlockType_]; 
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_CARET discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self funcParam_]; while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }]) {[self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }}]) {
        [self funcParam_]; 
        while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }]) {
            [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; 
            [self funcParam_]; 
        }
    }
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAnonBlockType:)];
}

- (void)anonBlockType_ {
    [self parseRule:@selector(__anonBlockType) withMemo:_anonBlockType_memo];
}

- (void)__blockName {
    
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchBlockName:)];
}

- (void)blockName_ {
    [self parseRule:@selector(__blockName) withMemo:_blockName_memo];
}

- (void)__funcParam {
    
    if ([self speculate:^{ [self namedBlockType_]; }]) {
        [self namedBlockType_]; 
    } else if ([self speculate:^{ [self anonBlockType_]; }]) {
        [self anonBlockType_]; 
    } else if ([self speculate:^{ [self type_]; if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {[self identifier_]; }}]) {
        [self type_]; 
        if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [self identifier_]; 
        }
    } else {
        [self raise:@"No viable alternative found in rule 'funcParam'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFuncParam:)];
}

- (void)funcParam_ {
    [self parseRule:@selector(__funcParam) withMemo:_funcParam_memo];
}

- (void)__pointerType {
    
    [self identifier_]; 
    [self match:OBJCPARSER_TOKEN_KIND_STAR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPointerType:)];
}

- (void)pointerType_ {
    [self parseRule:@selector(__pointerType) withMemo:_pointerType_memo];
}

- (void)__primitiveType {
    
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPrimitiveType:)];
}

- (void)primitiveType_ {
    [self parseRule:@selector(__primitiveType) withMemo:_primitiveType_memo];
}

- (void)__structType {
    
    [self match:OBJCPARSER_TOKEN_KIND_STRUCT discard:NO]; 
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchStructType:)];
}

- (void)structType_ {
    [self parseRule:@selector(__structType) withMemo:_structType_memo];
}

- (void)__unionType {
    
    [self match:OBJCPARSER_TOKEN_KIND_UNION discard:NO]; 
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchUnionType:)];
}

- (void)unionType_ {
    [self parseRule:@selector(__unionType) withMemo:_unionType_memo];
}

- (void)__ivarList {
    
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    while ([self speculate:^{ [self ivar_]; }]) {
        [self ivar_]; 
    }
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_CURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIvarList:)];
}

- (void)ivarList_ {
    [self parseRule:@selector(__ivarList) withMemo:_ivarList_memo];
}

- (void)__ivar {
    
    if ([self speculate:^{ [self arrayIvar_]; }]) {
        [self arrayIvar_]; 
    } else if ([self speculate:^{ [self scalarIvar_]; }]) {
        [self scalarIvar_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'ivar'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIvar:)];
}

- (void)ivar_ {
    [self parseRule:@selector(__ivar) withMemo:_ivar_memo];
}

- (void)__arrayIvar {
    
    [self type_]; 
    [self identifier_]; 
    do {
        [self match:OBJCPARSER_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
        if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_WORD, 0]) {
            [self size_]; 
        }
        [self match:OBJCPARSER_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 
    } while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_OPEN_BRACKET discard:NO]; if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_WORD, 0]) {[self size_]; }[self match:OBJCPARSER_TOKEN_KIND_CLOSE_BRACKET discard:NO]; }]);
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchArrayIvar:)];
}

- (void)arrayIvar_ {
    [self parseRule:@selector(__arrayIvar) withMemo:_arrayIvar_memo];
}

- (void)__size {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self identifier_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'size'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchSize:)];
}

- (void)size_ {
    [self parseRule:@selector(__size) withMemo:_size_memo];
}

- (void)__scalarIvar {
    
    if ([self predicts:OBJCPARSER_TOKEN_KIND_IBOUTLET, 0]) {
        [self ibOutlet_]; 
    }
    [self type_]; 
    [self identifier_]; 
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchScalarIvar:)];
}

- (void)scalarIvar_ {
    [self parseRule:@selector(__scalarIvar) withMemo:_scalarIvar_memo];
}

- (void)__property {
    
    if ([self speculate:^{ [self nonBlockProperty_]; }]) {
        [self nonBlockProperty_]; 
    } else if ([self speculate:^{ [self blockProperty_]; }]) {
        [self blockProperty_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'property'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchProperty:)];
}

- (void)property_ {
    [self parseRule:@selector(__property) withMemo:_property_memo];
}

- (void)__nonBlockProperty {
    
    [self at_]; 
    [self match:OBJCPARSER_TOKEN_KIND_PROPERTY discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self propertySpecList_]; 
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    if ([self predicts:OBJCPARSER_TOKEN_KIND_IBOUTLET, 0]) {
        [self ibOutlet_]; 
    }
    [self nonBlockPropertyType_]; 
    [self propertyName_]; 
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchNonBlockProperty:)];
}

- (void)nonBlockProperty_ {
    [self parseRule:@selector(__nonBlockProperty) withMemo:_nonBlockProperty_memo];
}

- (void)__nonBlockPropertyType {
    
    [self type_]; 

    [self fireDelegateSelector:@selector(parser:didMatchNonBlockPropertyType:)];
}

- (void)nonBlockPropertyType_ {
    [self parseRule:@selector(__nonBlockPropertyType) withMemo:_nonBlockPropertyType_memo];
}

- (void)__blockProperty {
    
    [self at_]; 
    [self match:OBJCPARSER_TOKEN_KIND_PROPERTY discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self propertySpecList_]; 
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    [self blockPropertyType_]; 
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchBlockProperty:)];
}

- (void)blockProperty_ {
    [self parseRule:@selector(__blockProperty) withMemo:_blockProperty_memo];
}

- (void)__blockPropertyType {
    
    [self nonBlockType_]; 
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_CARET discard:NO]; 
    [self blockPropertyName_]; 
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self funcParam_]; while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }]) {[self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }}]) {
        [self funcParam_]; 
        while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self funcParam_]; }]) {
            [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; 
            [self funcParam_]; 
        }
    }
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBlockPropertyType:)];
}

- (void)blockPropertyType_ {
    [self parseRule:@selector(__blockPropertyType) withMemo:_blockPropertyType_memo];
}

- (void)__blockPropertyName {
    
    [self blockName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchBlockPropertyName:)];
}

- (void)blockPropertyName_ {
    [self parseRule:@selector(__blockPropertyName) withMemo:_blockPropertyName_memo];
}

- (void)__propertySpecList {
    
    [self propertySpec_]; 
    while ([self speculate:^{ [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; [self propertySpec_]; }]) {
        [self match:OBJCPARSER_TOKEN_KIND_COMMA discard:NO]; 
        [self propertySpec_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchPropertySpecList:)];
}

- (void)propertySpecList_ {
    [self parseRule:@selector(__propertySpecList) withMemo:_propertySpecList_memo];
}

- (void)__propertySpec {
    
    do {
        if ([self predicts:OBJCPARSER_TOKEN_KIND_ATOMICITY, 0]) {
            [self atomicity_]; 
        } else if ([self predicts:OBJCPARSER_TOKEN_KIND_ASSIGN, OBJCPARSER_TOKEN_KIND_COPY, OBJCPARSER_TOKEN_KIND_RETAIN, OBJCPARSER_TOKEN_KIND_STRONG, OBJCPARSER_TOKEN_KIND_WEAK, 0]) {
            [self strength_]; 
        } else if ([self predicts:OBJCPARSER_TOKEN_KIND_READONLY, OBJCPARSER_TOKEN_KIND_READWRITE, 0]) {
            [self magnitiude_]; 
        } else if ([self predicts:OBJCPARSER_TOKEN_KIND_GETTER, 0]) {
            [self getter_]; 
        } else if ([self predicts:OBJCPARSER_TOKEN_KIND_SETTER, 0]) {
            [self setter_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'propertySpec'."];
        }
    } while ([self speculate:^{ if ([self predicts:OBJCPARSER_TOKEN_KIND_ATOMICITY, 0]) {[self atomicity_]; } else if ([self predicts:OBJCPARSER_TOKEN_KIND_ASSIGN, OBJCPARSER_TOKEN_KIND_COPY, OBJCPARSER_TOKEN_KIND_RETAIN, OBJCPARSER_TOKEN_KIND_STRONG, OBJCPARSER_TOKEN_KIND_WEAK, 0]) {[self strength_]; } else if ([self predicts:OBJCPARSER_TOKEN_KIND_READONLY, OBJCPARSER_TOKEN_KIND_READWRITE, 0]) {[self magnitiude_]; } else if ([self predicts:OBJCPARSER_TOKEN_KIND_GETTER, 0]) {[self getter_]; } else if ([self predicts:OBJCPARSER_TOKEN_KIND_SETTER, 0]) {[self setter_]; } else {[self raise:@"No viable alternative found in rule 'propertySpec'."];}}]);

    [self fireDelegateSelector:@selector(parser:didMatchPropertySpec:)];
}

- (void)propertySpec_ {
    [self parseRule:@selector(__propertySpec) withMemo:_propertySpec_memo];
}

- (void)__strength {
    
    if ([self predicts:OBJCPARSER_TOKEN_KIND_STRONG, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_STRONG discard:NO]; 
    } else if ([self predicts:OBJCPARSER_TOKEN_KIND_WEAK, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_WEAK discard:NO]; 
    } else if ([self predicts:OBJCPARSER_TOKEN_KIND_COPY, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_COPY discard:NO]; 
    } else if ([self predicts:OBJCPARSER_TOKEN_KIND_RETAIN, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_RETAIN discard:NO]; 
    } else if ([self predicts:OBJCPARSER_TOKEN_KIND_ASSIGN, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_ASSIGN discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'strength'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStrength:)];
}

- (void)strength_ {
    [self parseRule:@selector(__strength) withMemo:_strength_memo];
}

- (void)__atomicity {
    
    [self match:OBJCPARSER_TOKEN_KIND_ATOMICITY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAtomicity:)];
}

- (void)atomicity_ {
    [self parseRule:@selector(__atomicity) withMemo:_atomicity_memo];
}

- (void)__magnitiude {
    
    if ([self predicts:OBJCPARSER_TOKEN_KIND_READONLY, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_READONLY discard:NO]; 
    } else if ([self predicts:OBJCPARSER_TOKEN_KIND_READWRITE, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_READWRITE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'magnitiude'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMagnitiude:)];
}

- (void)magnitiude_ {
    [self parseRule:@selector(__magnitiude) withMemo:_magnitiude_memo];
}

- (void)__getter {
    
    [self match:OBJCPARSER_TOKEN_KIND_GETTER discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_EQUALS discard:NO]; 
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchGetter:)];
}

- (void)getter_ {
    [self parseRule:@selector(__getter) withMemo:_getter_memo];
}

- (void)__setter {
    
    [self match:OBJCPARSER_TOKEN_KIND_SETTER discard:NO]; 
    [self match:OBJCPARSER_TOKEN_KIND_EQUALS discard:NO]; 
    [self identifier_]; 
    [self colon_]; 

    [self fireDelegateSelector:@selector(parser:didMatchSetter:)];
}

- (void)setter_ {
    [self parseRule:@selector(__setter) withMemo:_setter_memo];
}

- (void)__propertyName {
    
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPropertyName:)];
}

- (void)propertyName_ {
    [self parseRule:@selector(__propertyName) withMemo:_propertyName_memo];
}

- (void)__method {
    
    [self methodSpec_]; 
    [self methodReturnType_]; 
    do {
        [self methodNamePart_]; 
        if ([self speculate:^{ [self methodColon_]; [self methodParam_]; }]) {
            [self methodColon_]; 
            [self methodParam_]; 
        }
    } while ([self speculate:^{ [self methodNamePart_]; if ([self speculate:^{ [self methodColon_]; [self methodParam_]; }]) {[self methodColon_]; [self methodParam_]; }}]);
    [self semi_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMethod:)];
}

- (void)method_ {
    [self parseRule:@selector(__method) withMemo:_method_memo];
}

- (void)__methodSpec {
    
    if ([self predicts:OBJCPARSER_TOKEN_KIND_MINUS, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_MINUS discard:NO]; 
    } else if ([self predicts:OBJCPARSER_TOKEN_KIND_PLUS, 0]) {
        [self match:OBJCPARSER_TOKEN_KIND_PLUS discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'methodSpec'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMethodSpec:)];
}

- (void)methodSpec_ {
    [self parseRule:@selector(__methodSpec) withMemo:_methodSpec_memo];
}

- (void)__methodNamePart {
    
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMethodNamePart:)];
}

- (void)methodNamePart_ {
    [self parseRule:@selector(__methodNamePart) withMemo:_methodNamePart_memo];
}

- (void)__methodColon {
    
    [self match:OBJCPARSER_TOKEN_KIND_METHODCOLON discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMethodColon:)];
}

- (void)methodColon_ {
    [self parseRule:@selector(__methodColon) withMemo:_methodColon_memo];
}

- (void)__methodReturnType {
    
    [self parenType_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMethodReturnType:)];
}

- (void)methodReturnType_ {
    [self parseRule:@selector(__methodReturnType) withMemo:_methodReturnType_memo];
}

- (void)__methodParam {
    
    [self methodParamType_]; 
    [self methodParamName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMethodParam:)];
}

- (void)methodParam_ {
    [self parseRule:@selector(__methodParam) withMemo:_methodParam_memo];
}

- (void)__methodParamType {
    
    [self parenType_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMethodParamType:)];
}

- (void)methodParamType_ {
    [self parseRule:@selector(__methodParamType) withMemo:_methodParamType_memo];
}

- (void)__methodParamName {
    
    [self identifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMethodParamName:)];
}

- (void)methodParamName_ {
    [self parseRule:@selector(__methodParamName) withMemo:_methodParamName_memo];
}

- (void)__parenType {
    
    [self match:OBJCPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self type_]; 
    [self match:OBJCPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchParenType:)];
}

- (void)parenType_ {
    [self parseRule:@selector(__parenType) withMemo:_parenType_memo];
}

- (void)__identifier {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIdentifier:)];
}

- (void)identifier_ {
    [self parseRule:@selector(__identifier) withMemo:_identifier_memo];
}

- (void)__at {
    
    [self match:OBJCPARSER_TOKEN_KIND_AT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAt:)];
}

- (void)at_ {
    [self parseRule:@selector(__at) withMemo:_at_memo];
}

- (void)__colon {
    
    [self match:OBJCPARSER_TOKEN_KIND_METHODCOLON discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchColon:)];
}

- (void)colon_ {
    [self parseRule:@selector(__colon) withMemo:_colon_memo];
}

- (void)__semi {
    
    [self match:OBJCPARSER_TOKEN_KIND_SEMI discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchSemi:)];
}

- (void)semi_ {
    [self parseRule:@selector(__semi) withMemo:_semi_memo];
}

- (void)__ibOutlet {
    
    [self match:OBJCPARSER_TOKEN_KIND_IBOUTLET discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchIbOutlet:)];
}

- (void)ibOutlet_ {
    [self parseRule:@selector(__ibOutlet) withMemo:_ibOutlet_memo];
}

@end

//
//  Repository.m
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "Repository.h"
#import "DomainObject.h"

#import "MISUnitOfWork.h"

#import "MISQueryParser.h"
#import "MISQueryAssembler.h"
#import "MISQuery.h"

@interface Repository ()
@property (nonatomic, retain) MISUnitOfWork *unitOfWork;
@end

@implementation Repository

- (void)dealloc {
    self.unitOfWork = nil;
    [super dealloc];
}


- (DomainObject *)find:(NSString *)queryStr {
    
    MISQueryAssembler *ass = [[[MISQueryAssembler alloc] init] autorelease];
    MISQueryParser *parser = [[[MISQueryParser alloc] initWithDelegate:ass] autorelease];
    
    NSError *err = nil;
    MISQuery *q = [parser parseString:queryStr error:&err];
    
    if (!q) {
        if (err) NSLog(@"%@", err);
        
    }
    
    DomainObject *obj = [q execute:_unitOfWork];
    
    return obj;
}


- (NSArray *)findAll:(NSString *)q {
    return nil;
}

@end

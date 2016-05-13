//
//  MISUnitOfWork.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MISMapper;
@class DomainObject;

typedef void(^MISCommitCompletion) (BOOL success, NSError *err);

extern NSString *const MISErrorDomainRemote;
extern NSString *const MISErrorDomainLocal;

@interface MISUnitOfWork : NSObject

+ (void)makeCurrent;
+ (MISUnitOfWork *)current;
+ (void)setCurrent:(MISUnitOfWork *)uow;

- (void)registerMapper:(MISMapper *)mapper forDomainClass:(Class)cls;
- (MISMapper *)mapperForDomainClass:(Class)cls;

- (void)registerPristine:(DomainObject *)obj;
- (void)registerClean:(DomainObject *)obj;
- (void)registerDirty:(DomainObject *)obj;
- (void)registerRemoved:(DomainObject *)obj;

- (void)commit:(MISCommitCompletion)completion;

- (BOOL)isLoaded:(NSNumber *)objID;
- (DomainObject *)objectForID:(NSNumber *)objID;
@end

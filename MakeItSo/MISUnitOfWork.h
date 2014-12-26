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

@interface MISUnitOfWork : NSObject

+ (void)makeCurrent;
+ (MISUnitOfWork *)current;

- (void)registerMapper:(MISMapper *)mapper forDomainClass:(Class)cls;
- (MISMapper *)mapperForDomainClass:(Class)cls;

- (void)registerPristine:(DomainObject *)obj;
- (void)registerClean:(DomainObject *)obj;
- (void)registerDirty:(DomainObject *)obj;
- (void)registerRemoved:(DomainObject *)obj;

- (void)commit;

- (BOOL)isLoaded:(NSNumber *)objID;
- (DomainObject *)objectForID:(NSNumber *)objID;

@end

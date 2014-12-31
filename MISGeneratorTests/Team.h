//
//  Team.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/27/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <MakeItSo/DomainObject.h>

@interface Team : DomainObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *players MIS_ONE_TO_MANY;
@end

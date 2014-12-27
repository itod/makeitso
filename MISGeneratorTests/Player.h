//
//  Player.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/27/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <MakeItSo/DomainObject.h>

@interface Player : DomainObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@end

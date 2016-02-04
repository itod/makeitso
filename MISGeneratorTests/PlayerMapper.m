#import "PlayerMapper.h"
#import "Player.h"

#import "Team.h"

#import "MISUnitOfWork.h"

#import <fmdb/FMResultSet.h>
#import <fmdb/FMDatabase.h>

@interface MISMapper ()
@property (nonatomic, retain) MISUnitOfWork *unitOfWork;
@end

@implementation PlayerMapper

- (id)initWithDomainClass:(Class)cls {
    self = [super init];
    if (self) {
        self.tableName = @"player";
        self.selectColumnList = @"objectID, firstName, lastName, team";
        self.columnNames = @[
            @"objectID",
            @"firstName",
            @"lastName",
            @"team",
        ];
        self.persistentPropertyNames = @[
            @"objectID",
            @"firstName",
            @"lastName",
            @"team",
        ];
    }
    return self;
}


- (void)loadFields:(FMResultSet *)rs inObject:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(rs);
    TDAssert(obj);
    TDAssert(self.unitOfWork);
    
    {
        NSNumber *objectID = [rs objectForColumnName:@"objectID"];
        [obj setValue:objectID forKey:@"objectID"];
    }
    
    {
        NSString *firstName = [rs stringForColumn:@"firstName"];
        [obj setValue:firstName forKey:@"firstName"];
    }
    
    {
        NSString *lastName = [rs stringForColumn:@"lastName"];
        [obj setValue:lastName forKey:@"lastName"];
    }
    
    {
        NSNumber *objID = [rs objectForColumnName:@"team"];
        DomainObject *team = [self.unitOfWork objectForID:objID];
        if (!team) {
            MISMapper *mapper = [self.unitOfWork mapperForDomainClass:[Team class]];
            team = [mapper findObject:objID];
        }
        [obj setValue:team forKey:@"team"];
    }

}


- (void)performInsert:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj);
    TDAssert(self.unitOfWork);
    if (!obj.objectID) return;
    
    NSString *sql = @"INSERT INTO player (objectID, firstName, lastName, team) VALUES (?, ?, ?, ?)";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];
    
    {
        NSNumber *objectID = [obj valueForKey:@"objectID"];
        [args addObject:objectID];
    }
    
    {
        NSString *firstName = [obj valueForKey:@"firstName"];
        [args addObject:firstName];
    }
    
    {
        NSString *lastName = [obj valueForKey:@"lastName"];
        [args addObject:lastName];
    }
    
    {
        DomainObject *team = [obj valueForKey:@"team"];
        [args addObject:team.objectID];
    }

    BOOL success = NO;
    @try {
        success = [self.database executeUpdate:sql withArgumentsInArray:args];
    }
    @catch (NSException *ex) {
        NSLog(@"%@", ex);
    }
    @finally {
        
    }
    
    if (!success) return;

}


- (void)update:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj);
    TDAssert(self.unitOfWork);
    if (!obj.objectID) return;
    
    NSString *sql = @"UPDATE player SET objectID = ?, firstName = ?, lastName = ?, team = ? WHERE objectID = ?";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];
    
    {
        NSNumber *objectID = [obj valueForKey:@"objectID"];
        [args addObject:objectID];
    }
    
    {
        NSString *firstName = [obj valueForKey:@"firstName"];
        [args addObject:firstName];
    }
    
    {
        NSString *lastName = [obj valueForKey:@"lastName"];
        [args addObject:lastName];
    }
    
    {
        DomainObject *team = [obj valueForKey:@"team"];
        [args addObject:team.objectID];
    }

    BOOL success = NO;
    @try {
        success = [self.database executeUpdate:sql withArgumentsInArray:args];
    }
    @catch (NSException *ex) {
        NSLog(@"%@", ex);
    }
    @finally {
        
    }
    
    if (!success) return;

}

@end
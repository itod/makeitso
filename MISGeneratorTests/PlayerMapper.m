#import "PlayerMapper.h"
#import "Player.h"

#import <fmdb/FMResultSet.h>
#import <fmdb/FMDatabase.h>

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
    }
    return self;
}


- (void)loadFields:(FMResultSet *)rs inObject:(DomainObject *)obj {
    TDAssertDatabaseThread();

    {
        NSNumber *val = [rs objectForColumnName:@"objectID"];
        [obj setValue:val forKey:@"objectID"];
    }
    {
        NSString *val = [rs stringForColumn:@"firstName"];
        [obj setValue:val forKey:@"firstName"];
    }
    {
        NSString *val = [rs stringForColumn:@"lastName"];
        [obj setValue:val forKey:@"lastName"];
    }
    {
        DomainObject *val = [rs objectForColumnName:@"team"];
        [obj setValue:val forKey:@"team"];
    }
}


- (void)performInsert:(DomainObject *)obj {
    TDAssertDatabaseThread();
    if (!obj.objectID) return;
    
    NSString *sql = @"INSERT INTO player (objectID, firstName, lastName, team) VALUES (?, ?, ?, ?)";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];

    {
        NSNumber *val = [obj valueForKey:@"objectID"];
        [args addObject:val];
    }
    {
        NSString *val = [obj valueForKey:@"firstName"];
        [args addObject:val];
    }
    {
        NSString *val = [obj valueForKey:@"lastName"];
        [args addObject:val];
    }
    {
        DomainObject *val = [obj valueForKey:@"team"];
        [args addObject:val];
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
}


- (void)update:(DomainObject *)obj {
    TDAssertDatabaseThread();
    if (!obj.objectID) return;
    
    NSString *sql = @"UPDATE player SET objectID = ?, firstName = ?, lastName = ?, team = ? WHERE objectID = ?";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];

    {
        NSNumber *val = [obj valueForKey:@"objectID"];
        [args addObject:val];
    }
    {
        NSString *val = [obj valueForKey:@"firstName"];
        [args addObject:val];
    }
    {
        NSString *val = [obj valueForKey:@"lastName"];
        [args addObject:val];
    }
    {
        DomainObject *val = [obj valueForKey:@"team"];
        [args addObject:val];
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
}


@end
#import "TeamMapper.h"
#import "Team.h"

#import <fmdb/FMResultSet.h>
#import <fmdb/FMDatabase.h>

@implementation TeamMapper

- (id)initWithDomainClass:(Class)cls {
    self = [super init];
    if (self) {
        self.tableName = @"team";
        self.selectColumnList = @"objectID, name, players";
        self.columnNames = @[
            @"objectID",
            @"name",
            @"players",
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
        NSString *val = [rs stringForColumn:@"name"];
        [obj setValue:val forKey:@"name"];
    }
    {
        DomainObject *val = [rs objectForColumnName:@"players"];
        [obj setValue:val forKey:@"players"];
    }
}


- (void)performInsert:(DomainObject *)obj {
    TDAssertDatabaseThread();
    if (!obj.objectID) return;
    
    NSString *sql = @"INSERT INTO team (objectID, name, players) VALUES (?, ?, ?)";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];

    {
        NSNumber *val = [obj valueForKey:@"objectID"];
        [args addObject:val];
    }
    {
        NSString *val = [obj valueForKey:@"name"];
        [args addObject:val];
    }
    {
        DomainObject *val = [obj valueForKey:@"players"];
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
    
    NSString *sql = @"UPDATE team SET objectID = ?, name = ?, players = ? WHERE objectID = ?";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];

    {
        NSNumber *val = [obj valueForKey:@"objectID"];
        [args addObject:val];
    }
    {
        NSString *val = [obj valueForKey:@"name"];
        [args addObject:val];
    }
    {
        DomainObject *val = [obj valueForKey:@"players"];
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
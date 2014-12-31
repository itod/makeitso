#import "TeamMapper.h"
#import "Team.h"

#import <fmdb/FMResultSet.h>
#import <fmdb/FMDatabase.h>

@implementation TeamMapper

- (id)initWithDomainClass:(Class)cls {
    self = [super init];
    if (self) {
        self.tableName = @"team";
        self.selectColumnList = @"objectID, name";
        self.columnNames = @[
            @"objectID",
            @"name",
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
}


- (NSNumber *)insert:(DomainObject *)obj withObjectID:(NSNumber *)objID {
    TDAssertDatabaseThread();
    TDAssert(!obj.objectID);
    if (!objID) return nil;;
    
    NSString *sql = @"INSERT INTO team (objectID, name) VALUES (?, ?)";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];

    {
        NSNumber *val = [obj valueForKey:@"objectID"];
        [args addObject:val];
    }
    {
        obj.objectID = objID;
        NSString *val = objID;
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
    
    return obj.objectID;
}


- (void)update:(DomainObject *)obj {
    TDAssertDatabaseThread();
    if (!obj.objectID) return;
    
    NSString *sql = @"UPDATE team SET objectID = ?, name = ? WHERE objectID = ?";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];

    {
        NSNumber *val = [obj valueForKey:@"objectID"];
        [args addObject:val];
    }
    {
        NSString *val = [obj valueForKey:@"name"];
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
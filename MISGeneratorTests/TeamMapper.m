#import "TeamMapper.h"
#import "Team.h"

#import "Player.h"

#import "MISUnitOfWork.h"

#import <fmdb/FMResultSet.h>
#import <fmdb/FMDatabase.h>

@interface MISMapper ()
@property (nonatomic, retain) MISUnitOfWork *unitOfWork;
@end

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
    TDAssert(rs);
    TDAssert(obj);
    TDAssert(self.unitOfWork);

    {
        NSNumber *objectID = [rs objectForColumnName:@"objectID"];
        [obj setValue:objectID forKey:@"objectID"];
    }

    {
        NSString *name = [rs stringForColumn:@"name"];
        [obj setValue:name forKey:@"name"];
    }

    {
        MISMapper *mapper = [self.unitOfWork mapperForDomainClass:[Player class]];
        NSArray *objIDs = nil; // TODO
        NSMutableArray *players = [NSMutableArray array];
        
        for (NSNumber *objID in objIDs) {
            DomainObject *obj = [mapper findObject:objID];
            if (obj) [players addObject:obj];
        }
        
        [obj setValue:players forKey:@"players"];
    }

}


- (void)performInsert:(DomainObject *)obj {
    TDAssertDatabaseThread();
    TDAssert(obj);
    TDAssert(self.unitOfWork);
    if (!obj.objectID) return;
    
    NSString *sql = @"INSERT INTO team (objectID, name, players) VALUES (?, ?, ?)";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];

    {
        NSNumber *objectID = [obj valueForKey:@"objectID"];
        [args addObject:objectID];
    }

    {
        NSString *name = [obj valueForKey:@"name"];
        [args addObject:name];
    }

    {
        
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
    TDAssert(obj);
    TDAssert(self.unitOfWork);
    if (!obj.objectID) return;
    
    NSString *sql = @"UPDATE team SET objectID = ?, name = ?, players = ? WHERE objectID = ?";
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:[self.columnNames count]];

    {
        NSNumber *objectID = [obj valueForKey:@"objectID"];
        [args addObject:objectID];
    }

    {
        NSString *name = [obj valueForKey:@"name"];
        [args addObject:name];
    }

    {
        
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
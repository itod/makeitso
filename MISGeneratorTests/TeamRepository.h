#import <MakeItSo/Repository.h>

@class Team;

@interface TeamRepository : Repository

- (Team *)findTeam:(NSNumber *)objID;
@end

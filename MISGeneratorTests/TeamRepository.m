#import "TeamRepository.h"
#import "Team.h"

@implementation TeamRepository

- (Team *)findTeam:(NSNumber *)objID {
    return (Team *)[self find:objID];
}

@end

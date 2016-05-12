#import "TeamRepository.h"
#import "Team.h"

@implementation TeamRepository

- (Class)domainClass {
    return [Team class];
}


- (Team *)findTeam:(NSNumber *)objID {
    return (Team *)[self find:objID];
}

@end

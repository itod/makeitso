#import "PlayerRepository.h"
#import "Player.h"

@implementation PlayerRepository

- (Class)domainClass {
    return [Player class];
}


- (Player *)findPlayer:(NSNumber *)objID {
    return (Player *)[self find:objID];
}

@end

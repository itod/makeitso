#import "PlayerRepository.h"
#import "Player.h"

@implementation PlayerRepository

- (Player *)findPlayer:(NSNumber *)objID {
    return (Player *)[self find:objID];
}

@end

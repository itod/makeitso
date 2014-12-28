#import <MakeItSo/Repository.h>

@class Player;

@interface PlayerRepository : Repository

- (Player *)findPlayer:(NSNumber *)objID;
@end

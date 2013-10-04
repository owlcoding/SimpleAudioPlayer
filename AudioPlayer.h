//
//  SimpleAudioPlayer.h
//
//  Created by Kender on 9/11/10.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^CompletionBlock)(BOOL);

@interface AVAudioPlayerWithCompletionBlock : AVAudioPlayer
@property (nonatomic, copy) CompletionBlock completionBlock;
@end

@interface SimpleAudioPlayer : NSObject <AVAudioPlayerDelegate> {
	NSMutableSet *players;
}


+ (SimpleAudioPlayer *)shared;
+ (AVAudioPlayer *)playFile:(NSString *)name;
+ (AVAudioPlayer *)playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops;
+ (void)stopPlayer:(AVAudioPlayer *)player;
+ (void)stopAllPlayers;

+ (AVAudioPlayer *) playFile:(NSString *)name withCompletionBlock:(CompletionBlock)completion ;
+ (AVAudioPlayer *) playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops withCompletionBlock:(CompletionBlock)completion;

@end

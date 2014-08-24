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

/*
 The method
 + (AVAudioPlayer *) playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops withCompletionBlock:(CompletionBlock)completion;
 
 the loops parameter works like this:
 any negative number - sound keeps playing in a loop over and over
 0, 1 - sound is played once
 2, 3, etc - sound is played twice, 3 times, etc-times :)
 */
+ (AVAudioPlayer *) playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops withCompletionBlock:(CompletionBlock)completion;

/*
 The methods below just call the
 playFile: volume: loops: withCompletionBlock:
 */
+ (AVAudioPlayer *)playFile:(NSString *)name;
+ (AVAudioPlayer *)playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops;
+ (AVAudioPlayer *) playFile:(NSString *)name withCompletionBlock:(CompletionBlock)completion ;

+ (AVAudioPlayer *) playLoopedFile:(NSString *) name;

+ (void)stopPlayer:(AVAudioPlayer *)player;
+ (void)stopAllPlayers;
+ (void) playFiles:(NSArray *) filesList withCompletionBlock:(CompletionBlock) completion;


@end

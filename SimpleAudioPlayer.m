//
//  SimpleAudioPlayer.m
//
//  Created by Kender on 9/11/10.
//

#import "SimpleAudioPlayer.h"

@implementation AVAudioPlayerWithCompletionBlock

@end

@implementation SimpleAudioPlayer

static SimpleAudioPlayer *sharedInstance = nil;

+ (void)initialize
{
    if (sharedInstance == nil)
        sharedInstance = [[self alloc] init];
}

+ (SimpleAudioPlayer *)shared
{
    //Already set by +initialize.
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone
{
    //Usually already set by +initialize.
    @synchronized(self) {
        if (sharedInstance) {
            //The caller expects to receive a new object, so implicitly retain it
            //to balance out the eventual release message.
            return sharedInstance;
        } else {
            //When not already set, +initialize is our caller.
            //It's creating the shared instance, let this go through.
            return [super allocWithZone:zone];
        }
    }
}

- (id)init
{
    //If sharedInstance is nil, +initialize is our caller, so initialize the instance.
    //If it is not nil, simply return the instance without re-initializing it.
    if (sharedInstance == nil) {
		self = [super init];
		if (self) {
            //Initialize the instance here.
			players = [NSMutableSet setWithCapacity:1];
        }
    }
    return self;
}


- (AVAudioPlayer *) playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops withCompletionBlock:(CompletionBlock)completion
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
	if(!filePath) {
		return nil;
	}
	
	NSError *error = nil;
	NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
	AVAudioPlayerWithCompletionBlock *player = [[AVAudioPlayerWithCompletionBlock alloc] initWithContentsOfURL:fileURL error:&error];
	player.volume = vol;
	player.numberOfLoops = loops;
	// Retain and play
	if(player) {
		[players addObject:player];
		player.delegate = self;
        player.completionBlock = completion;
		[player play];
		return player;
	}
	return nil;
    
}
- (void) playFiles:(NSArray*) filesList withCompletionBlock:(CompletionBlock) completion
{
    __block int idx = 0;
    void(^playBlock)();
    playBlock = ^() {
        if (idx >= filesList.count) {
            if (completion) {
                completion ( YES );
            }
            return ;
        }
        [self playFile:filesList[idx] withCompletionBlock:^(BOOL completed) {
            playBlock ();
        }];
        idx ++;
    };
    
    playBlock ();
}

- (AVAudioPlayer *)playFile:(NSString *)name {
    
    return [self playFile:name volume:1.0f loops:0 withCompletionBlock:nil];
}
- (AVAudioPlayer *) playLoopedFile:(NSString *) name {
    return [self playFile:name volume:1.0f loops:-1];
}
- (AVAudioPlayer *) playFile:(NSString *)name withCompletionBlock:(CompletionBlock)completion
{
    return [self playFile:name volume:1.0f loops:0 withCompletionBlock:completion];
}

- (AVAudioPlayer *)playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops {
    
	return [self playFile:name volume:vol loops:loops withCompletionBlock:nil];
}


- (void)stopPlayer:(AVAudioPlayer *)player {
	if([players containsObject:player]) {
		player.delegate = nil;
		[players removeObject:player];
		[player stop];
	}
}

- (void)stopAllPlayers {
    NSSet *pls = [NSSet setWithSet:players];
    for (AVAudioPlayer *p in pls) {
        [self stopPlayer:p];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayerWithCompletionBlock *)player successfully:(BOOL)completed {
    
	if (player.completionBlock) {
        player.completionBlock ( completed );
    }
	player.delegate = nil;
	[players removeObject:player];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	//TRC_DBG(@"audioPlayerDecodeErrorDidOccur %@", error);
	player.delegate = nil;
	[players removeObject:player];
}

+ (AVAudioPlayer *)playFile:(NSString *)name {
	return [[SimpleAudioPlayer shared] playFile:name];
}

+ (AVAudioPlayer *)playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops {
	return [[SimpleAudioPlayer shared] playFile:name volume:vol loops:loops];
}
+ (AVAudioPlayer *) playFile:(NSString *)name withCompletionBlock:(CompletionBlock)completion
{
    return [[SimpleAudioPlayer shared] playFile:name withCompletionBlock:completion];
}
+ (AVAudioPlayer *) playFile:(NSString *)name volume:(CGFloat)vol loops:(NSInteger)loops withCompletionBlock:(CompletionBlock)completion
{
    return [[SimpleAudioPlayer shared] playFile:name volume:vol loops:loops withCompletionBlock:completion];
}
+ (AVAudioPlayer *) playLoopedFile:(NSString *) name
{
    return [[SimpleAudioPlayer shared] playLoopedFile:name];
}
+ (void)stopPlayer:(AVAudioPlayer *)player {
	return [[SimpleAudioPlayer shared] stopPlayer:player];
}
+ (void)stopAllPlayers {
    return [[SimpleAudioPlayer shared] stopAllPlayers];
}
+ (void) playFiles:(NSArray *)filesList withCompletionBlock:(CompletionBlock)completion
{
    [[SimpleAudioPlayer shared] playFiles:filesList withCompletionBlock:completion];
}
@end

//
//  RRAudioEngine.m
//  RatRace
//
//  Created by Jon Como on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRAudioEngine.h"

@interface RRAudioEngine () <AVAudioPlayerDelegate>
{
    
}

@end

@implementation RRAudioEngine
{
    NSMutableArray *sounds;
}

+(RRAudioEngine *)sharedEngine
{
    static RRAudioEngine *sharedEngine;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[self alloc] init];
    });
    
    return sharedEngine;
}

-(id)init
{
    if (self = [super init]) {
        //init
        sounds = [NSMutableArray array];
    }
    
    return self;
}

-(void)initializeAudioSession
{
//    NSError *activationError = nil;
//    BOOL success = [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
//    if (!success) { /* handle the error in activationError */ }
//    
//    NSError *setCategoryError = nil;
//    BOOL catSuccess = [[AVAudioSession sharedInstance]
//                    setCategory: AVAudioSessionCategoryAmbient
//                    error: &setCategoryError];
//    
//    if (!catSuccess) { /* handle the error in setCategoryError */ }
}

-(RRAudioPlayer *)playSoundNamed:(NSString *)soundName extension:(NSString *)ext loop:(BOOL)loop
{
    if (self.muted) return nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:ext];
    
    NSError *soundError;
    
    RRAudioPlayer *soundPlayer = [[RRAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&soundError];
    
    if (soundError)
    {
        NSLog(@"Error: %@" , soundError);
        return nil;
    }
    
    soundPlayer.delegate = self;
    
    soundPlayer.numberOfLoops = loop ? -1 : 0;
    
    [sounds addObject:soundPlayer];
    
    [soundPlayer play];
    
    return soundPlayer;
}

-(void)stopSoundName:(NSString *)soundName
{
    for (RRAudioPlayer *player in sounds)
    {
        NSString *name = [[player.url URLByDeletingPathExtension] lastPathComponent];
        if ([name isEqualToString:soundName])
        {
            [player stop];
            [sounds removeObject:player];
            NSLog(@"Stopped sound: %@", soundName);
        }
    }
}

-(void)stopAllSounds
{
    for (RRAudioPlayer *player in sounds){
        [player stop];
    }
    
    [sounds removeAllObjects];
}

-(void)mute:(BOOL)mute
{
    self.muted = mute;
    
    if (mute)
    {
        [self stopAllSounds];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [sounds removeObject:player];
}

@end

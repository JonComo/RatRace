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
    
    if (([[NSUserDefaults standardUserDefaults] boolForKey:MUTE_MUSIC] && loop == YES) || self.muted){
        soundPlayer.volume = 0;
    }
    
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

-(void)toggleMusic
{
    float newVolume;
    
    for (RRAudioPlayer *player in sounds){
        if (player.numberOfLoops == -1)
        {
            //found music
            newVolume = (player.volume == 0) ? 1 : 0;
            player.volume = newVolume;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:(newVolume == 0) ? YES : NO forKey:MUTE_MUSIC];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [sounds removeObject:player];
}

-(BOOL)musicMuted
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:MUTE_MUSIC];
}

@end

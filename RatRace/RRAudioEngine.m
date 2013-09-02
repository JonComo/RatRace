//
//  RRAudioEngine.m
//  RatRace
//
//  Created by Jon Como on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRAudioEngine.h"

#import <AVFoundation/AVFoundation.h>

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
    NSError *activationError = nil;
    BOOL success = [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    if (!success) { /* handle the error in activationError */ }
    
    NSError *setCategoryError = nil;
    BOOL catSuccess = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryAmbient
                    error: &setCategoryError];
    
    if (!catSuccess) { /* handle the error in setCategoryError */ }
}

-(void)playSoundNamed:(NSString *)soundName extension:(NSString *)ext loop:(BOOL)loop
{
    NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:ext];
    
    AVAudioPlayer *soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    soundPlayer.numberOfLoops = loop ? -1 : 0;
    
    [sounds addObject:soundPlayer];
    
    [soundPlayer play];
}

-(void)stopAllSounds
{
    for (AVAudioPlayer *player in sounds)
    {
        [player stop];
    }
}

@end

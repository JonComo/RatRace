//
//  RRAudioEngine.h
//  RatRace
//
//  Created by Jon Como on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRAudioEngine : NSObject

+(RRAudioEngine *)sharedEngine;

-(void)initializeAudioSession;

-(void)playSoundNamed:(NSString *)soundName extension:(NSString *)ext loop:(BOOL)loop;

-(void)stopAllSounds;

@end

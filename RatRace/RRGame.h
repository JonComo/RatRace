//
//  RRGame.h
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RRPlayer.h"

@interface RRGame : NSObject

@property int day;

@property (nonatomic, strong) NSMutableArray *availableItems;
@property (nonatomic, strong) NSMutableArray *availableLocations;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) RRPlayer *player;

+(RRGame *)sharedGame;

-(void)newGame;

-(void)changeToLocation:(NSString *)newLocation;

@end
//
//  RRGame.h
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RRPlayer.h"
#import "RRBank.h"

#define RRDiamondCountChanged @"diamondCountChanged"

@interface RRGame : NSObject

@property int day;

@property (nonatomic, strong) NSMutableArray *events;

@property (nonatomic, strong) NSMutableArray *availableItems;
@property (nonatomic, strong) NSMutableArray *availableLocations;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) RRPlayer *player;

@property (nonatomic, strong) RRBank *bank;

+(RRGame *)sharedGame;

-(void)newGame;

-(void)changeToLocation:(NSString *)newLocation;

- (void)advanceDay;

@end
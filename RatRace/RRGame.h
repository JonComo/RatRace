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
#import "RRPack.h"
#import "RREventManager.h"
#import "RRStats.h"

#define RRDiamondCountChanged @"diamondCountChanged"

@interface RRGame : NSObject

@property int day;
@property int dayMaximum;

@property (nonatomic, strong) RRPack *pack;

@property (nonatomic, strong) NSArray *availableItems;
@property (nonatomic, strong) NSArray *availableLocations;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) RRPlayer *player;
@property (nonatomic, strong) RRBank *bank;
@property (nonatomic, strong) RREventManager *eventManager;
@property (nonatomic, strong) RRStats *stats;

+(RRGame *)sharedGame;

-(void)newGame;
- (void)advanceDay;

-(void)randomizeValues;

-(RRItem *)itemWithName:(NSString *)name;
-(void)randomizeItem:(RRItem *)item;

@end
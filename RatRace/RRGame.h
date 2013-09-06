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
#import "RREventManager.h"

#define RRDiamondCountChanged @"diamondCountChanged"

@interface RRGame : NSObject

@property int day;

@property (nonatomic, strong) NSMutableArray *availableItems;
@property (nonatomic, strong) NSMutableArray *availableLocations;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) RRPlayer *player;
@property (nonatomic, strong) RRBank *bank;
@property (nonatomic, strong) RREventManager *eventManager;

+(RRGame *)sharedGame;

-(void)newGame;

- (void)advanceDay;

-(void)randomizeItemValue:(RRItem *)item;

-(void)changeItemWithName:(NSString *)name toValue:(float)value;

@end
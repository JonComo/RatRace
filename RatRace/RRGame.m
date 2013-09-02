//
//  RRGame.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRGame.h"

#import "RRItem.h"

@implementation RRGame

+(RRGame *)sharedGame
{
    static RRGame *sharedGame;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGame = [RRGame new];
    });
    
    return sharedGame;
}

-(void)newGame
{
    self.player = nil;
    self.player = [RRPlayer new];
    
    //reset properties
    self.day = 0;
    
    self.availableItems = [@[[RRItem item:@"Weed" value:20], [RRItem item:@"Crack" value:35]] mutableCopy];
    self.availableLocations = [@[@"Italy", @"USA", @"Germany", @"France", @"Greece"] mutableCopy];
}

-(void)changeToLocation:(NSString *)newLocation
{
    self.location = newLocation;
    [self randomizeValues];
}

-(void)randomizeValues
{
    for (RRItem *item in self.availableItems)
    {
        item.value = 20 + arc4random()%30;
    }
}

@end

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
    
    self.bank = [RRBank new];
    self.bank.loan = 0;
    self.bank.interest = .02;
    
    self.availableItems = [@[[RRItem item:@"Yellow Diamond" value:20], [RRItem item:@"White Diamond" value:35],[RRItem item:@"Blue Diamond" value:86], [RRItem item:@"Cognac Diamond" value:95],[RRItem item:@"Black Diamond" value:86]] mutableCopy];
    
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

- (void)advanceDay
{
    self.day +=1;
    [self.bank incrementLoan];
    
}

@end

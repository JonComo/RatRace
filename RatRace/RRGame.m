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
    self.events = nil;
    self.events = [NSMutableArray array];
    
    self.day = 1;
    
    self.bank = nil;
    self.bank = [RRBank bankWithLoanAmount:0 withInterest:0.02 limit:2000];
    
    self.availableItems = [@[[RRItem item:@"Yellow Diamond" value:200], [RRItem item:@"White Diamond" value:350],[RRItem item:@"Blue Diamond" value:860], [RRItem item:@"Cognac Diamond" value:950],[RRItem item:@"Black Diamond" value:4600], [RRItem item:@"Blood Diamond" value:9500]] mutableCopy];
    
    self.availableLocations = [@[@"Switzerland", @"Dubai", @"Greece", @"Russia", @"South Africa", @"Thailand"] mutableCopy];
    
    self.location = self.availableLocations[0];
    
    [self randomizeValues];
}

-(void)randomizeValues
{
    for (RRItem *item in self.availableItems)
    {
        item.value = item.valueInitial + arc4random()%((int)(item.valueInitial*.2));
    }
}

- (void)advanceDay
{
    self.day +=1;
    [self.bank incrementLoan];
    [self randomizeValues];
}

@end

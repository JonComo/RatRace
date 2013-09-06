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
    //reset/alloc properties
    
    self.player = nil;
    self.player = [RRPlayer new];
    
    self.eventManager = nil;
    self.eventManager = [RREventManager new];
    
    self.day = 1;
    
    self.bank = nil;
    self.bank = [RRBank bankWithLoanAmount:0 withInterest:0.02 limit:2000];
    
    self.availableItems = [@[[RRItem item:@"Yellow Diamond" value:100], [RRItem item:@"White Diamond" value:100],[RRItem item:@"Blue Diamond" value:100], [RRItem item:@"Cognac Diamond" value:100],[RRItem item:@"Black Diamond" value:100], [RRItem item:@"Blood Diamond" value:100]] mutableCopy];
    
    self.availableLocations = [@[@"Switzerland", @"Dubai", @"Greece", @"Russia", @"South Africa", @"Thailand"] mutableCopy];
    
    self.location = self.availableLocations[0];
    
    [self randomizeValues];
}

-(void)randomizeValues
{
    for (RRItem *item in self.availableItems)
    {
        [self randomizeItemValue:item];
    }
}

-(void)randomizeItemValue:(RRItem *)item
{
    // + arc4random()%((int)(item.valueInitial*.2));
    item.value = item.valueInitial;
}

-(void)changeItemWithName:(NSString *)name toValue:(float)value
{
    for (RRItem *item in [RRGame sharedGame].availableItems)
    {
        if ([item.name isEqualToString:name])
        {
            item.valueInitial = value;
        }
    }
}

- (void)advanceDay
{
    self.day +=1;
    [self.bank incrementLoan];
    [self randomizeValues];
    
    [self.eventManager addRandomEvent];
    [self.eventManager run];
}

@end

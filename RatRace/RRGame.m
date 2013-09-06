//
//  RRGame.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRGame.h"

#import "RRItem.h"

#import "RRPackDiamond.h"

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
    
    self.pack = nil;
    self.pack = [[RRPackDiamond alloc] init];
    
    self.eventManager = nil;
    self.eventManager = [RREventManager new];
    
    self.day = 1;
    
    self.bank = nil;
    self.bank = [RRBank bankWithLoanAmount:0 withInterest:0.02 limit:2000];
    
    self.availableItems = [@[[RRItem item:@"Cognac Diamond" value:200], [RRItem item:@"Yellow Diamond" value:400], [RRItem item:@"Black Diamond" value:650], [RRItem item:@"Blue Diamond" value:1000], [RRItem item:@"White Diamond" value:2000], [RRItem item:@"Blood Diamond" value:10000]] mutableCopy];
    
    self.availableLocations = [@[@"Switzerland", @"Dubai", @"Greece", @"Russia", @"South Africa", @"Thailand"] mutableCopy];
    
    self.location = self.availableLocations[0];
    
    [self randomizeValues];
}

-(void)randomizeValues
{
    for (RRItem *item in self.availableItems){
        [self randomizeItemValue:item];
    }
}

-(void)randomizeItemValue:(RRItem *)item
{
    item.value = item.valueInitial + arc4random()%((int)(item.valueInitial*.2));
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
    
    [self.eventManager addRandomEvent];
    
    [self randomizeValues];
}

@end
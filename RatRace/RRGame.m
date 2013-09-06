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
    
    self.availableItems = [self.pack items];
    self.availableLocations = [self.pack locations];
    
    self.location = self.availableLocations[0];
    
    [self randomizeValues];
}

-(void)randomizeValues
{
    for (RRItem *item in self.availableItems){
        [self randomizeItem:item];
    }
}

-(void)randomizeItem:(RRItem *)item
{
    float initValue = item.valueInitial;
    float addedValue = (float)(arc4random()%((int)(initValue*.2)));
    
    item.value = initValue + addedValue;
}

-(RRItem *)itemWithName:(NSString *)name
{
    for (RRItem *item in [RRGame sharedGame].availableItems){
        if ([item.name isEqualToString:name]){
            return item;
        }
    }
    
    return nil;
}

- (void)advanceDay
{
    self.day +=1;
    
    [self.bank incrementLoan];
    
    [self.eventManager addRandomEvent];
    
    [self randomizeValues];
}

@end
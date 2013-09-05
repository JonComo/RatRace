//
//  RREvent.m
//  RatRace
//
//  Created by Jon Como on 9/4/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RREvent.h"

#import "RRGame.h"

@implementation RREvent
{
    int daysProgressed;
}

+(RREvent *)eventWithInitialBlock:(InitialBlock)initBlock numberOfDays:(int)duration endingBlock:(EndingBlock)endBlock
{
    RREvent *newEvent = [[self alloc] init];
    
    newEvent.initBlock = initBlock;
    newEvent.endBlock = endBlock;
    
    newEvent.duration = duration;
    
    return newEvent;
}

-(id)init
{
    if (self = [super init]) {
        //init
        daysProgressed = 0;
    }
    
    return self;
}

-(void)runStart
{
    if (self.initBlock)
        self.initBlock();
}

-(void)runEnd
{
    if (daysProgressed >= self.duration){
        if (self.endBlock)
            self.endBlock();
    }
}

-(void)progressDay
{
    if (daysProgressed == 0){
        //first day, run it
        [self runStart];
    }
    
    [self landedOnLocation:[RRGame sharedGame].location];
    
    daysProgressed ++;
    
    if (daysProgressed >= self.duration){
        [self runEnd];
        [[RRGame sharedGame].eventManager removeEvent:self];
    }
}

-(void)landedOnLocation:(NSString *)location
{
    if ([location isEqualToString:self.location])
    {
        if (self.locationBlock) self.locationBlock();
    }else{
        if (self.wrongLocation) self.wrongLocation();
    }
}

@end
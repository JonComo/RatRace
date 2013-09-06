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
    daysProgressed ++;
    
    if (daysProgressed == 1){
        //first day, run it
        [self runStart];
    }
    
    if (daysProgressed >= self.duration){
        [self runEnd];
        self.isFinished = YES;
    }
}

-(void)landedOnLocation:(NSString *)location
{
    BOOL rightLocation = [location isEqualToString:self.location];
    if (self.locationBlock) self.locationBlock(rightLocation);
}

@end
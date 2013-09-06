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

+(RREvent *)eventWithName:(NSString *)name initialBlock:(InitialBlock)initBlock numberOfDays:(int)duration endingBlock:(EndingBlock)endBlock
{
    RREvent *newEvent = [[self alloc] init];
    
    newEvent.name = name;
    newEvent.initBlock = initBlock;
    newEvent.endBlock = endBlock;
    newEvent.duration = duration;
    
    NSLog(@"Event created: %@", name);
    
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

-(void)dealloc
{
    NSLog(@"Event removed %@", self.name);
}

-(void)runStart
{
    if (self.initBlock)
        self.initBlock();
}

-(void)runEnd
{
    if (self.endBlock)
        self.endBlock();
}

-(void)progressDay
{
    daysProgressed ++;
    
    if (daysProgressed == 1){
        [self runStart];
    }
    
    if (daysProgressed > self.duration){
        [self runEnd];
        self.isFinished = YES;
    }
    
    if (!self.isFinished){
        [self landedOnLocation:[RRGame sharedGame].location];
    }
}

-(void)landedOnLocation:(NSString *)location
{
    BOOL rightLocation = [location isEqualToString:self.location];
    if (self.locationBlock) self.locationBlock(rightLocation);
}

-(NSString *)description
{
    NSString *original = [super description];
    
    return [NSString stringWithFormat:@"%@ - %@", original, self.name];
}

@end
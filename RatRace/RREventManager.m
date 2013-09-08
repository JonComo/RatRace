//
//  RREventManager.m
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RREventManager.h"

#import "RRGame.h"

@implementation RREventManager
{
    NSMutableArray *events;
}

-(id)init
{
    if (self = [super init]) {
        //init
        events = [NSMutableArray array];
    }
    
    return self;
}

-(void)run
{
//    if (events.count == 0) return;
//    
//    RREvent *event = events[0];
    
    for (int i = 0; i<events.count; i++)
    {
        RREvent *event = events[i];
        [event progressDay];
        
        if (event.isFinished)
            [events removeObject:event];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RREventUpdateUI object:nil];
}

-(void)addRandomEvent
{
    NSLog(@"ADD RANDOM");
    if (events.count >= 3) return;
    
    RREvent *event = [[RRGame sharedGame].pack randomEvent];
    
    if (event)
        [self addEvent:event];
}

-(void)addEvent:(RREvent *)event
{
    BOOL matchesExisting = NO;
    
    for (RREvent *running in events){
        if ([event.name isEqualToString:running.name]) matchesExisting = YES;
    }
    
    if (!matchesExisting)
        [events addObject:event];
}

@end

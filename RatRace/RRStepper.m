//
//  RRStepper.m
//  RatRace
//
//  Created by Jon Como on 9/4/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRStepper.h"

@implementation RRStepper
{
    NSTimer *timerShouldStep;
    NSTimer *timerIncrement;
    
    ActionHandler _action;
}

+(RRStepper *)sharedStepper
{
    static RRStepper *sharedStepper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStepper = [[self alloc] init];
    });
    
    return sharedStepper;
}

-(void)buttonDownWithAction:(ActionHandler)action
{
    if (!action) return;
    
    //run it once instantly
    action();
    
    _action = action;
    
    [timerShouldStep invalidate];
    timerShouldStep = nil;
    
    timerShouldStep = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startStep) userInfo:nil repeats:NO];
}

-(void)startStep
{
    [timerShouldStep invalidate];
    timerShouldStep = nil;
    
    timerIncrement = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(step) userInfo:nil repeats:YES];
}

-(void)step
{
    if (_action) _action();
}

-(void)buttonUp
{
    [timerShouldStep invalidate];
    timerShouldStep = nil;
    
    [timerIncrement invalidate];
    timerIncrement = nil;
}

@end

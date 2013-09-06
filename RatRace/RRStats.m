//
//  RRStats.m
//  RatRace
//
//  Created by Jon Como on 9/6/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRStats.h"

#import "RRGame.h"

@implementation RRStats

-(id)init
{
    if (self = [super init]) {
        //init
        _dayLogs = [NSMutableArray array];
        
        [[RRGame sharedGame] addObserver:self forKeyPath:@"day" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //Log the day
    NSDictionary *dayStats = [self statsForDay];
    
    [self.dayLogs addObject:dayStats];
}

-(NSDictionary *)statsForDay
{
    int day = [RRGame sharedGame].day;
    float money = [RRGame sharedGame].player.money;
    float loan = [RRGame sharedGame].bank.loan;
    
    NSMutableDictionary *dayLog = [NSMutableDictionary dictionary];
    
    dayLog[@"day"] = @(day);
    dayLog[@"money"] = @(money);
    dayLog[@"loan"] = @(loan);
    
    for (RRItem *item in [RRGame sharedGame].availableItems){
        dayLog[item.name] = @(item.value);
    }
    
    return dayLog;
}

@end
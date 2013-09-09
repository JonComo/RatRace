//
//  RRStats.m
//  RatRace
//
//  Created by Jon Como on 9/6/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRStats.h"

#import "RRGame.h"

#import "RRStats.h"

#define DAY @"day"

@implementation RRStats

-(id)init
{
    if (self = [super init]) {
        //init
        _dayLogs = [NSMutableArray array];
    }
    
    return self;
}

-(void)logDay
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
        
        NSMutableDictionary *countryValues = [NSMutableDictionary dictionary];
        for (NSString *location in [RRGame sharedGame].availableLocations)
        {
            countryValues[location] = @([item valueInLocation:location]);
        }
        
        dayLog[item.name] = countryValues;
    }
    
    return dayLog;
}

-(NSArray *)currentLogs
{
    return [self.dayLogs arrayByAddingObject:[self statsForDay]];
}

@end
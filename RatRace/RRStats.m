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

-(void)archiveStats
{
    //[RRGame sharedGame].pack details[RRPackDetailName]
    
    NSDictionary *gameDict = @{@"date" : [NSDate date],
                               @"daysPlayed" : @([RRGame sharedGame].day),
                               @"money" : @([RRGame sharedGame].player.money),
                               @"moneyFormatted" : [RRGame format:[RRGame sharedGame].player.money],
                               @"loan" : @([RRGame sharedGame].bank.loan),
                               //@"packName" : [RRGame sharedGame].pack details[RRPackDetailName],
                               @"logs": [self currentLogs]};
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameDict];
    
    NSError *error;
    [data writeToURL:[self uniqueURLWithFilename:@"stats"] options:NSDataWritingAtomic error:&error];
    
    if (error)
        NSLog(@"Error archiving stats: %@", error);
}

+(NSArray *)history
{
    NSArray *filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ARCHIVE_PATH error:nil];
    
    NSMutableArray *logs = [NSMutableArray array];
    
    for (NSString *filename in filenames)
    {
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", ARCHIVE_PATH, filename]];
        
        NSDictionary *log = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [logs addObject:log];
    }
    
    return logs;
}

-(NSURL *)uniqueURLWithFilename:(NSString *)filename
{
    NSString *documents = ARCHIVE_PATH;
    
    int count = 0;
    
    NSURL *URL;
    
    do {
        URL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@%i", documents, filename, count]];
        count ++;
    } while ([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    return URL;
}

@end
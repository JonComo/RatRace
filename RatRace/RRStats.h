//
//  RRStats.h
//  RatRace
//
//  Created by Jon Como on 9/6/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARCHIVE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface RRStats : NSObject

@property (nonatomic, strong) NSMutableArray *dayLogs;

-(NSDictionary *)statsForDay;
-(void)logDay;

-(NSArray *)currentLogs;

-(void)archiveStats;

+(NSArray *)history;

@end
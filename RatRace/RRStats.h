//
//  RRStats.h
//  RatRace
//
//  Created by Jon Como on 9/6/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRStats : NSObject

@property (nonatomic, strong) NSMutableArray *dayLogs;

-(NSDictionary *)statsForDay;

@end
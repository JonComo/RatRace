//
//  RREvent.h
//  RatRace
//
//  Created by Jon Como on 9/4/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^InitialBlock)(void);
typedef void (^EndingBlock)(void);

@interface RREvent : NSObject

@property (copy) InitialBlock initBlock;
@property (copy) EndingBlock endBlock;

@property int duration;

+(RREvent *)eventWithInitialBlock:(InitialBlock)initBlock numberOfDays:(int)duration endingBlock:(EndingBlock)endBlock;

-(void)runStart;
-(void)runEnd;

-(void)progressDay;

@end
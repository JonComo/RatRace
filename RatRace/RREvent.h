//
//  RREvent.h
//  RatRace
//
//  Created by Jon Como on 9/4/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    RREventTypeSeize,
    RREventTypeInterest
} RREventType;

typedef void (^InitialBlock)(void);
typedef void (^EndingBlock)(void);
typedef void (^LocationBlock)(void);

@interface RREvent : NSObject

@property (copy) InitialBlock initBlock;
@property (copy) EndingBlock endBlock;
@property (copy) LocationBlock locationBlock;
@property (copy) LocationBlock wrongLocation;

@property RREventType type;
@property int duration;
@property (nonatomic, strong) NSString *location;

+(RREvent *)eventWithInitialBlock:(InitialBlock)initBlock numberOfDays:(int)duration endingBlock:(EndingBlock)endBlock;

-(void)runStart;
-(void)runEnd;

-(void)progressDay;

-(void)landedOnLocation:(NSString *)location;

@end
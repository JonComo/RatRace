//
//  RREvent.h
//  RatRace
//
//  Created by Jon Como on 9/4/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RREventShowMessageNotification @"eventShowMessage"
#define RREventTitle @"title"
#define RREventMessage @"message"
#define RREventImage @"image"

#define RREventUpdateUI @"eventUpdateUI"

typedef void (^InitialBlock)(void);
typedef void (^EndingBlock)(void);
typedef void (^LocationBlock)(BOOL rightLocation);

@interface RREvent : NSObject

@property (copy) InitialBlock initBlock;
@property (copy) EndingBlock endBlock;
@property (copy) LocationBlock locationBlock;

@property (nonatomic, strong) NSString *name;
@property int duration;
@property (copy) NSString *location;
@property BOOL isFinished;

+(RREvent *)eventWithName:(NSString *)name initialBlock:(InitialBlock)initBlock numberOfDays:(int)duration endingBlock:(EndingBlock)endBlock;

-(void)runStart;
-(void)runEnd;
-(void)progressDay;

@end
//
//  RRStepper.h
//  RatRace
//
//  Created by Jon Como on 9/4/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ActionHandler)(void);

@interface RRStepper : NSObject

+(RRStepper *)sharedStepper;

-(void)buttonDownWithAction:(ActionHandler)action;
-(void)buttonUp;

@end
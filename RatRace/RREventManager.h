//
//  RREventManager.h
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RREvent.h"

@interface RREventManager : NSObject

-(void)addRandomEvent;
-(void)run;

@end
//
//  RRPack.h
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RREvent.h"

#import "RRItem.h"

//details

#define RRPackDetailName @"name"
#define RRPackDetailDescription @"description"
#define RRPackDetailImage @"image"

@interface RRPack : NSObject

+(NSDictionary *)details;

-(RREvent *)randomEvent;
-(NSArray *)locations;
-(NSArray *)items;

@end
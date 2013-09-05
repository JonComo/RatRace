//
//  RRPlayer.h
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RRItem.h"

@interface RRPlayer : NSObject

@property float money;
@property (nonatomic, strong) NSString *name;
@property int inventoryCapacity;

-(int)inventoryCount;

@end

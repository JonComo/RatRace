//
//  RRPlayer.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPlayer.h"

@implementation RRPlayer

-(id)init
{
    if (self = [super init]) {
        //init
        _money = 50.0;
        _inventory = [NSMutableArray array];
        _inventoryCapacity = 100;
    }
    
    return self;
}

@end

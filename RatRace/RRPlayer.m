//
//  RRPlayer.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPlayer.h"

#import "RRGame.h"

@implementation RRPlayer

-(id)init
{
    if (self = [super init]) {
        //init
        _money = 2000.0;
        _inventoryCapacity = 25;
    }
    
    return self;
}

-(int)inventoryCount
{
    int count = 0;
    
    for (RRItem *item in [RRGame sharedGame].availableItems){
        count += item.count;
    }
    
    return count;
}

@end

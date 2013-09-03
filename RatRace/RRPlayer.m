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
        _money = 2000.00;
        _inventory = [NSMutableArray array];
        _inventoryCapacity = 100;
    }
    
    return self;
}

-(RRItem *)itemMatchingItem:(RRItem *)item
{
    RRItem *match;
    
    for (RRItem *playerItem in self.inventory)
    {
        if ([playerItem.name isEqualToString:item.name])
        {
            match = playerItem;
        }
    }
    
    return match;
}

@end

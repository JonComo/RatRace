//
//  RRItem.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRItem.h"

@implementation RRItem

+(RRItem *)item:(NSString *)name value:(float)value
{
    RRItem *item = [RRItem new];
    item.name = name;
    item.value = value;
    item.valueInitial = value;
    
    return item;
}

@end

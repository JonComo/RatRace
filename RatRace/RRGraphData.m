//
//  RRGraphData.m
//  RatRace
//
//  Created by Jon Como on 9/7/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRGraphData.h"

@implementation RRGraphData

-(id)init
{
    if (self = [super init]) {
        //init
        _data = [NSMutableArray array];
        _color = [UIColor orangeColor];
    }
    
    return self;
}

@end
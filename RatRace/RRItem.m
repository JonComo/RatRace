//
//  RRItem.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRItem.h"

#import "PerlinNoise.h"

#import "RRGame.h"

@implementation RRItem
{
    PerlinNoise *noise;
    int seed;
}

+(RRItem *)item:(NSString *)name value:(float)value
{
    RRItem *item = [RRItem new];
    item.name = name;
    item.value = value;
    item.valueInitial = value;
    item.count = 0;
    
    return item;
}

-(id)init
{
    if (self = [super init]) {
        //init
        seed = arc4random()%INT_MAX;
        
        noise = [[PerlinNoise alloc] initWithSeed:seed];
        noise.octaves = 4;
        noise.frequency = 1;
        noise.persistence = 0.5;
        noise.scale = 1;
    }
    
    return self;
}

-(void)randomizeValue
{
    
    self.value = [self valueInLocation:@"same"];
}

-(void)noiseForLocation:(NSString *)location
{
    int locationUniqueSeed = seed * location.length;
    noise.seed = locationUniqueSeed;
}

-(float)valueInLocation:(NSString *)location
{
    [self noiseForLocation:location];
    
    float point = ((float)[RRGame sharedGame].day);
    float perlin = [noise perlin1DValueForPoint:point];
    
    return self.valueInitial + perlin*self.valueInitial;
}

@end

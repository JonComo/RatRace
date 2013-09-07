//
//  RRStatsView.m
//  RatRace
//
//  Created by Jon Como on 9/6/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRStatsView.h"

#import "RRGame.h"

@implementation RRStatsView
{
    NSMutableArray *logs;
    float xStep;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setStats:(RRStats *)stats
{
    _stats = stats;
    
    logs = [stats.dayLogs mutableCopy];
    [logs addObject:[stats statsForDay]];
    
    xStep = self.frame.size.width / [RRGame sharedGame].dayMaximum;
    
    //render stats
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    NSMutableArray *itemsToGraph = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    
    for (RRItem *item in [RRGame sharedGame].availableItems)
    {
        [itemsToGraph addObject:item.name];
        [colors addObject:[UIColor greenColor]];
    }
    
    [itemsToGraph addObjectsFromArray:@[@"money", @"loan"]];
    [colors addObjectsFromArray:@[[UIColor whiteColor], [UIColor redColor]]];
    
    [self graphKeys:itemsToGraph withColors:colors inRect:rect];
    
    //draw grid
    
    [self drawGridWithNumbers:CGPointMake([RRGame sharedGame].dayMaximum, 8) inRect:rect];
}

-(void)drawGridWithNumbers:(CGPoint)count inRect:(CGRect)rect
{
    float x = 0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i<=count.x; i++)
    {
        
        [path moveToPoint:CGPointMake(x, 0)];
        [path addLineToPoint:CGPointMake(x, rect.size.height)];
        
        x += xStep;
    }
    
    float y = 0;
    float yStep = rect.size.height / count.y;
    
    for (int i = 0; i<=count.y; i++)
    {
        
        [path moveToPoint:CGPointMake(0, y)];
        [path addLineToPoint:CGPointMake(rect.size.width, y)];
        
        y += yStep;
    }
    
    [[UIColor darkGrayColor] setStroke];
    
    [path stroke];
}

-(void)graphKeys:(NSArray *)keys withColors:(NSArray *)colors inRect:(CGRect)rect
{
    //find total min and max of keys values
    CGPoint totalMinMax = CGPointMake(FLT_MAX, FLT_MIN);
    
    for (NSString *key in keys)
    {
        CGPoint keyMinMax = [self rangeOfKey:key];
        
        if (keyMinMax.x < totalMinMax.x) totalMinMax.x = keyMinMax.x;
        if (keyMinMax.y > totalMinMax.y) totalMinMax.y = keyMinMax.y;
    }
    
    for (int i = 0; i<keys.count; i++)
    {
        NSString *key = keys[i];
        UIColor *color = colors[i];
        
        [self graphKey:key withColor:color verticalRange:CGPointMake(totalMinMax.y, totalMinMax.x) inRect:rect];
    }
}

-(void)graphKey:(NSString *)key withColor:(UIColor *)color verticalRange:(CGPoint)vertRange inRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float x = 0;
    
    BOOL setFirstPoint = NO;
    
    for (NSDictionary *dayLog in logs)
    {
        float value = [dayLog[key] floatValue];
        float yPlot = [self mapValue:value range:vertRange range:CGPointMake(0, rect.size.height)];
        
        if (!setFirstPoint)
        {
            [path moveToPoint:CGPointMake(x, yPlot)];
            setFirstPoint = YES;
        }else{
            [path addLineToPoint:CGPointMake(x, yPlot)];
        }
        
        x += xStep;
    }
    
    [color setStroke];
    [path stroke];
}

-(float)mapValue:(float)value range:(CGPoint)range1 range:(CGPoint)range2
{
    return range2.x + (value - range1.x) * (range2.y - range2.x) / (range1.y - range1.x);
}

-(CGPoint)rangeOfKey:(NSString *)key
{
    float minRange = FLT_MAX;
    float maxRange = FLT_MIN;
    
    for (NSDictionary *dayLog in logs)
    {
        float money = [dayLog[key] floatValue];
        
        if (minRange > money) minRange = money;
        if (maxRange < money) maxRange = money;
    }
    
    return CGPointMake(minRange, maxRange);
}


@end

//
//  RRGraphView.m
//  RatRace
//
//  Created by Jon Como on 9/6/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRGraphView.h"

#import "RRGame.h"

@implementation RRGraphView
{
    float vertMin;
    float vertMax;
    
    float xStep;
}

-(void)graph:(RRGraphData *)data
{
    if (!self.graphData)
        self.graphData = [NSMutableArray array];
    
    [self.graphData addObject:data];
}

-(void)clear
{
    [self.graphData removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //draw grid
    
    //removeLabels
    for (UILabel *label in self.subviews)
        [label removeFromSuperview];
    
    if (self.drawGrid)
        [self drawGridWithNumbers:CGPointMake([RRGame sharedGame].dayMaximum, 8) inRect:rect];
    
    [self calculateTotalMinMax];
    
    [self graphAllDataInRect:rect];
}

-(void)drawGridWithNumbers:(CGPoint)count inRect:(CGRect)rect
{
    float x = 0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i<=count.x; i++)
    {
        
        [path moveToPoint:CGPointMake((int)x, 0)];
        [path addLineToPoint:CGPointMake((int)x, rect.size.height)];
        
        x += xStep;
    }
    
    float y = 0;
    float yStep = rect.size.height / count.y;
    
    for (int i = 0; i<=count.y; i++)
    {
        
        [path moveToPoint:CGPointMake(0, (int)y)];
        [path addLineToPoint:CGPointMake(rect.size.width, (int)y)];
        
        y += yStep;
    }
    
    [[UIColor darkGrayColor] setStroke];
    
    [path stroke];
}

-(void)calculateTotalMinMax
{
    //find total min and max of keys values
    vertMin = FLT_MAX;
    vertMax = FLT_MIN;
    NSUInteger maxSteps = INT_MIN;
    
    for (RRGraphData *data in self.graphData){
        if (data.data.count > maxSteps) {
            maxSteps = data.data.count;
        }
        
        for (NSNumber *number in data.data)
        {
            float value = [number floatValue];
            
            if (vertMin > value) vertMin = value;
            if (vertMax < value) vertMax = value;
        }
    }
}

-(void)graphAllDataInRect:(CGRect)rect
{
    xStep = rect.size.width / self.xRange;
    
    for (RRGraphData *data in self.graphData){
        [self graphData:data verticalRange:CGPointMake(vertMax, vertMin) inRect:rect];
    }
    
    [self drawKeyInRect:rect];
}

-(void)drawKeyInRect:(CGRect)rect
{
    int labelStep = 5;
    
    for (RRGraphData *data in self.graphData)
    {
        if (data.name){
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelStep, rect.size.height-20, 70, 20)];
            [nameLabel setFont:[UIFont fontWithName:@"Avenir" size:10]];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textColor = data.color;
            nameLabel.text = data.name;
            [self addSubview:nameLabel];
            
            labelStep += 30 + 5;
        }
    }
}

-(void)graphData:(RRGraphData *)data verticalRange:(CGPoint)vertRange inRect:(CGRect)rect
{
    if (data.data.count < 2) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float x = 0;
    
    BOOL setFirstPoint = NO;
    
    for (NSNumber *number in data.data)
    {
        float value = [number floatValue];
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
    
    [data.color setStroke];
    [path stroke];
}

-(float)mapValue:(float)value range:(CGPoint)range1 range:(CGPoint)range2
{
    return range2.x + (value - range1.x) * (range2.y - range2.x) / (range1.y - range1.x);
}

@end

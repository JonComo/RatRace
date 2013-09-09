//
//  RRGraphView.h
//  RatRace
//
//  Created by Jon Como on 9/6/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RRGraphData.h"

@interface RRGraphView : UIView

@property (nonatomic, strong) NSMutableArray *graphData;

@property int xRange;
@property BOOL drawGrid;

-(void)graph:(RRGraphData *)data;
-(void)clear;

@end
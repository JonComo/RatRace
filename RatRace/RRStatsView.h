//
//  RRStatsView.h
//  RatRace
//
//  Created by Jon Como on 9/6/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RRStats.h"

@interface RRStatsView : UIView

@property (nonatomic, weak) RRStats *stats;

@property int xRange;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *colors;

@property BOOL drawGrid;

@end
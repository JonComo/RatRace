//
//  RRHistoryCell.m
//  RatRace
//
//  Created by Jon Como on 9/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRHistoryCell.h"
#import "RRGraphView.h"

static NSDateFormatter *formatter;

@implementation RRHistoryCell
{
    __weak IBOutlet UIView *viewSeperator;
    __weak IBOutlet RRGraphView *viewGraph;
    __weak IBOutlet UILabel *labelStats;
}

-(void)setShowSeperator:(BOOL)showSeperator
{
    _showSeperator = showSeperator;
    
    viewSeperator.hidden = !showSeperator;
}

-(void)setGameStats:(NSDictionary *)gameStats
{
    _gameStats = gameStats;
    
    if (!formatter){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterLongStyle];
    }
    
    labelStats.text = [NSString stringWithFormat:@"%@ %@", gameStats[@"moneyFormatted"], [formatter stringFromDate:gameStats[@"date"]]];
    
    [self graph];
}

-(void)graph
{
    [viewGraph clear];
    
    viewGraph.backgroundColor = [UIColor blackColor];
    
    RRGraphData *money = [RRGraphData new];
    RRGraphData *loan = [RRGraphData new];
    
    money.color = [UIColor whiteColor];
    loan.color = [UIColor redColor];
    
    money.name = @"money";
    loan.name = @"loan";
    
    for (NSDictionary *dayLog in self.gameStats[@"logs"])
    {
        NSNumber *moneyValue = dayLog[@"money"];
        NSNumber *loanValue = dayLog[@"loan"];
        
        [money.data addObject:moneyValue];
        [loan.data addObject:loanValue];
    }
    
    [viewGraph graph:money];
    [viewGraph graph:loan];
    
    viewGraph.xRange = MAX(0, 20);
    
    viewGraph.drawGrid = NO;
    
    [viewGraph setNeedsDisplay];
}

@end

//
//  RRDiamondCell.m
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRDiamondCell.h"

#import "RRGame.h"

#import "RRAudioEngine.h"

#import "RRButtonSound.h"

#import "RRStepper.h"

#import "RRGraphics.h"

#import "RRGraphView.h"

@implementation RRDiamondCell
{
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UILabel *labelPrice;
    __weak IBOutlet UIImageView *imageViewHasItem;
    
    __weak IBOutlet RRButtonSound *buttonSellOne;
    __weak IBOutlet RRButtonSound *buttonBuyOne;
    
    __weak IBOutlet UILabel *labelItemCount;
    
    double previousValue;
    
    __weak IBOutlet RRGraphView *statsView;
}

-(void)graphWithColor:(UIColor *)color
{
    [statsView clear];
    
    int daysToGraph = 5;
    
    RRGraphData *data = [RRGraphData new];
    
    NSArray *toGraph = [[RRGame sharedGame].stats currentLogs];
    
    int startIndex = toGraph.count - daysToGraph - 1;
    if (startIndex < 0) startIndex = 0;
    
    for (int i = startIndex; i < toGraph.count; i++)
    {
        NSDictionary *dayLog = toGraph[i];
        
        NSDictionary *countryValues = dayLog[self.item.name];
        
        NSNumber *numberInCountry = countryValues[[RRGame sharedGame].location];
        
        [data.data addObject:numberInCountry];
    }
    
    data.color = color;
    
    [statsView graph:data];
    
    statsView.xRange = daysToGraph;
    
    [statsView setNeedsDisplay];
}

-(void)setItem:(RRItem *)item
{
    _item = item;
    
    labelName.text = item.name;
    
    UIColor *interfaceColor;
    
    if (item.selected)
    {
        interfaceColor = [UIColor blackColor];
            
        self.backgroundColor = [UIColor whiteColor];
        //imageViewBackground.image = [RRGraphics resizableBorderImage];
        
        imageViewHasItem.image = [UIImage imageNamed:@"diamondBlack"];
        
        labelName.textColor = interfaceColor;
        labelPrice.textColor = interfaceColor;
        labelItemCount.textColor = interfaceColor;
        
        [buttonBuyOne setTitleColor:interfaceColor forState:UIControlStateNormal];
        [buttonSellOne setTitleColor:interfaceColor forState:UIControlStateNormal];
        
    }else{
        
        self.backgroundColor = [UIColor blackColor];
        //imageViewBackground.image = nil;
        
        interfaceColor = [UIColor whiteColor];
        
        imageViewHasItem.image = [UIImage imageNamed:@"diamondWhite"];
        
        labelName.textColor = interfaceColor;
        labelPrice.textColor = interfaceColor;
        labelItemCount.textColor = interfaceColor;
        
        [buttonBuyOne setTitleColor:interfaceColor forState:UIControlStateNormal];
        [buttonSellOne setTitleColor:interfaceColor forState:UIControlStateNormal];
    }
    
    [self graphWithColor:interfaceColor];
    
    [self calculate];
}

-(void)calculate
{
    int numberOwned = self.item.count;
    
    labelItemCount.text = [NSString stringWithFormat:@"%i", numberOwned];
    imageViewHasItem.hidden = self.item.count == 0 ? YES : NO;
    labelPrice.text = [RRGame format:self.item.value];
}

-(float)calculatePercent
{
    float total = 0;
    for (NSDictionary *dayLog in [RRGame sharedGame].stats.dayLogs)
    {
        float value = [dayLog[self.item.name] floatValue];
        total += value;
    }
    
    float average = total / MAX(1, [RRGame sharedGame].stats.dayLogs.count);
    
    float difference = average - self.item.value;
    
    float percent = difference / self.item.value * 100;
    
    return percent;
}

- (IBAction)sellOne:(id)sender {
    previousValue = self.item.count;
    
    [[RRStepper sharedStepper] buttonDownWithAction:^{
        [self sell];
    }];
}

- (IBAction)buyOne:(id)sender {
    previousValue = self.item.count;
    
    [[RRStepper sharedStepper] buttonDownWithAction:^{
        [self buy];
    }];
}

- (IBAction)buyOneUp:(id)sender
{
    [[RRStepper sharedStepper] buttonUp];
    
    if (self.item.count != previousValue)
        [[RRAudioEngine sharedEngine] playSoundNamed:@"register" extension:@"wav" loop:NO];
}

- (IBAction)sellOneUp:(id)sender
{
    [[RRStepper sharedStepper] buttonUp];
    
    if (self.item.count != previousValue)
        [[RRAudioEngine sharedEngine] playSoundNamed:@"register" extension:@"wav" loop:NO];
}

-(void)buy
{
    if ([RRGame sharedGame].player.money < self.item.value)
    {
        NSLog(@"INSUFFICIENT FUNDS");
        [self animateLabel];

        return;
    }
    
    if ([RRGame sharedGame].player.inventoryCount >= [RRGame sharedGame].player.inventoryCapacity)
    {
        NSLog(@"NOT ENOUGH SPACE");
        [self animateLabel];
        
        return;
    }

    self.item.count ++;
    
    [RRGame sharedGame].player.money -= self.item.value;
    
    [self calculate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RRGameUpdateUI object:nil];
}

-(void)sell
{
    if (self.item.count <= 0)
    {
        self.item.count = 0;
        NSLog(@"YOU DONT HAVE THE ITEM");
        [self animateLabel];

        return;
    }
    
    self.item.count --;
    [RRGame sharedGame].player.money += self.item.value;
    
    [self calculate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RRGameUpdateUI object:nil];
}

-(void)animateLabel
{
    [UIView animateWithDuration:0.1 animations:^{
        labelItemCount.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        labelItemCount.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            labelItemCount.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
            labelItemCount.alpha = 1;
        } completion:^(BOOL finished) {
            
            
        }];
    }];
}

@end

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

#import "RRStatsView.h"

@implementation RRDiamondCell
{
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UILabel *labelPrice;
    __weak IBOutlet UIImageView *imageViewHasItem;
    
    __weak IBOutlet RRButtonSound *buttonSellOne;
    __weak IBOutlet RRButtonSound *buttonBuyOne;
    
    __weak IBOutlet UILabel *labelItemCount;
    
    double previousValue;
    
    __weak IBOutlet RRStatsView *statsView;
}

-(void)setItem:(RRItem *)item
{
    _item = item;
    
    labelName.text = item.name;
    
    statsView.stats = [RRGame sharedGame].stats;
    statsView.keys = @[self.item.name];
    
    statsView.xRange = [RRGame sharedGame].day;
    
    if (item.selected)
    {
        UIColor *interfaceColor = [UIColor blackColor];
        
        statsView.colors = @[interfaceColor];
        [statsView setNeedsDisplay];
            
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
        
        UIColor *interfaceColor = [UIColor whiteColor];
        
        statsView.colors = @[interfaceColor];
        [statsView setNeedsDisplay];
        
        imageViewHasItem.image = [UIImage imageNamed:@"diamondWhite"];
        
        labelName.textColor = interfaceColor;
        labelPrice.textColor = interfaceColor;
        labelItemCount.textColor = interfaceColor;
        
        [buttonBuyOne setTitleColor:interfaceColor forState:UIControlStateNormal];
        [buttonSellOne setTitleColor:interfaceColor forState:UIControlStateNormal];
    }
    
    [self calculate];
}

-(void)calculate
{
    int numberOwned = self.item.count;
    
    labelItemCount.text = [NSString stringWithFormat:@"%i", numberOwned];
    imageViewHasItem.hidden = self.item.count == 0 ? YES : NO;
    labelPrice.text = [[RRGame sharedGame] format:self.item.value];
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

-(int)amountAvailable
{
    return floor([RRGame sharedGame].player.money / self.item.value);
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
    int amountAvailable = [self amountAvailable];
    
    if (amountAvailable == 0)
    {
        NSLog(@"INSUFFICIENT FUNDS");
        [self animateLabel];

        return;
    }

    self.item.count ++;
    
    [RRGame sharedGame].player.money -= self.item.value;
    
    [self calculate];
}

-(void)sell
{
    if (self.item.count == 0)
    {
        NSLog(@"YOU DONT HAVE THE ITEM");
        [self animateLabel];

        return;
    }
    
    self.item.count --;
    [RRGame sharedGame].player.money += self.item.value;
    
    [self calculate];
}

-(void)countChangedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RRDiamondCountChanged object:nil];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

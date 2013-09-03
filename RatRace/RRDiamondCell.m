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

@implementation RRDiamondCell
{
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UILabel *labelPrice;
    __weak IBOutlet UIImageView *imageViewHasItem;
    
    __weak IBOutlet RRButtonSound *buttonBuyAll;
    __weak IBOutlet RRButtonSound *buttonSellAll;
}

-(void)setItem:(RRItem *)item
{
    imageViewHasItem.hidden = !item.hasItem;
    labelName.text = item.name;
    labelPrice.text = [NSString stringWithFormat:@"$%.2f", item.value];
    
    if (item.selected)
    {
        labelName.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor lightGrayColor];
        labelPrice.textColor = [UIColor whiteColor];
    }else{
        labelName.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        labelPrice.textColor = [UIColor blackColor];
    }
    
    _item = item;
}

- (IBAction)buyAll:(id)sender
{
    if ([RRGame sharedGame].player.money < self.item.value)
    {
        NSLog(@"INSUFFICIENT FUNDS");
        return;
    }
    
    self.item.hasItem = YES;
    
    RRItem *boughtItem = [RRItem item:self.item.name value:self.item.value];
    
    [[RRGame sharedGame].player.inventory addObject:boughtItem];
    
    [RRGame sharedGame].player.money -= self.item.value;
    
    [[RRAudioEngine sharedEngine] playSoundNamed:@"register" extension:@"wav" loop:NO];
    
    NSLog(@"Inventory: %@", [RRGame sharedGame].player.inventory);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RRDiamondCountChanged object:nil];
}

- (IBAction)sellAll:(id)sender
{
    RRItem *matchingItem = [[RRGame sharedGame].player itemMatchingItem:self.item];
    
    if (matchingItem)
    {
        [[RRGame sharedGame].player.inventory removeObject:matchingItem];
        [RRGame sharedGame].player.money += self.item.value;
        
        [[RRAudioEngine sharedEngine] playSoundNamed:@"register" extension:@"wav" loop:NO];
    }
    
    RRItem *stillHas = [[RRGame sharedGame].player itemMatchingItem:self.item];
    
    if(!stillHas) self.item.hasItem = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RRDiamondCountChanged object:nil];
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

//
//  RRDiamondCell.m
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRDiamondCell.h"

@implementation RRDiamondCell
{
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UILabel *labelPrice;
    __weak IBOutlet UIImageView *imageViewHasItem;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  SMStatsView.m
//  Sim
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "SMStatsView.h"

#import "RRGame.h"

@implementation SMStatsView
{
    __weak IBOutlet UILabel *labelOutput;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        // Initialization code
        
        
    }
    
    return self;
}

-(void)setup
{
    [[RRGame sharedGame] addObserver:self forKeyPath:@"day" options:NSKeyValueObservingOptionNew context:NULL];
    [[RRGame sharedGame].player addObserver:self forKeyPath:@"money" options:NSKeyValueObservingOptionNew context:NULL];
    [[RRGame sharedGame].bank addObserver:self forKeyPath:@"loan" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self update];
}

-(void)update
{
    int days = [RRGame sharedGame].day;
    float money = [RRGame sharedGame].player.money;
    int inventory = [RRGame sharedGame].player.inventory.count;
    float loan = [RRGame sharedGame].bank.loan;

    self.days.text = [NSString stringWithFormat:@"Days:%d / 30", days];
    self.cash.text = [NSString stringWithFormat:@"Cash on Hand: $%.2f",money];
    self.balance.text = [NSString stringWithFormat:@"Loan Balance: $%.2f", loan];
    self.inventory.text = [NSString stringWithFormat:@"Inventory: %d / %d", inventory, [RRGame sharedGame].player.inventoryCapacity];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self update];
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

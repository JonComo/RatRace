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
    __weak IBOutlet UILabel *labelDays;
    __weak IBOutlet UILabel *labelInventory;
    __weak IBOutlet UILabel *labelCash;
    
    __weak IBOutlet UILabel *labelLocation;
    __weak IBOutlet UIImageView *imageViewLocation;
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
    [[RRGame sharedGame].player addObserver:self forKeyPath:@"inventoryCapacity" options:NSKeyValueObservingOptionNew context:NULL];
    [[RRGame sharedGame].bank addObserver:self forKeyPath:@"loan" options:NSKeyValueObservingOptionNew context:NULL];
    [[RRGame sharedGame] addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew context:NULL];
    [[RRGame sharedGame].bank addObserver:self forKeyPath:@"interest" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:RREventUpdateUI object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self update];
    }];
    
    [self update];
}

-(void)update
{
    int days = [RRGame sharedGame].day;
    float money = [RRGame sharedGame].player.money;
    int inventory = [[RRGame sharedGame].player inventoryCount];
    float loan = [RRGame sharedGame].bank.loan;
    float interest = [RRGame sharedGame].bank.interest;
    
    NSString *location = [RRGame sharedGame].location;

    labelDays.text = [NSString stringWithFormat:@"Days: %d / 30", days];
    labelCash.text = [NSString stringWithFormat:@"$%.2f (-$%.2f * %.1f%%)", money, loan, interest * 100];
    labelInventory.text = [NSString stringWithFormat:@"Inventory: %d / %d", inventory, [RRGame sharedGame].player.inventoryCapacity];
    
    imageViewLocation.image = [UIImage imageNamed:location];
    labelLocation.text = location;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self update];
}

@end

//
//  RREventManager.m
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RREventManager.h"

#import "RRGame.h"

@implementation RREventManager
{
    NSMutableArray *events;
    NSMutableArray *HUDQueue;
}

-(id)init
{
    if (self = [super init]) {
        //init
        events = [NSMutableArray array];
        HUDQueue = [NSMutableArray array];
    }
    
    return self;
}

-(void)run
{
    for (RREvent *event in events)
    {
        [event progressDay];
        [event landedOnLocation:[RRGame sharedGame].location];
    }
    
    //display huds now.
    [self displayNextHUD];
}

-(void)addRandomEvent
{
    [self randomWithChance:65 run:^{
        
        RRItem *changedItem = [RRGame sharedGame].availableItems[arc4random()%[RRGame sharedGame].availableItems.count];
        float initialValue = changedItem.valueInitial;
        float valueChange = (float)(arc4random()%((int)(changedItem.valueInitial*.65)));
        
        //valueChange = valueChange * (arc4random()%2) ? 1 : -1;
        
        NSString *occurence = valueChange > 0 ? @"destroyed" : @"created";
        NSString *change = valueChange > 0 ? @"increased" : @"decreased";
        
        NSString *randomLocation = [RRGame sharedGame].availableLocations[arc4random()%[RRGame sharedGame].availableLocations.count];
        
        float newValue = changedItem.value + valueChange;
        
        RREvent *locationEvent = [RREvent eventWithInitialBlock:^{
            
            [self addHUDWithTitle:[NSString stringWithFormat:@"Diamond mine %@!", occurence] detail:[NSString stringWithFormat:@"A large diamond mine was %@ in %@. The average value of %@s has %@ by $%.2f.", occurence, randomLocation, changedItem.name, change, valueChange] autoDismiss:NO image:[UIImage imageNamed:@"debeers"]];
            
        } numberOfDays:3 endingBlock:^{
            
            changedItem.value = initialValue;
            
            [self addHUDWithTitle:@"Price restored" detail:@"Diamond prices leveled out" autoDismiss:NO image:[UIImage imageNamed:@"debeers"]];
            
            NSLog(@"ENDED PRICE CHANGE");
        }];
        
        locationEvent.location = randomLocation;
        
        locationEvent.locationBlock = ^{
            changedItem.valueInitial = newValue;
            [[RRGame sharedGame] randomizeItemValue:changedItem];
            NSLog(@"RIGHT LOCATION, Original: %.2f NEW: %.2f", initialValue, newValue);
        };
        
        locationEvent.wrongLocation = ^{
            NSLog(@"WRONG LOCATOIN");
            changedItem.valueInitial = initialValue;
            [[RRGame sharedGame] randomizeItemValue:changedItem];
        };
        
        [self addEvent:locationEvent];
    }];
    
    return;
    
    [self randomWithChance:15 run:^{
        
        float interest = [RRGame sharedGame].bank.interest;
        float newInterest = MAX(0, interest + (float)(arc4random()%20)/100);
        UIImage *image = [UIImage imageNamed:@"suisse"];
        
        if (interest != newInterest)
        {
            
            RREvent *interestEvent = [RREvent eventWithInitialBlock:^{
                
                
                float previousInterest = [RRGame sharedGame].bank.interest;
                [RRGame sharedGame].bank.interest = MAX(0, interest + (float)(arc4random()%20)/100);
                
                NSString *change;
                
                if (previousInterest < [RRGame sharedGame].bank.interest)
                {
                    change = @"raised";
                }else{
                    change = @"lowered";
                }
                
                [self addHUDWithTitle:[NSString stringWithFormat:@"Bank interest %@!", change] detail:[NSString stringWithFormat:@"Swiss banks have %@ their interest rate to %.1f%%!", change, [RRGame sharedGame].bank.interest * 100] autoDismiss:NO image:image];
                
                
            } numberOfDays:4 endingBlock:^{
                
                NSString *change;
                
                if (interest < [RRGame sharedGame].bank.interest)
                {
                    change = @"lowered";
                }else{
                    change = @"raised";
                }
                
                [RRGame sharedGame].bank.interest = interest;
                
                [self addHUDWithTitle:[NSString stringWithFormat:@"Bank interest %@!", change] detail:[NSString stringWithFormat:@"Swiss banks have %@ their interest rate to %.1f%%!", change, [RRGame sharedGame].bank.interest * 100] autoDismiss:NO image:image];
            }];
            
            interestEvent.type = RREventTypeInterest;
            
            [self addEvent:interestEvent];
        }
    }];
    
    [self randomWithChance:15 run:^{
        
        if ([[RRGame sharedGame].player inventoryCount] == 0) return;
        
        NSMutableArray *itemsWithCounts = [NSMutableArray array];
        
        for (RRItem *item in [RRGame sharedGame].availableItems)
        {
            if (item.count > 0) [itemsWithCounts addObject:item];
        }
        
        RRItem *randomItem = itemsWithCounts[arc4random()%itemsWithCounts.count];
        
        int numberToTake = MAX(1, arc4random()%randomItem.count);
        
        RREvent *confiscate = [RREvent eventWithInitialBlock:^{
            
            randomItem.count -= numberToTake;
            
            NSLog(@"SEIZED: %i", numberToTake);
            
            [self addHUDWithTitle:@"Diamonds seized!" detail:[NSString stringWithFormat:@"Interpol has seized %i of your %@(s). Investigation number: %i revealed possible link to theivery.", numberToTake, randomItem.name, arc4random()%1000] autoDismiss:NO image:[UIImage imageNamed:@"badge"]];
            
        } numberOfDays:1 endingBlock:nil];
        
        confiscate.type = RREventTypeSeize;
        
        [self addEvent:confiscate];
    }];
    
    [self randomWithChance:15 run:^{
        
        int giftAmount = 1 + arc4random()%7;
        RRItem *giftedItem = [RRGame sharedGame].availableItems[arc4random()%[RRGame sharedGame].availableItems.count];
        
        RREvent *gift = [RREvent eventWithInitialBlock:^{
            
            giftedItem.count += giftAmount;
            
            [self addHUDWithTitle:@"Received diamonds!" detail:[NSString stringWithFormat:@"You've received %i %@(s) from a mysterious source.", giftAmount, giftedItem.name] autoDismiss:NO image:[UIImage imageNamed:@"diamond-in-hand"]];
            
        } numberOfDays:2+arc4random()%4 endingBlock:^{
            [self randomWithChance:20 run:^{
                //take back those diamonds!
                
                if (giftedItem.count >= giftAmount){
                    giftedItem.count -= giftAmount;
                    
                    [self addHUDWithTitle:@"Tainted gift!" detail:[NSString stringWithFormat:@"Your gift of %i %@(s) turned out to be stolen. They were seized.",giftAmount, giftedItem.name] autoDismiss:NO image:[UIImage imageNamed:@"badge"]];
                }
            }];
            
        }];
        
        [self addEvent:gift];
    }];
    
    [self randomWithChance:15 run:^{
        RREvent *inventoryPlus = [RREvent eventWithInitialBlock:^{
            int additionalSlots = 5 + arc4random()%25;
            
            [RRGame sharedGame].player.inventoryCapacity += additionalSlots;
            
            [self addHUDWithTitle:@"Bigger briefcase!" detail:[NSString stringWithFormat:@"You found a bigger briefcase. How much bigger? %i slots bigger!", additionalSlots] autoDismiss:NO image:[UIImage imageNamed:@"cut_diamonds"]];
        } numberOfDays:1 endingBlock:nil];
        
        [self addEvent:inventoryPlus];
    }];
}

-(void)removeEvent:(RREvent *)event
{
    [events removeObject:event];
}

-(void)randomWithChance:(int)chance run:(void(^)(void))block
{
    if (arc4random()%100 < chance)
    {
        if (block) block();
    }
}

-(void)addEvent:(RREvent *)event
{
    if ([RRGame sharedGame].events.count > 3) return;
    
    BOOL shouldAdd = YES;
    
    for (RREvent *currentEvent in [RRGame sharedGame].events){
        if (currentEvent.type == event.type)
        {
            shouldAdd = NO;
        }
    }
    
    if (shouldAdd){
        [[RRGame sharedGame].events addObject:event];
    }
}

-(void)addHUDWithTitle:(NSString *)title detail:(NSString *)detail autoDismiss:(BOOL)autoDismiss image:(UIImage *)image
{
    NSLog(@"SHOWING HUD: %@", title);
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = title;
    hud.detailsLabelText = detail;
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.color = [UIColor whiteColor];
    hud.labelFont = [UIFont fontWithName:@"Avenir" size:18];
    hud.detailsLabelFont = [UIFont fontWithName:@"Avenir" size:14];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 140)];
    imageView.image = image;
    hud.customView = imageView;
    
    if (autoDismiss)
    {
        [hud hide:YES afterDelay:3];
    }else{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD:)];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [hud addGestureRecognizer:tap];
        });
    }
    
    [HUDQueue addObject:hud];
}

-(void)displayNextHUD
{
    if (HUDQueue.count == 0) return;
    
    MBProgressHUD *hudToDisplay = HUDQueue[0];
    
    NSLog(@"HUD: %@", hudToDisplay.labelText);
    
    [HUDQueue removeObject:hudToDisplay];
    
    [self performSelector:@selector(hideHUD:) withObject:nil afterDelay:2];
}

-(void)hideHUD:(UITapGestureRecognizer *)tap
{
    //[MBProgressHUD hideAllHUDsForView:self.viewForHUD animated:YES];
    
    [HUDQueue removeObjectAtIndex:0];
    
    [self displayNextHUD];
}

@end

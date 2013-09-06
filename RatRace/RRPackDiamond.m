//
//  RRPackDiamond.m
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPackDiamond.h"

#import "RRGame.h"

@implementation RRPackDiamond

-(NSArray *)items
{
    return @[[RRItem item:@"Cognac Diamond" value:200], [RRItem item:@"Yellow Diamond" value:400], [RRItem item:@"Black Diamond" value:650], [RRItem item:@"Blue Diamond" value:1000], [RRItem item:@"White Diamond" value:2000], [RRItem item:@"Blood Diamond" value:10000]];
}

-(NSArray *)locations
{
    return @[@"Switzerland", @"Dubai", @"Greece", @"Russia", @"South Africa", @"Thailand"];
}

- (RREvent *)eventInventoryBoost
{
    //Inventory boost
    RREvent *inventoryPlus = [RREvent eventWithName:@"inventoryBoost" initialBlock:^{
        int additionalSlots = 5 + arc4random()%25;
        
        [RRGame sharedGame].player.inventoryCapacity += additionalSlots;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RREventShowMessageNotification object:nil userInfo:@{RREventTitle: @"Bigger briefcase!", RREventMessage : [NSString stringWithFormat:@"You found a bigger briefcase. How much bigger? %i slots bigger!", additionalSlots], RREventImage:[UIImage imageNamed:@"cut_diamonds"]}];
        
    } numberOfDays:1 endingBlock:nil];
    
    return inventoryPlus;
}

-(RREvent *)eventMineChange
{
    RRItem *changedItem = [RRGame sharedGame].availableItems[arc4random()%[RRGame sharedGame].availableItems.count];
    float initialValue = changedItem.valueInitial;
    
    NSString *itemName = [changedItem.name copy];
    
    if (initialValue == 0) return nil;
    
    float valueChange = (float)(arc4random()%((int)(changedItem.valueInitial*.60))) + changedItem.valueInitial*.20;
    
    valueChange = (arc4random()%2) ? valueChange * -1 : valueChange * -1;
    
    NSString *occurence = valueChange > 0 ? @"destroyed" : @"created";
    NSString *change = valueChange > 0 ? @"increased" : @"decreased";
    
    NSString *randomLocation = [[RRGame sharedGame].availableLocations[arc4random()%[RRGame sharedGame].availableLocations.count] copy];
    
    float newValue = changedItem.valueInitial + valueChange;
    
    RREvent *locationEvent = [RREvent eventWithName:@"mineChange" initialBlock:^{
        
        //[self addHUDWithTitle:[NSString stringWithFormat:@"Diamond mine %@!", occurence] detail:[NSString stringWithFormat:@"A large diamond mine was %@ in %@. The average value of %@s has %@ by $%.2f.", occurence, randomLocation, changedItem.name, change, valueChange] autoDismiss:NO image:[UIImage imageNamed:@"debeers"]];
        
        RRItem *item = [[RRGame sharedGame] itemWithName:itemName];
        item.valueInitial = newValue;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RREventShowMessageNotification object:nil userInfo:@{RREventTitle: [NSString stringWithFormat:@"Diamond mine %@!", occurence], RREventMessage : [NSString stringWithFormat:@"A large diamond mine was %@ in %@. The average value of %@s has %@ by $%.2f.", occurence, randomLocation, changedItem.name, change, ABS(valueChange)], RREventImage:[UIImage imageNamed:@"debeers"]}];
        
    } numberOfDays:2+arc4random()%3 endingBlock:^{
        
        RRItem *item = [[RRGame sharedGame] itemWithName:itemName];
        item.valueInitial = initialValue;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RREventShowMessageNotification object:nil userInfo:@{RREventTitle: @"Price restored!", RREventMessage : [NSString stringWithFormat:@"The market value of %@s has returned to normal.", changedItem.name], RREventImage:[UIImage imageNamed:@"debeers"]}];
        
        //[self addHUDWithTitle:@"Price restored!" detail:[NSString stringWithFormat:@"The market value of %@s has returned to normal in %@.", changedItem.name, randomLocation] autoDismiss:NO image:[UIImage imageNamed:@"debeers"]];
    }];
    
    locationEvent.locationBlock = ^(BOOL rightLocation)
    {
        NSLog(@"Location block: %i", rightLocation);
        RRItem *item = [[RRGame sharedGame] itemWithName:itemName];
        
        if (rightLocation){
            item.valueInitial = newValue;
        }else{
            item.valueInitial = initialValue;
        }
        
        [[RRGame sharedGame] randomizeItem:item];
    };
    
    locationEvent.location = randomLocation;
    
    return locationEvent;
}

-(RREvent *)eventInterest
{
    //Interest
    
    float interest = [RRGame sharedGame].bank.interest;
    float newInterest;
    do {
        newInterest = MAX(0, interest + (float)(arc4random()%20)/100);
    } while (newInterest == interest);
    
    newInterest = MAX(0, interest + (float)(arc4random()%20)/100);
    UIImage *image = [UIImage imageNamed:@"suisse"];
    
    RREvent *interestEvent = [RREvent eventWithName:@"interest" initialBlock:^{
        
        float previousInterest = [RRGame sharedGame].bank.interest;
        [RRGame sharedGame].bank.interest = MAX(0, interest + (float)(arc4random()%20)/100);
        
        NSString *change;
        
        if (previousInterest < [RRGame sharedGame].bank.interest)
        {
            change = @"raised";
        }else{
            change = @"lowered";
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RREventShowMessageNotification object:nil userInfo:@{RREventTitle: [NSString stringWithFormat:@"Bank interest %@!", change], RREventMessage : [NSString stringWithFormat:@"Swiss banks have %@ their interest rate to %.1f%%!", change, [RRGame sharedGame].bank.interest * 100], RREventImage : image}];
        
        
    } numberOfDays:4 endingBlock:^{
        
        NSString *change;
        
        if (interest < [RRGame sharedGame].bank.interest)
        {
            change = @"lowered";
        }else{
            change = @"raised";
        }
        
        [RRGame sharedGame].bank.interest = interest;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RREventShowMessageNotification object:nil userInfo:@{RREventTitle: [NSString stringWithFormat:@"Bank interest %@!", change], RREventMessage : [NSString stringWithFormat:@"Swiss banks have %@ their interest rate to %.1f%%!", change, [RRGame sharedGame].bank.interest * 100], RREventImage : image}];
    }];
    
    return interestEvent;
}

-(RREvent *)eventSeize
{
    if ([[RRGame sharedGame].player inventoryCount] == 0) return nil;
    
    NSMutableArray *itemsWithCounts = [NSMutableArray array];
    
    for (RRItem *item in [RRGame sharedGame].availableItems){
        if (item.count > 0) [itemsWithCounts addObject:item];
    }
    
    if (itemsWithCounts.count == 0) return nil;
    
    RRItem *randomItem = itemsWithCounts[arc4random()%itemsWithCounts.count];
    
    int numberToTake = MAX(1, arc4random()%randomItem.count);
    
    RREvent *confiscate = [RREvent eventWithName:@"seize" initialBlock:^{
        
        randomItem.count -= numberToTake;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RREventShowMessageNotification object:nil userInfo:@{RREventTitle: @"Diamonds seized!", RREventMessage : [NSString stringWithFormat:@"Interpol has seized %i of your %@(s). Investigation number: %i revealed possible link to theivery.", numberToTake, randomItem.name, arc4random()%100000], RREventImage : [UIImage imageNamed:@"badge"]}];
        
    } numberOfDays:1 endingBlock:nil];
    
    return confiscate;
}

-(RREvent *)eventGift
{
    int giftAmount = 1 + arc4random()%7;
    
    RRItem *giftedItem = [RRGame sharedGame].availableItems[arc4random()%[RRGame sharedGame].availableItems.count];
    
    RREvent *gift = [RREvent eventWithName:@"gift" initialBlock:^{
        
        giftedItem.count += giftAmount;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RREventShowMessageNotification object:nil userInfo:@{RREventTitle: @"Received diamonds!", RREventMessage : [NSString stringWithFormat:@"You've received %i %@(s) from a mysterious source.", giftAmount, giftedItem.name], RREventImage : [UIImage imageNamed:@"diamond-in-hand"]}];
        
    } numberOfDays:2+arc4random()%4 endingBlock:^{
        if (arc4random()%2)
        {
            //take back those diamonds!
            
            if (giftedItem.count > 0)
            {
                giftedItem.count = MAX(0, giftedItem.count - giftAmount);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RREventShowMessageNotification object:nil userInfo:@{RREventTitle: @"Tainted gift!", RREventMessage : [NSString stringWithFormat:@"Your gift of %i %@(s) has been seized. Possible connection to known theif.", giftAmount, giftedItem.name], RREventImage : [UIImage imageNamed:@"badge"]}];
            }
        };
    }];
    
    return gift;
}

-(RREvent *)randomEvent
{
    return [self eventMineChange];
    
    int rand = arc4random()%5;
    
    switch (rand) {
        case 0:
            return [self eventInventoryBoost];
            break;
        case 1:
            return [self eventMineChange];
            break;
        case 2:
            return [self eventInterest];
            break;
        case 3:
            return [self eventSeize];
            break;
        case 4:
            return [self eventGift];
            break;
            
        default:
            return nil;
            break;
    }
}

@end

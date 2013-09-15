//
//  RRPackCars.m
//  RatRace
//
//  Created by David de Jesus on 9/13/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPackCars.h"

@implementation RRPackCars

+(NSDictionary *)details
{
    return @{RRPackDetailName: @"The Luxury Car Merchant",
             RRPackDetailDescription: @"Buy and sell high end luxury cars around the world.",
             RRPackDetailImage : [UIImage imageNamed:@"diamondWhite"],
             RRPackClassObject: [RRPackCars class],
             RRPackDetailID : @"com.unmd76.theMerchant. - - -"};
}

-(NSArray *)items
{
    return @[[RRItem item:@"Porsche" value:70000], [RRItem item:@"Ferrari" value:112000], [RRItem item:@"Lamborghini" value:210000],[RRItem item:@"Aston Martin" value:250000],[RRItem item:@"Bugatti" value:350000]];
}

-(NSArray *)locations
{
    return @[@"Paris", @"Los Angeles", @"New York City", @"Tokyo", @"London", @"Amsterdam"];
}

-(RREvent *)randomEvent
{
    return nil;
}

@end

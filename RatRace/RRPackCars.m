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
    return @{RRPackDetailName: @"The Luxury Car Dealer",
             RRPackDetailDescription: @"Buy and sell high end luxury cars around the world.",
             RRPackDetailImage : [UIImage imageNamed:@"diamondWhite"],
             RRPackClassObject: [RRPackCars class],
             RRPackDetailID : @"com.unmd76.theMerchant. - - -"};
}

-(NSArray *)items
{
    return @[[RRItem item:@"??" value:2500], [RRItem item:@"??" value:5000], [RRItem item:@"??" value:100000],[RRItem item:@"??" value:20000],[RRItem item:@"??" value:150000]];
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

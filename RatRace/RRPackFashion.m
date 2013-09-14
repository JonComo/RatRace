//
//  RRPackFashion.m
//  RatRace
//
//  Created by David de Jesus on 9/13/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPackFashion.h"

@implementation RRPackFashion

+(NSDictionary *)details
{
    return @{RRPackDetailName: @"The Fashion isto/ista",
             RRPackDetailDescription: @"Buy and sell collections of brand names high end fashion apparel & accessories.",
             RRPackDetailImage : [UIImage imageNamed:@"diamondWhite"],
             RRPackClassObject: [RRPackFashion class],
             RRPackDetailID : @"com.unmd76.theMerchant.packArtDealer"};
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

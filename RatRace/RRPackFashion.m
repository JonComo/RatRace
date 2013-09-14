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
    return @{RRPackDetailName: @"The Fashion Merchant",
             RRPackDetailDescription: @"Buy and sell collections of brand name high end fashion apparel.",
             RRPackDetailImage : [UIImage imageNamed:@"diamondWhite"],
             RRPackClassObject: [RRPackFashion class],
             RRPackDetailID : @"com.unmd76.theMerchant. - - -"};
}

-(NSArray *)items
{
    return @[[RRItem item:@"Gucci" value:250], [RRItem item:@"Versace" value:600], [RRItem item:@"Yve Saint Laurent" value:1600],[RRItem item:@"Dolce & Gabbana" value:3000],[RRItem item:@"Versace" value:5000],[RRItem item:@"Hermes" value:11000]];
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

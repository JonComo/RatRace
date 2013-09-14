//
//  RRPackDope.m
//  RatRace
//
//  Created by David de Jesus on 9/13/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPackDope.h"

@implementation RRPackDope

+(NSDictionary *)details
{
    return @{RRPackDetailName: @"The Drug Dealer",
             RRPackDetailDescription: @"Ode to the original drug wars text game",
             RRPackDetailImage : [UIImage imageNamed:@"diamondWhite"],
             RRPackClassObject: [RRPackDope class],
             RRPackDetailID : @"com.unmd76.theMerchant. - - -"};
}

-(NSArray *)items
{
    return @[[RRItem item:@"Weed" value:70], [RRItem item:@"Meth" value:200], [RRItem item:@"Molly" value:2500], [RRItem item:@"Heroine" value:5000], [RRItem item:@"Cocaine" value:10000]];
}

-(NSArray *)locations
{
    return @[@"Manhattan", @"Central Park", @"Queens", @"Bronx", @"Staten Island", @"Brooklyn"];
}

-(RREvent *)randomEvent
{
    return nil;
}

@end

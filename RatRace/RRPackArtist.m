//
//  RRPackArtist.m
//  RatRace
//
//  Created by Jon Como on 9/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPackArtist.h"

@implementation RRPackArtist

+(NSDictionary *)details
{
    return @{RRPackDetailName: @"The Art Dealer",
             RRPackDetailDescription: @"Visit galleries from Paris to New York, growing your collection.",
             RRPackDetailImage : [UIImage imageNamed:@"diamondWhite"],
             RRPackClassObject: [RRPackArtist class],
             RRPackDetailID : @"com.unmd76.theMerchant.packArtDealer"};
}

-(NSArray *)items
{
    return @[[RRItem item:@"El Mac" value:2500], [RRItem item:@"Retna" value:5000], [RRItem item:@"David Choe" value:100000],[RRItem item:@"Shepard Fairey" value:20000],[RRItem item:@"Banksy" value:150000]];
}

-(NSArray *)locations
{
    return @[@"Paris", @"Los Angeles", @"Manhattan", @"Coppenhagen", @"London", @"Tokyo"];
}

-(RREvent *)randomEvent
{
    return nil;
}

@end

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
             RRPackClassObject: [RRPackArtist class]};
}

-(NSArray *)items
{
    return @[[RRItem item:@"Georgia O'Keeffe" value:150000], [RRItem item:@"Salvador Dali" value:200000], [RRItem item:@"Claude Monet" value:250000], [RRItem item:@"Pablo Picasso" value:500000], [RRItem item:@"Vincent van Gogh" value:1000000]];
}

-(NSArray *)locations
{
    return @[@"Switzerland", @"Dubai", @"Greece", @"Russia", @"South Africa", @"Thailand"];
}

-(RREvent *)randomEvent
{
    return nil;
}

@end

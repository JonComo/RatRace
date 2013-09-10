//
//  RRPackCell.m
//  RatRace
//
//  Created by David de Jesus on 9/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPackCell.h"
#import "RRPack.h"
#import "RRGraphics.h"
#import "RRGame.h"

@implementation RRPackCell

-(void)setDetails:(NSMutableDictionary *)details
{
    _details = details;
    
    labelMain.text = details[RRPackDetailName];
    labelDetail.text = details[RRPackDetailDescription];
    imageMain.image = details[RRPackDetailImage];
    
    [RRGraphics buttonStyle:buttonUnlock];
    
}

- (IBAction)playGame:(id)sender {
    
    NSDictionary *options = @{RRGameOptionMaxDays: @(30),
                              RRGameOptionPackObject : self.details[RRPackClassObject],
                              RRGameOptionStartingMoney : @(800000),
                              RRGameOptionStartingLoan : @(1000000)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playGame" object:options];
}


@end

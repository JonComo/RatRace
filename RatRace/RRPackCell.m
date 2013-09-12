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
{
    __weak IBOutlet UIImageView *imageMain;
    __weak IBOutlet UILabel *labelMain;
    __weak IBOutlet UILabel *labelDetail;
    
    __weak IBOutlet RRButtonSound *buttonPlay;
    __weak IBOutlet RRButtonSound *buttonRestore;
}

-(void)setDetails:(NSMutableDictionary *)details
{
    _details = details;
    
    labelMain.text = details[RRPackDetailName];
    labelDetail.text = details[RRPackDetailDescription];
    imageMain.image = details[RRPackDetailImage];
    
    [RRGraphics buttonStyle:buttonPlay];
    
    [self updatePlayButton];
}

-(void)updatePlayButton
{
    NSString *packID = self.details[RRPackDetailID];
    
    [buttonPlay removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:packID])
    {
        //unlocked
        [buttonPlay addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchUpInside];
        [buttonPlay setTitle:@"PLAY" forState:UIControlStateNormal];
    }else{
        //not unlocked
        [buttonPlay addTarget:self action:@selector(buyPack) forControlEvents:UIControlEventTouchUpInside];
        [buttonPlay setTitle:@"BUY (99c)" forState:UIControlStateNormal];
    }
}

- (void)playGame
{
    NSDictionary *options = @{RRGameOptionMaxDays: @(30),
                              RRGameOptionPackObject : self.details[RRPackClassObject],
                              RRGameOptionStartingMoney : @(2000),
                              RRGameOptionStartingLoan : @(5000)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playGame" object:options];
}

-(void)buyPack
{
    //buy pack here
    NSString *packID = self.details[RRPackDetailID];
    
    //if purchase goes through
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:packID];
    
    [self updatePlayButton];
}


@end

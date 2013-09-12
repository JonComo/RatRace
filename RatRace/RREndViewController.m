//
//  RREndViewController.m
//  RatRace
//
//  Created by Jon Como on 9/8/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RREndViewController.h"

#import "RRButtonSound.h"

#import "RRGraphics.h"

#import "RRGraphView.h"

#import "RRGame.h"

#import "RRGameCenterManager.h"
#import <GameKit/GameKit.h>

#import "MBProgressHUD.h"

@interface RREndViewController ()
{
    __weak IBOutlet RRButtonSound *buttonDone;
    __weak IBOutlet RRGraphView *viewStats;
    
    __weak IBOutlet UILabel *labelMoney;
    
    __weak IBOutlet UILabel *labelDay;
    __weak IBOutlet UILabel *labelScoreSubmitted;
}

@end

@implementation RREndViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[RRGame sharedGame] endGame];
    
    labelDay.text = [NSString stringWithFormat:@"DAY %i", [RRGame sharedGame].day];
    labelMoney.text = [RRGame format:[RRGame sharedGame].player.money - [RRGame sharedGame].bank.loan];
    
    [RRGraphics buttonStyleDark:buttonDone];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *view in self.view.subviews){
        view.alpha = 0;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UIView *view in self.view.subviews){
        if (view == labelScoreSubmitted) continue;
        [UIView animateWithDuration:0.3 delay:view.frame.origin.y/240 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.alpha = 1;
        } completion:nil];
    }
    
    [self graphStats];
    
    float currentScore = [RRGame sharedGame].player.money;
    
    float lastHighScore = [[NSUserDefaults standardUserDefaults] floatForKey:@"score"];
    
    if (currentScore > lastHighScore){
        [[NSUserDefaults standardUserDefaults] setFloat:currentScore forKey:@"score"];
    }
    
    GKScore *score = [[GKScore alloc] initWithCategory:kLeaderboardCategory];
    score.value = currentScore;
    [[RRGameCenterManager sharedManager] reportScore:score completion:^(NSError *error) {
        labelScoreSubmitted.text = error ? @"Error submitting score" : @"Score submitted";
        [UIView animateWithDuration:0.3 animations:^{
            labelScoreSubmitted.alpha = 1;
        }];
    }];
}

-(void)graphStats
{
    [viewStats clear];
    
    RRGraphData *money = [RRGraphData new];
    RRGraphData *loan = [RRGraphData new];
    
    money.color = [UIColor blackColor];
    loan.color = [UIColor redColor];
    
    money.name = @"money";
    loan.name = @"loan";
    
    for (NSDictionary *dayLog in [[RRGame sharedGame].stats currentLogs])
    {
        NSNumber *moneyValue = dayLog[@"money"];
        NSNumber *loanValue = dayLog[@"loan"];
        
        [money.data addObject:moneyValue];
        [loan.data addObject:loanValue];
    }
    
    [viewStats graph:money];
    [viewStats graph:loan];
    
    viewStats.xRange = MAX(0, [RRGame sharedGame].dayMaximum - 1);
    
    viewStats.drawGrid = NO;
    
    [viewStats setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

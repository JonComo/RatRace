//
//  RRIntroViewController.m
//  RatRace
//
//  Created by Jon Como on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRIntroViewController.h"

#import "RRAudioEngine.h"
#import "RRGraphics.h"
#import "RRButtonSound.h"
#import <GameKit/GameKit.h>

#import "RRMarketViewController.h"

#import "RRGame.h"

@interface RRIntroViewController ()<GKLeaderboardViewControllerDelegate>
{
    
    __weak IBOutlet RRButtonSound *buttonNewGame;
    __weak IBOutlet RRButtonSound *buttonLeaderboard;
}

@end

@implementation RRIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RRGraphics buttonStyle:buttonNewGame];
    [RRGraphics buttonStyle:buttonLeaderboard];
    
	// Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[RRAudioEngine sharedEngine] stopAllSounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGame:(id)sender
{
    [RRGame clearGame];
    
    RRMarketViewController *marketVC = [self.storyboard instantiateViewControllerWithIdentifier:@"marketVC"];
    
    [self presentViewController:marketVC animated:YES completion:nil];
}


- (IBAction)leaderBoard:(id)sender {
    
    [self showLeaderboard];
    
}

#pragma mark GameCenter Controllers

- (void) showLeaderboard;
{
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL)
	{
		leaderboardController.category = kLeaderboardCategory;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self;
		[self presentViewController:leaderboardController animated:YES completion:nil];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end

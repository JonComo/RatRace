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

#import "MBProgressHUD.h"

#import "RRGameCenterManager.h"
#import <GameKit/GameKit.h>

#import "RRMarketViewController.h"
#import "RRPackListViewController.h"

#import "RRHistoryViewController.h"

#import "RRStoreManager.h"

#import "RRGame.h"

@interface RRIntroViewController () <GKLeaderboardViewControllerDelegate>
{
    __weak IBOutlet RRButtonSound *buttonNewGame;
    __weak IBOutlet RRButtonSound *buttonLeaderboard;
    __weak IBOutlet RRButtonSound *buttonMore;
    __weak IBOutlet RRButtonSound *buttonChallenge;
    __weak IBOutlet RRButtonSound *buttonHistory;
}

@end

@implementation RRIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [RRGraphics buttonStyle:buttonNewGame];
    [RRGraphics buttonStyle:buttonLeaderboard];
    [RRGraphics buttonStyle:buttonMore];
    [RRGraphics buttonStyle:buttonChallenge];
    [RRGraphics buttonStyle:buttonHistory];
    
    [[RRStoreManager store] requestProdcutsCompletion:^(NSArray *products) {
        NSLog(@"Products: %@", products);
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[RRAudioEngine sharedEngine] stopAllSounds];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    
    // Do any additional setup after loading the view.
}

-(void)submitSavedScore
{
    float lastHighScore = [[NSUserDefaults standardUserDefaults] floatForKey:@"score"];
    
    GKScore *score = [[GKScore alloc] initWithCategory:kLeaderboardCategory];
    score.value = lastHighScore;
    [[RRGameCenterManager sharedManager] reportScore:score completion:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGame:(id)sender
{
    NSDictionary *options = @{RRGameOptionMaxDays: @(30),
                              RRGameOptionPackObject : [RRPackDiamond class],
                              RRGameOptionStartingMoney : @(2000),
                              RRGameOptionStartingLoan : @(5000)};
    [RRGame clearGame];
    [[RRGame sharedGame] newGameWithOptions:options];
    
    RRMarketViewController *marketVC = [self.storyboard instantiateViewControllerWithIdentifier:@"marketVC"];
    [self presentViewController:marketVC animated:YES completion:nil];
    
//    Save for In-App-Purchase Options
    
//    RRPackListViewController *packVC = [self.storyboard instantiateViewControllerWithIdentifier:@"packVC"];
//    [self presentViewController:packVC animated:YES completion:nil];
}

- (IBAction)leaderBoard:(id)sender
{
    [self submitSavedScore];
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
            
            if ([GKLocalPlayer localPlayer].isAuthenticated)
            {
                //has gamecenter enabled
                [self showLeaderboard];
                
            }else if(viewController)
            {
                UIViewController *rootVC = (UIViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                [rootVC presentViewController:viewController animated:YES completion:nil];
            }else{
                //gamecenter disabled
                NSLog(@"DISABLED");
            }
        }];
        
        if (!self.presentedViewController)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Gamecenter Disabled";
            hud.detailsLabelText = @"Sign in to gamecenter to access leaderboards.";
            hud.color = [UIColor whiteColor];
            [hud setMode:MBProgressHUDModeText];
            [hud hide:YES afterDelay:2];
        }
    }else{
        [self showLeaderboard];
    }
}

- (IBAction)challenge:(id)sender {
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] valueForKey:@"score"];
    
    NSString *challengeMessage = [NSString stringWithFormat:@"Try and beat %@ in The Merchant. You can't.", [RRGame format:[highScore floatValue]]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[challengeMessage] applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)history:(id)sender {
    RRHistoryViewController *historyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"historyVC"];
    
    [self presentViewController:historyVC animated:YES completion:nil];
}

#pragma mark GameCenter Controllers

- (void)showLeaderboard;
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

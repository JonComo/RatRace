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

#import "RRStoreManager.h"

#import "RRGame.h"

@interface RRIntroViewController () <GKLeaderboardViewControllerDelegate>
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
    
    [[RRStoreManager store] requestProdcutsCompletion:^(NSArray *prodcuts) {
        NSLog(@"Products: %@", prodcuts);
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[RRAudioEngine sharedEngine] stopAllSounds];
    
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
    [RRGame clearGame];
    
    RRPackListViewController *marketVC = [self.storyboard instantiateViewControllerWithIdentifier:@"packVC"];
    
    [self presentViewController:marketVC animated:YES completion:nil];
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

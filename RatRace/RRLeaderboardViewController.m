//
//  RRLeaderboardViewController.m
//  RatRace
//
//  Created by David de Jesus on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRLeaderboardViewController.h"
#import "RRGame.h"

@interface RRLeaderboardViewController ()
{
    
}

@end

@implementation RRLeaderboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (!localPlayer.authenticated) {
        [localPlayer setAuthenticateHandler:^(UIViewController *vc, NSError *error) {
            [self presentViewController:vc animated:YES completion:nil];
        }];
    }else{
        GKLeaderboardViewController *leaderboardViewController =
        [[GKLeaderboardViewController alloc] init];
        leaderboardViewController.leaderboardDelegate = self;
        [self presentViewController:leaderboardViewController animated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateScore:(int64_t)score forLeaderboardID:(NSString*)category
{
    GKScore *scoreObj = [[GKScore alloc]
                         initWithCategory:category];
    scoreObj.value = score;
    scoreObj.context = 0;
    [scoreObj reportScoreWithCompletionHandler:^(NSError *error) {
        // Completion code can be added here
        //
        
    }];
}

-(void)updateScore:(id)sender{
    [self updateScore:[RRGame sharedGame].player.money forLeaderboardID:@"tutorialsPoint"];
}

#pragma mark GKControllerDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    
}

@end

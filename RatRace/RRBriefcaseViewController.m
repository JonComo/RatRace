//
//  RRBriefcaseViewController.m
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//


#import "RRBriefcaseViewController.h"
#import "RRButtonSound.h"
#import "RRGraphics.h"
#import "RRGame.h"

#import "JLBPartialModal.h"

@interface RRBriefcaseViewController ()
{
    
    __weak IBOutlet RRButtonSound *buttonLeader;
    __weak IBOutlet RRButtonSound *buttonNewGame;
}

@property (nonatomic, strong) GKLeaderboard *leaderboards;
@property (nonatomic, strong) GKScore *score;

@end


@implementation RRBriefcaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RRGraphics buttonStyle:buttonNewGame];
    [RRGraphics buttonStyle:buttonLeader];
    
    [self loadLeaderboardInfo];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)leaderboard:(id)sender {

}

- (void) loadLeaderboardInfo
{
    [[GKLocalPlayer localPlayer] loadDefaultLeaderboardCategoryIDWithCompletionHandler:^(NSString *categoryID, NSError *error) {
        
         NSLog(@"%@ %@", categoryID, error);
        [self showLeaderboard:self.leaderboards.groupIdentifier];
        
    }];

}

- (void)showLeaderboard:(NSString*)leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
        gameCenterController.leaderboardCategory = leaderboardID;
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (IBAction)newGame:(id)sender {
    [[JLBPartialModal sharedInstance] dismissViewController];
}

#pragma mark JLModalDelegate

- (void)didPresentPartialModalView:(JLBPartialModal *)partialModal
{
    
}

- (BOOL)shouldDismissPartialModalView:(JLBPartialModal *)partialModal
{
    return YES;
}

- (void)didDismissPartialModalView:(JLBPartialModal *)partialModal
{
    
}

#pragma mark GKLeaderboardDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    
}


@end

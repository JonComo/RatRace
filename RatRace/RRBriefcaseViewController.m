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

#import "RRGraphView.h"

#import "JLBPartialModal.h"

@interface RRBriefcaseViewController ()
{
    __weak IBOutlet RRGraphView *viewStats;
    __weak IBOutlet RRButtonSound *buttonLeader;
    __weak IBOutlet RRButtonSound *buttonNewGame;
}

@property (nonatomic, strong) GKLeaderboard *leaderboards;
@property (nonatomic, strong) GKScore *score;

@end


@implementation RRBriefcaseViewController
{
    BOOL newGame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RRGraphics buttonStyle:buttonNewGame];
    [RRGraphics buttonStyle:buttonLeader];
    
    [self loadLeaderboardInfo];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self graphStats];
}

-(void)graphStats
{
    [viewStats clear];
    
    RRGraphData *money = [RRGraphData new];
    RRGraphData *loan = [RRGraphData new];
    
    money.color = [UIColor whiteColor];
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
    
    viewStats.drawGrid = YES;
    
    [viewStats setNeedsDisplay];
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

- (IBAction)newGame:(id)sender
{
    newGame = YES;
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
    if (newGame){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newGame" object:nil];
    }
}

#pragma mark GKLeaderboardDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    
}


@end

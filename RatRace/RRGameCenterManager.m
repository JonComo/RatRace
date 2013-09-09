//
//  RRGameCenterManager.m
//  RatRace
//
//  Created by David de Jesus on 9/8/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRGameCenterManager.h"
#import <GameKit/GameKit.h>

@implementation RRGameCenterManager

+(RRGameCenterManager *)sharedManager
{
    static RRGameCenterManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[RRGameCenterManager alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
	if(self = [super init])
    {
        //init
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _storedScoresFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedScores.plist",path,[GKLocalPlayer localPlayer].playerID];
        writeLock = [[NSLock alloc] init];
	}
    
	return self;
}

+(BOOL)isGameCenterAvailable
{
	// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (void)authenticateLocalUserOnViewController:(UIViewController *)parentViewController
{
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error)
    {
        if (viewController && parentViewController)
        {
            [parentViewController presentViewController:viewController animated:YES completion:nil];
        }
        else if ([GKLocalPlayer localPlayer].authenticated)
        {
            NSLog(@"Player authenticated");
        }else{
            NSLog(@"Player authentication failed");
        }
    }];
}

- (void)reloadHighScoresForCategory:(NSString*)category
{
	GKLeaderboard *leaderBoard = [[GKLeaderboard alloc] init];
	leaderBoard.category = category;
	leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
	leaderBoard.range = NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error)
     {
         if ([self.delegate respondsToSelector:@selector(reloadScoresComplete:error:)]) {
             [self.delegate reloadScoresComplete:leaderBoard error:error];
         }
     }];
}

- (void)reportScore:(GKScore *)score completion:(void (^)(NSError *))block
{
	[score reportScoreWithCompletionHandler: ^(NSError *error)
    {
         if (block) block(error);
         
         if (!error || (![error code] && ![error domain])) {
             // Score submitted correctly. Resubmit others
             [self resubmitStoredScores];
         } else {
             // Store score for next authentication.
             [self storeScore:score];
         }
         
         if ([self.delegate respondsToSelector:@selector(scoreReported:)]) {
             [self.delegate scoreReported:error];
         }
	 }];
}

// Attempt to resubmit the scores.
- (void)resubmitStoredScores
{
    if (_storedScores) {
        // Keeping an index prevents new entries to be added when the network is down
        int index = [_storedScores count]-1;
        while( index >= 0 ) {
            GKScore * score = [_storedScores objectAtIndex:index];
            [self reportScore:score completion:nil];
            [_storedScores removeObjectAtIndex:index];
            index--;
        }
        [self writeStoredScore];
    }
}

// Load stored scores from disk.
- (void)loadStoredScores
{
    NSArray *  unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:_storedScoresFilename];
    
    if (unarchivedObj) {
        _storedScores = [[NSMutableArray alloc] initWithArray:unarchivedObj];
        [self resubmitStoredScores];
    } else {
        _storedScores = [[NSMutableArray alloc] init];
    }
}

// Save stored scores to file.
- (void)writeStoredScore
{
    [writeLock lock];
    NSData * archivedScore = [NSKeyedArchiver archivedDataWithRootObject:_storedScores];
    NSError * error;
    [archivedScore writeToFile:_storedScoresFilename options:NSDataWritingFileProtectionNone error:&error];
    if (error) {
        //  Error saving file, handle accordingly
    }
    [writeLock unlock];
}

// Store score for submission at a later time.
- (void)storeScore:(GKScore *)score
{
    [_storedScores addObject:score];
    [self writeStoredScore];
}


@end

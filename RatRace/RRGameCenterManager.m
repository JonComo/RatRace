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

- (id) init
{
	self = [super init];
	if(self!= NULL)
	{
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _storedScoresFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedScores.plist",path,[GKLocalPlayer localPlayer].playerID];
        writeLock = [[NSLock alloc] init];
	}
	return self;
}

//- (void) callDelegate: (SEL) selector withArg: (id) arg error: (NSError*) err
//{
//	assert([NSThread isMainThread]);
//	if([self.delegate respondsToSelector:@selector(selector)])
//	{
//		if(arg != NULL)
//		{
//			[self.delegate performSelector:@selector(selector) withObject:arg];
//		}
//		else
//		{
//			[self.delegate performSelector:@selector(selector) withObject: err];
//		}
//	}
//	else
//	{
//		NSLog(@"Missed Method");
//	}
//}
//
//
//- (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
//{
//	dispatch_async(dispatch_get_main_queue(), ^(void)
//                   {
//                       [self callDelegate: selector withArg: arg error: err];
//                   });
//}

+ (BOOL) isGameCenterAvailable
{
	// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (void) authenticateLocalUser:(UIViewController *)viewController
{
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *loginVC, NSError *error){
        if([GKLocalPlayer localPlayer].authenticated){
            
        }else{
            [viewController presentViewController:loginVC animated:YES completion:nil];
        }
        
            

	};
}

- (void) reloadHighScoresForCategory: (NSString*) category
{
	GKLeaderboard* leaderBoard= [[GKLeaderboard alloc] init];
	leaderBoard.category= category;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
     {
         if ([self.delegate respondsToSelector:@selector(reloadScoresComplete:error:)]) {
             [self.delegate reloadScoresComplete:leaderBoard error:error];
         }
     }];
}

- (void) reportScore:(GKScore *)score forCategory: (NSString*) category
{
	GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
	scoreReporter = score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error)
	 {
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
            [self reportScore:score forCategory:kLeaderboardCategory];
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

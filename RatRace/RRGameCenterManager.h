//
//  RRGameCenterManager.h
//  RatRace
//
//  Created by David de Jesus on 9/8/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKLeaderboard, GKLocalPlayer, GKPlayer, GKScore;

@protocol RRGameCenterDelegate <NSObject>

@optional
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
@end

@interface RRGameCenterManager : NSObject
{
    NSLock *writeLock;
}

@property (nonatomic, assign)  id <RRGameCenterDelegate> delegate;
@property (readonly, nonatomic) NSMutableArray * storedScores;
@property (nonatomic, strong) NSString *storedScoresFilename;

+(RRGameCenterManager *)sharedManager;

+ (BOOL)isGameCenterAvailable;

- (void)authenticateLocalUserOnViewController:(UIViewController *)viewController;

- (void)reportScore:(GKScore *)score completion:(void(^)(NSError *error))block;
- (void)reloadHighScoresForCategory: (NSString*) category;

//store score
- (void)storeScore:(GKScore *)score ;
- (void)resubmitStoredScores;
- (void)writeStoredScore;
- (void)loadStoredScores;


@end

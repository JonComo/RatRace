//
//  RRAppDelegate.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRAppDelegate.h"
#import "RRAudioEngine.h"
#import "TestFlight.h"

#import "RRGameCenterManager.h"
#import <GameKit/GameKit.h>

@implementation RRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[RRAudioEngine sharedEngine] initializeAudioSession];
    [TestFlight takeOff:@"9f892d79-fcda-4e71-a89f-ed84cde72dc4"];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[RRGameCenterManager sharedManager] authenticateLocalUserOnViewController:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end

//
//  RRAppDelegate.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRAppDelegate.h"
#import "RRAudioEngine.h"

#import "RRGameCenterManager.h"
#import <GameKit/GameKit.h>

@implementation RRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[RRAudioEngine sharedEngine] initializeAudioSession];
    
    //reset userdefaults for testing purposes
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
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

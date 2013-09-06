//
//  RRAppDelegate.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRAppDelegate.h"
#import "RRAudioEngine.h"
#import <GameKit/GameKit.h>

@implementation RRAppDelegate


#pragma mark -
#pragma mark Game Center Support



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[RRAudioEngine sharedEngine] initializeAudioSession];

    
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

    
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end

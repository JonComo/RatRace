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
#import "TestFlight.h"

@implementation RRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        
        [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error)
        {
            if (viewController != nil)
            {
                viewController = (UIViewController *)[UIApplication sharedApplication].delegate;
                
                [viewController presentViewController:viewController animated:YES completion:nil];
            }
            else if ([GKLocalPlayer localPlayer].authenticated)
            {
                NSLog(@"Player authenticated");
            }
            else
            {
                NSLog(@"Player authentication failed");
            }
        };
    }
    
    [[RRAudioEngine sharedEngine] initializeAudioSession];
    
    [TestFlight takeOff:@"20027d9d-5ca4-4093-82bf-930c0d004cb1"];
    


    
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

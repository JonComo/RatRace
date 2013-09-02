//
//  RRTravelViewController.h
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLBPartialModal.h"

@class RRTravelViewController;

@protocol RRTravelViewControllerDelegate <NSObject>

@required
- (void)controllerDidDismiss:(RRTravelViewController *)controller;


@end

@interface RRTravelViewController : UIViewController <JLBPartialModalDelegate>

@property (assign) id <RRTravelViewControllerDelegate> delegate;

@end

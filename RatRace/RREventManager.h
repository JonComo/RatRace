//
//  RREventManager.h
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

#import "RREvent.h"

@class RREventManager;

@protocol RREventManagerDelegate <NSObject>

-(void)showHUDWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image;
-(void)eventManagerDidUpdateData:(RREventManager *)manager;

@end

@interface RREventManager : NSObject

@property (nonatomic, weak) id <RREventManagerDelegate> delegate;
@property (nonatomic, weak) UIView *viewForHUD;

-(void)addRandomEvent;
-(void)removeEvent:(RREvent *)event;

-(void)run;

-(void)displayNextHUD;
-(void)hideHUD:(UITapGestureRecognizer *)tap;

@end
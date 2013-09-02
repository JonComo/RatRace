//
//  SMStatsView.h
//  Sim
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMStatsView : UIView
@property (strong, nonatomic) IBOutlet UILabel *days;
@property (strong, nonatomic) IBOutlet UILabel *cash;
@property (strong, nonatomic) IBOutlet UILabel *balance;
@property (strong, nonatomic) IBOutlet UILabel *inventory;

-(void)setup;
-(void)update;

@end

//
//  RRBankViewController.m
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRBankViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RRGame.h"
#import "RRStepper.h"

#import "RRAudioEngine.h"

@interface RRBankViewController ()
{
    __weak IBOutlet UILabel *label;
    __weak IBOutlet UILabel *balanceLabel;
    __weak IBOutlet UILabel *labelLoanLimit;

}

- (IBAction)touchup:(id)sender;

@end

@implementation RRBankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[RRAudioEngine sharedEngine] playSoundNamed:@"slide" extension:@"aiff" loop:NO];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pay:(id)sender
{
    [[RRStepper sharedStepper] buttonDownWithAction:^{
        [self payLoan:200];
    }];
}

- (IBAction)borrow:(id)sender
{
    [[RRStepper sharedStepper] buttonDownWithAction:^{
        [self borrowLoan:200];
    }];
}

- (IBAction)touchup:(id)sender
{
    [[RRStepper sharedStepper] buttonUp];
    
    [[RRAudioEngine sharedEngine] playSoundNamed:@"register" extension:@"wav" loop:NO];
}

-(void)payLoan:(float)amount
{
    [[RRGame sharedGame].bank payLoan:amount];
    if ([RRGame sharedGame].bank.loan == 0) {
        [self animateLabel];
    }
    
    [self updateUI];
}

-(void)borrowLoan:(float)amount
{
    [[RRGame sharedGame].bank borrow:amount];
    if ([RRGame sharedGame].bank.loan >= [RRGame sharedGame].bank.loanLimit) {
        [self animateLabel];
    }
    
    [self updateUI];
}

-(void)updateUI
{
    label.text = [RRGame format:[RRGame sharedGame].bank.loan];
    balanceLabel.text = [NSString stringWithFormat:@"BAL: %@", [RRGame format:[RRGame sharedGame].player.money]];
    labelLoanLimit.text = [NSString stringWithFormat:@"LIMIT: %@", [RRGame format:[RRGame sharedGame].bank.loanLimit]];
}

-(void)animateLabel
{
    [UIView animateWithDuration:0.1 animations:^{
        label.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            label.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
            label.alpha = 1;
        } completion:^(BOOL finished) {
            
            
        }];
    }];
}

#pragma mark JLModalDelegate

- (void)didPresentPartialModalView:(JLBPartialModal *)partialModal
{
    
}

- (BOOL)shouldDismissPartialModalView:(JLBPartialModal *)partialModal
{
    [[RRAudioEngine sharedEngine] playSoundNamed:@"click" extension:@"aiff" loop:NO];
    return YES;
}

- (void)didDismissPartialModalView:(JLBPartialModal *)partialModal
{
    [[RRAudioEngine sharedEngine] playSoundNamed:@"slide" extension:@"aiff" loop:NO];
}

@end

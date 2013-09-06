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

@interface RRBankViewController ()
{
    __weak IBOutlet UILabel *label;
    __weak IBOutlet UILabel *balanceLabel;


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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pay:(id)sender
{
    [[RRStepper sharedStepper] buttonDownWithAction:^{
        [self payLoan:arc4random()%100];
    }];
}

- (IBAction)borrow:(id)sender
{
    [[RRStepper sharedStepper] buttonDownWithAction:^{
        [self borrowLoan:arc4random()%100];
    }];
}

- (IBAction)touchup:(id)sender
{
    [[RRStepper sharedStepper] buttonUp];
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
    label.text = [NSString stringWithFormat:@"$%.2f", [RRGame sharedGame].bank.loan];
    balanceLabel.text = [NSString stringWithFormat:@"BAL: $%.2f", [RRGame sharedGame].player.money];
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
    return YES;
}

- (void)didDismissPartialModalView:(JLBPartialModal *)partialModal
{
    
}

@end

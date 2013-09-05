//
//  RRBankViewController.m
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRBankViewController.h"
#import "RRGame.h"
#import "RRStepper.h"

@interface RRBankViewController ()
{

}

@property (strong, nonatomic) IBOutlet UILabel *label;

- (IBAction)touchup:(id)sender;

@end

@implementation RRBankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
    [self updateUI];
}

-(void)borrowLoan:(float)amount
{
    [[RRGame sharedGame].bank borrow:amount];
    [self updateUI];
}

-(void)updateUI
{
    self.label.text = [NSString stringWithFormat:@"$%.2f", [RRGame sharedGame].bank.loan];
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

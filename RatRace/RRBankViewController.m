//
//  RRBankViewController.m
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRBankViewController.h"
#import "RRGame.h"
@interface RRBankViewController ()
{

}

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pay:(id)sender
{
    [[RRGame sharedGame].bank payLoan:[self.label.text floatValue]];
    [[JLBPartialModal sharedInstance] dismissViewController];
}

- (IBAction)borrow:(id)sender
{
    [[RRGame sharedGame].bank borrow:[self.label.text floatValue]];
    [[JLBPartialModal sharedInstance] dismissViewController];


}

- (IBAction)stepValue:(UIStepper *)sender
{
    self.label.text = [NSString stringWithFormat:@"%f", sender.value];
    
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

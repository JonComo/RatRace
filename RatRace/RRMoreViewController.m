//
//  RRMoreViewController.m
//  RatRace
//
//  Created by David de Jesus on 9/10/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRMoreViewController.h"

@interface RRMoreViewController ()
{
    
    __weak IBOutlet UITextView *textViewMain;
}

@end

@implementation RRMoreViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    textViewMain.text = [self howToString];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)done:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSString *)howToString
{
    NSString *main = @"How to play: Buy low and sell high blah blah blah blah blah blah!";
    return main;
}
@end

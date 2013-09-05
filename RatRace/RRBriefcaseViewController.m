//
//  RRBriefcaseViewController.m
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRBriefcaseViewController.h"

#import "RRGame.h"

@interface RRBriefcaseViewController ()

@end

@implementation RRBriefcaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGame:(id)sender {
    [[RRGame sharedGame] newGame];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

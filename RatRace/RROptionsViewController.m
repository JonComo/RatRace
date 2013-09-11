//
//  RROptionsViewController.m
//  RatRace
//
//  Created by Jon Como on 9/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RROptionsViewController.h"

#import "RRButtonSound.h"

#import "RRAudioEngine.h"

@interface RROptionsViewController () <UIAlertViewDelegate>
{
    __weak IBOutlet RRButtonSound *buttonDone;
    __weak IBOutlet RRButtonSound *buttonQuit;
    __weak IBOutlet RRButtonSound *buttonMusic;
}

@end

@implementation RROptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUI
{
    BOOL musicMuted = [[RRAudioEngine sharedEngine] musicMuted];
    [buttonMusic setTitle:musicMuted ? @"MUSIC: OFF" : @"MUSIC: ON" forState:UIControlStateNormal];
}

- (IBAction)toggleMusic:(id)sender
{
    [[RRAudioEngine sharedEngine] toggleMusic];
    [self updateUI];
}

- (IBAction)quitGame:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit Game?" message:@"Are you sure you want to quit? This will end the game on the current day." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Quit", nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endGame" object:nil];
        }];
    }
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

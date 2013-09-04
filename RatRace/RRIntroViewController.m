//
//  RRIntroViewController.m
//  RatRace
//
//  Created by Jon Como on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRIntroViewController.h"

#import "RRAudioEngine.h"
#import "RRGraphics.h"
#import "RRButtonSound.h"

@interface RRIntroViewController ()
{
    
    __weak IBOutlet RRButtonSound *buttonNewGame;
}

@end

@implementation RRIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RRGraphics buttonStyle:buttonNewGame];
    
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGame:(id)sender
{
    
}


@end

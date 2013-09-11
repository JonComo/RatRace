//
//  RRMoreViewController.m
//  RatRace
//
//  Created by David de Jesus on 9/10/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRMoreViewController.h"
#import "RRGraphics.h"
#import "RRButtonSound.h"

@interface RRMoreViewController ()
{
    
    __weak IBOutlet UITextView *textViewMain;
    __weak IBOutlet RRButtonSound *buttonDone;
}

@end

@implementation RRMoreViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [RRGraphics buttonStyleDark:buttonDone];
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
    NSString *main = @"How to play:\n 1. Choose or unlock a profile that matches your character preference \n\n 2. Begin the game in the main location your bank exists \n\n 3. Borrow from the bank \n\n 4. Assess costs of goods in your current location \n\n 5. Make a decision to buy \n\n 6. Travel to another country, assess costs in new location \n\n 7. Sell goods for a high premium to raise your money \n\n";
    return main;
}
@end

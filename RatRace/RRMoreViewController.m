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

@interface RRMoreViewController () <UITextViewDelegate>
{
    __weak IBOutlet UITextView *textViewMain;
    __weak IBOutlet RRButtonSound *buttonDone;
    __weak IBOutlet RRButtonSound *buttonShare;
}

@end

@implementation RRMoreViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [RRGraphics buttonStyleDark:buttonDone];
    [RRGraphics buttonStyleDark:buttonShare];
    
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
    NSString *main = @"PREMISE: \nThe Merchant is a turn based strategy game based on the 1984 DOS game Drug Wars by John E. Dell. The Merchant's story orbits around a well to do business person with an interest in finer things and high stakes goods. You can choose from different character profiles unlocking new adventures for each character, and trade different goods.  The mechanics are simple; You are a merchant who travels to different places to buy and sell your goods.In this game, you are given 30 days to make as much money as possible.  You are given a starting amount of investment capital, and a loan from the bank with often varying interest rates. Every time you travel it costs you a day. You have an initial inventory amount that can expand during the course of the game. Watch out for illegal goods.\n\nOther components of the game include random story events that impact the values of inventory on hand, bank interest, and bank loan limits by mysterious surprise occurences. After 30 days the game ends, and the total score is calculated in players money after the bank is paid in full.\n\nSTRATEGY:\nThe basic strategy of The Merchant is to buy goods in one location at one price, and then travel to another location to sell it for a higher price. More skilled players will understand market trends, and realize each location has its own economic trends.Each piece of merchandise has a base line average, and a skilled player can spot and take advantage of large market fluctuations. More money is made when dealing in higher priced goods, however traveling with too many high valued items may cost you.\n\n SPECIAL THANKS & RECOGNITION:\n\n Jonathan Badeen - JLPartialModal https://github.com/badeen/JLBPartialModal";
    return main;
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
@end

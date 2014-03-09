//
//  RRBriefcaseViewController.m
//  RatRace
//
//  Created by Jon Como on 9/5/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//


#import "RRBriefcaseViewController.h"
#import "RRButtonSound.h"
#import "RRGraphics.h"
#import "RRGame.h"

#import "RRAudioEngine.h"

#import "RRGraphView.h"

#import "JLBPartialModal.h"
#import <MediaPlayer/MediaPlayer.h>


@interface RRBriefcaseViewController () <UIAlertViewDelegate, MPMediaPickerControllerDelegate>
{
    __weak IBOutlet RRGraphView *viewStats;
    
    __weak IBOutlet RRButtonSound *buttonMusic;
    __weak IBOutlet RRButtonSound *buttonQuit;
    __weak IBOutlet RRButtonSound *buttonRadio;
}

@property (nonatomic, strong) MPMediaPickerController *picker;

@end


@implementation RRBriefcaseViewController
{
    BOOL endGame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RRGraphics buttonStyle:buttonMusic];
    [RRGraphics buttonStyle:buttonQuit];
    [RRGraphics buttonStyle:buttonRadio];

    
    [self updateUI];
    
    [self graphStats];
}

-(void)graphStats
{
    [viewStats clear];
    
    RRGraphData *money = [RRGraphData new];
    RRGraphData *loan = [RRGraphData new];
    
    money.color = [UIColor whiteColor];
    loan.color = [UIColor redColor];
    
    money.name = @"money";
    loan.name = @"loan";
    
    for (NSDictionary *dayLog in [[RRGame sharedGame].stats currentLogs])
    {
        NSNumber *moneyValue = dayLog[@"money"];
        NSNumber *loanValue = dayLog[@"loan"];
        
        [money.data addObject:moneyValue];
        [loan.data addObject:loanValue];
    }
    
    [viewStats graph:money];
    [viewStats graph:loan];
    
    viewStats.xRange = MAX(0, [RRGame sharedGame].dayMaximum - 1);
    
    viewStats.drawGrid = YES;
    
    [viewStats setNeedsDisplay];
}

-(void)updateUI
{
    BOOL mutedMusic = [[RRAudioEngine sharedEngine] musicMuted];
    [buttonMusic setTitle:mutedMusic ? @"MUSIC: OFF" : @"MUSIC: ON" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)quitGame:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit Game?" message:@"Are you sure you want to quit? This will end the game on the current day." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Quit", nil];
    alert.delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        endGame = YES;
        [[JLBPartialModal sharedInstance] dismissViewController];
    }
}

- (IBAction)toggleMusic:(id)sender {
    [[RRAudioEngine sharedEngine] toggleMusic];
    [self updateUI];
}

- (IBAction)picker:(id)sender {
    self.picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    self.picker.delegate                     = [RRAudioEngine sharedEngine];
    self.picker.allowsPickingMultipleItems   = YES;
    self.picker.prompt                       = NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
    

    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
    
    [self presentViewController:self.picker animated:YES completion:nil];
    
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
    if (endGame)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"endGame" object:nil];
}


@end

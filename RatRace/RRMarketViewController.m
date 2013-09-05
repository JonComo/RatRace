//
//  RRMarketViewController.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRMarketViewController.h"

#import "RRRandomNewsViewController.h"

#import "RRGame.h"
#import "RRItem.h"

#import "SMStatsView.h"
#import "RRTravelViewController.h"
#import "RRBankViewController.h"
#import "RRDiamondCell.h"
#import "RRButtonSound.h"
#import "RRGraphics.h"

#import "MBProgressHUD.h"

#import "RREvent.h"

#import "RRAudioEngine.h"

@interface RRMarketViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    SMStatsView *statsView;
    RRTravelViewController *travelController;
    
    __weak IBOutlet RRButtonSound *travelButton;
    __weak IBOutlet RRButtonSound *bankButton;
}

@end

@implementation RRMarketViewController
{
    __weak IBOutlet UICollectionView *collectionViewItems;
    RRAudioPlayer *strings;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[RRGame sharedGame] newGame];
    
    [RRGraphics buttonStyle:travelButton];
    [RRGraphics buttonStyle:bankButton];
    
    collectionViewItems.allowsMultipleSelection = NO;
    [collectionViewItems registerNib:[UINib nibWithNibName:@"diamondCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"diamondCell"];
    
    [self addStatsView];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:RRDiamondCountChanged object:nil queue:nil usingBlock:^(NSNotification *note) {
        //[collectionViewItems reloadData];
    }];
    
    //music
    strings = [[RRAudioEngine sharedEngine] playSoundNamed:@"strings" extension:@"wav" loop:YES];
    strings.volume = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self deselectAllItems];
    [collectionViewItems reloadData];
    
    [strings fadeIn:2];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addRandomEvent];
    [self runEvents];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [strings fadeOut:1];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRDiamondCountChanged object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addRandomEvent
{
    if ([RRGame sharedGame].events.count > 0) return;
    
    if (arc4random()%10 > 5)
    {
        float interest = [RRGame sharedGame].bank.interest;
        float newInterest = MAX(0, interest + (float)(arc4random()%20)/100);
        
        if (interest != newInterest)
        {
        
            RREvent *newspaperEvent = [RREvent eventWithInitialBlock:^{

                float previousInterest = [RRGame sharedGame].bank.interest;
                [RRGame sharedGame].bank.interest = MAX(0, interest + (float)(arc4random()%20)/100);
                
                NSString *change;
                
                if (previousInterest < [RRGame sharedGame].bank.interest)
                {
                    change = @"raised";
                }else{
                    change = @"lowered";
                }
                
                [self showHUDWithTitle:[NSString stringWithFormat:@"Bank interest %@!", change] detail:[NSString stringWithFormat:@"Swiss banks have %@ their interest rate to %.1f%%!", change, [RRGame sharedGame].bank.interest * 100] autoDismiss:NO];
                
            } numberOfDays:4 endingBlock:^{
                
                NSString *change;
                
                if (interest < [RRGame sharedGame].bank.interest)
                {
                    change = @"lowered";
                }else{
                    change = @"raised";
                }
                
                [RRGame sharedGame].bank.interest = interest;
                
                [self showHUDWithTitle:[NSString stringWithFormat:@"Bank interest %@!", change] detail:[NSString stringWithFormat:@"Swiss banks have %@ their interest rate to %.1f%%!", change, [RRGame sharedGame].bank.interest * 100] autoDismiss:NO];
            }];
            
            [[RRGame sharedGame].events addObject:newspaperEvent];
        }
    }
}

-(void)runEvents
{
    if ([RRGame sharedGame].events.count > 0)
    {
        RREvent *event = [RRGame sharedGame].events[0];
        [event progressDay];
    }
}

-(void)showHUDWithTitle:(NSString *)title detail:(NSString *)detail autoDismiss:(BOOL)autoDismiss
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = title;
    hud.detailsLabelText = detail;
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.color = [UIColor whiteColor];
    hud.labelFont = [UIFont fontWithName:@"Avenir" size:18];
    hud.detailsLabelFont = [UIFont fontWithName:@"Avenir" size:14];
    
    RRButtonSound *dismiss = [[RRButtonSound alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [dismiss setTitle:@"Dismiss" forState:UIControlStateNormal];
    
    hud.customView = dismiss;
    
    if (autoDismiss)
    {
        [hud hide:YES afterDelay:3];
    }else{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD)];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [hud addGestureRecognizer:tap];
        });
    }
}

-(void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)addStatsView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"stats"
                                                      owner:self
                                                    options:nil];
    
    statsView = (SMStatsView *)nibViews[0];
    
    NSLog(@"%f", statsView.frame.size.height);
    
    
    [statsView setup];
    
    [self.view addSubview:statsView];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRDiamondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"diamondCell" forIndexPath:indexPath];
    
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    cell.item = item;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [RRGame sharedGame].availableItems.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[RRAudioEngine sharedEngine] playSoundNamed:@"click" extension:@"aiff" loop:NO];
    
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    if (item.selected)
    {
        item.selected = NO;
        [collectionViewItems reloadData];
    }else{
        [self deselectAllItems];
        item.selected = YES;
        
        [collectionViewItems reloadData];
        [collectionViewItems scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    return item.selected ? CGSizeMake(320, 144) : CGSizeMake(320, 44);
}

-(void)deselectAllItems
{
    for (RRItem *item in [RRGame sharedGame].availableItems)
    {
        item.selected = NO;
    }
}

-(RRItem *)selectedItem
{
    RRItem *selected;
    
    for (RRItem *item in [RRGame sharedGame].availableItems)
    {
        if (item.selected)
        {
            selected = item;
        }
    }
    
    return selected;
}

- (IBAction)bank:(id)sender
{
    
    if (![[RRGame sharedGame].location isEqualToString:[RRGame sharedGame].availableLocations[0]]) {
        // Show
        
    }
    RRBankViewController *bankView = [[RRBankViewController alloc] initWithNibName:@"RRBankViewController" bundle:[NSBundle mainBundle]];
    
    JLBPartialModal *modal = [JLBPartialModal sharedInstance];
    modal.delegate = bankView;
    [modal presentViewController:bankView dismissal:^{
        
    }];

}

- (IBAction)travel:(id)sender {
    [[RRGame sharedGame] advanceDay];
    
    RRTravelViewController *travelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"travelVC"];
    
    [self presentViewController:travelVC animated:YES completion:nil];
}


@end
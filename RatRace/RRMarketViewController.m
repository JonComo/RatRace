//
//  RRMarketViewController.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRMarketViewController.h"

#import "RRGame.h"
#import "RRItem.h"

#import "SMStatsView.h"
#import "RRTravelViewController.h"
#import "RRBankViewController.h"
#import "RRBriefcaseViewController.h"
#import "RRDiamondCell.h"
#import "RRButtonSound.h"
#import "RRGraphics.h"

#import "MBProgressHUD.h"

#import "RRAudioEngine.h"

@interface RRMarketViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    SMStatsView *statsView;
    RRTravelViewController *travelController;
    
    __weak IBOutlet RRButtonSound *travelButton;
    __weak IBOutlet RRButtonSound *bankButton;
    __weak IBOutlet RRButtonSound *briefButton;
    
    int eventIndex;
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
    [RRGraphics buttonStyle:briefButton];
    
    collectionViewItems.allowsMultipleSelection = NO;
    [collectionViewItems registerNib:[UINib nibWithNibName:@"diamondCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"diamondCell"];
    
    [self addStatsView];
    
    //music
    strings = [[RRAudioEngine sharedEngine] playSoundNamed:@"strings" extension:@"wav" loop:YES];
    strings.volume = 0;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:RREventShowMessageNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *title = note.userInfo[RREventTitle];
        NSString *message = note.userInfo[RREventMessage];
        UIImage *image = note.userInfo[RREventImage];
        
        [self showHUDWithTitle:title detail:message autoDismiss:NO image:image];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:RREventUpdateUI object:nil queue:nil usingBlock:^(NSNotification *note) {
        [collectionViewItems reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self deselectAllItems];
    [collectionViewItems reloadData];
    
    [strings fadeIn:2];
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

-(void)addStatsView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"stats" owner:self options:nil];
    
    statsView = (SMStatsView *)nibViews[0];
    
    NSLog(@"%f", statsView.frame.size.height);
    
    [statsView setup];
    
    [self.view addSubview:statsView];
    
    [statsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statsTapped)]];
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
    RRDiamondCell *cell = (RRDiamondCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [[RRAudioEngine sharedEngine] playSoundNamed:@"click" extension:@"aiff" loop:NO];
    
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    if (item.selected)
    {
        item.selected = NO;
        cell.item = item;
        
        [collectionView performBatchUpdates:^{
            
        } completion:^(BOOL finished) {
        }];
    }else{
        [self deselectAllItems];
        item.selected = YES;
        
        cell.item = item;
        
        [collectionView performBatchUpdates:^{
            
        } completion:^(BOOL finished) {
            [collectionViewItems scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }];

    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRDiamondCell *cell = (RRDiamondCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    item.selected = NO;
    
    cell.item = item;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    return item.selected ? CGSizeMake(320, 144) : CGSizeMake(320, 44);
}

-(void)statsTapped
{
    [[RRAudioEngine sharedEngine] playSoundNamed:@"click" extension:@"aiff" loop:NO];
    
    [self deselectAllItems];
    [collectionViewItems reloadData];
}

-(void)deselectAllItems
{
    for (RRItem *item in [RRGame sharedGame].availableItems){
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
    NSString *bankLocation = [RRGame sharedGame].availableLocations[0];
    
    if (![[RRGame sharedGame].location isEqualToString:bankLocation]) {
        // Show
        [self showHUDWithTitle:@"Cannot access bank." detail:[NSString stringWithFormat:@"%@ is not where you want to manage your finances. Go back to %@.", [RRGame sharedGame].location, bankLocation] autoDismiss:NO image:[UIImage imageNamed:@"debeers"]];
        return;
    }
    
    RRBankViewController *bankView = [[RRBankViewController alloc] initWithNibName:@"RRBankViewController" bundle:[NSBundle mainBundle]];
    
    JLBPartialModal *modal = [JLBPartialModal sharedInstance];
    modal.delegate = bankView;
    [modal presentViewController:bankView dismissal:^{
        
    }];

}

- (IBAction)travel:(id)sender {    
    RRTravelViewController *travelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"travelVC"];
    
    [self presentViewController:travelVC animated:YES completion:nil];
}

- (IBAction)brief:(id)sender {
    
    
    RRBriefcaseViewController *brief = [[RRBriefcaseViewController alloc] initWithNibName:@"brief" bundle:[NSBundle mainBundle]];
    
    JLBPartialModal *modal = [JLBPartialModal sharedInstance];
    modal.delegate = brief;
    [modal presentViewController:brief dismissal:^{
        
    }];
}

-(void)showHUDWithTitle:(NSString *)title detail:(NSString *)detail autoDismiss:(BOOL)autoDismiss image:(UIImage *)image
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = title;
    hud.detailsLabelText = detail;
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.color = [UIColor whiteColor];
    
    hud.dimBackground = YES;
    
    hud.labelFont = [UIFont fontWithName:@"Avenir" size:18];
    hud.detailsLabelFont = [UIFont fontWithName:@"Avenir" size:14];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    imageView.image = image;
    hud.customView = imageView;
    
    if (autoDismiss){
        [hud hide:YES afterDelay:3];
    }else{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD:)];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [hud addGestureRecognizer:tap];
        });
    }
}

-(void)hideHUD:(UITapGestureRecognizer *)tap
{
    MBProgressHUD *hud = (MBProgressHUD *)tap.view;
    [hud removeGestureRecognizer:tap];
    [hud hide:YES];
}

@end
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
#import "RRDiamondCell.h"

#import "RRAudioEngine.h"

@interface RRMarketViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RRTravelViewControllerDelegate>
{
    SMStatsView *statsView;
    RRTravelViewController *travelController;
}

@property (strong, nonatomic) IBOutlet UILabel *countryLabel;

@end

@implementation RRMarketViewController
{
    __weak IBOutlet UICollectionView *collectionViewItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    collectionViewItems.allowsMultipleSelection = NO;
    [collectionViewItems registerNib:[UINib nibWithNibName:@"diamondCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"diamondCell"];
    
    self.countryLabel.text = @"Switzerland";

    
    [RRGame sharedGame];
    [[RRGame sharedGame] newGame];
    
    [self addStatsView];
    
    //music
    [[RRAudioEngine sharedEngine] playSoundNamed:@"strings" extension:@"wav" loop:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [collectionViewItems reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)buy:(UIButton *)sender
{
    //select item
    RRItem *item = [self selectedItem];
    
    item.hasItem = YES;
    
    [[RRGame sharedGame].player.inventory addObject:item];
    [RRGame sharedGame].player.money -= item.value;
    
    [collectionViewItems reloadData];
    
    NSLog(@"Inventory: %@", [RRGame sharedGame].player.inventory);
}

- (IBAction)sell:(id)sender {
    //select item
    RRItem *item = [self selectedItem];
    
    [RRGame sharedGame].player.money += item.value;
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
    [self deselectAllItems];
    
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    item.selected = YES;
    
    [collectionViewItems reloadData];
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

#pragma mark PrepereSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"travel"]) {
        travelController = (RRTravelViewController *)segue.destinationViewController;
        travelController.delegate = self;
    }
}

- (IBAction)bank:(id)sender
{
    RRBankViewController *bankView = [[RRBankViewController alloc] initWithNibName:@"RRBankViewController" bundle:[NSBundle mainBundle]];
    
    JLBPartialModal *modal = [JLBPartialModal sharedInstance];
    modal.delegate = bankView;
    [modal presentViewController:bankView dismissal:^{
        
    }];

}

#pragma mark RRTravelViewCOntrollerDelegate

-(void)controllerDidDismiss:(RRTravelViewController *)controller withInfo:(NSString *)country{
    self.countryLabel.text = country;
    [controller dismissViewControllerAnimated:YES completion:^{
        [[RRGame sharedGame] advanceDay];
        
    }];
    
}

@end
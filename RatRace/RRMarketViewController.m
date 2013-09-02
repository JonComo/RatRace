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

@interface RRMarketViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    SMStatsView *statsView;
}

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
    
    [RRGame sharedGame];
    [[RRGame sharedGame] newGame];
    
    [self addStatsView];
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
    
    [statsView setup];
    
    [self.view addSubview:statsView];
}

- (IBAction)buy:(UIButton *)sender
{
    NSArray *selected = collectionViewItems.indexPathsForSelectedItems;
    
    if (selected.count == 0) return;
    
    NSIndexPath *indexPath = selected[0];
    
    //select item
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    [[RRGame sharedGame].player.inventory addObject:item];
    [RRGame sharedGame].player.money -= item.value;
    
    //[statsView update];
    
    NSLog(@"Inventory: %@", [RRGame sharedGame].player.inventory);
}

- (IBAction)sell:(id)sender {
    NSArray *selected = collectionViewItems.indexPathsForSelectedItems;
    
    if (selected.count == 0) return;
    
    NSIndexPath *indexPath = selected[0];
    
    //select item
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    [RRGame sharedGame].player.money += item.value;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%@ $%.2f", item.name, item.value];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [RRGame sharedGame].availableItems.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionViewItems cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionViewItems cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
}

@end
//
//  RRTravelViewController.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRTravelViewController.h"

#import "RRGame.h"

@interface RRTravelViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    __weak IBOutlet UICollectionView *collectionViewCountries;
}

@end

@implementation RRTravelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [collectionViewCountries reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *location = [RRGame sharedGame].availableLocations[indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = location;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [RRGame sharedGame].availableLocations.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //select item
    
    NSString *location = [RRGame sharedGame].availableLocations[indexPath.row];
    
    [[RRGame sharedGame] changeToLocation:location];
    
    if ([self.delegate respondsToSelector:@selector(controllerDidDismiss:)]) {
        [self.delegate controllerDidDismiss:self];
    }
    
}


@end

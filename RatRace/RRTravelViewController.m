//
//  RRTravelViewController.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRTravelViewController.h"

#import "RRAudioEngine.h"

#import "RRGame.h"

@interface RRTravelViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    __weak IBOutlet UICollectionView *collectionViewCountries;
    RRAudioPlayer *plane;
}

@end

@implementation RRTravelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[RRAudioEngine sharedEngine] playSoundNamed:@"ding" extension:@"aiff" loop:NO];
    
    plane = [[RRAudioEngine sharedEngine] playSoundNamed:@"planeAmbient" extension:@"aiff" loop:YES];
    plane.volume = 0;
    
    [collectionViewCountries reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [plane fadeIn:1];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[RRAudioEngine sharedEngine] playSoundNamed:@"jet" extension:@"aiff" loop:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [plane fadeOut:3];
    plane.numberOfLoops = 0;
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
    
    if ([self.delegate respondsToSelector:@selector(controllerDidDismiss:withInfo:)]) {
        [self.delegate controllerDidDismiss:self withInfo:[RRGame sharedGame].availableLocations[indexPath.row]];
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, self.view.frame.size.height / [RRGame sharedGame].availableLocations.count);
}


@end

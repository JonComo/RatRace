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
    NSMutableArray *locations;
    RRAudioPlayer *plane;
}

@end

@implementation RRTravelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[RRAudioEngine sharedEngine] playSoundNamed:@"ding" extension:@"aiff" loop:NO];
    
    locations = [[RRGame sharedGame].availableLocations mutableCopy];
    
    //[self removeCurrentLocation];
    
    plane = [[RRAudioEngine sharedEngine] playSoundNamed:@"planeAmbient" extension:@"aiff" loop:YES];
    plane.volume = 0;
    
    [collectionViewCountries reloadData];
}

-(void)removeCurrentLocation
{
    NSString *locationToRemove;
    for (NSString *location in locations)
    {
        if ([[RRGame sharedGame].location isEqualToString:location])
        {
            locationToRemove = location;
        }
    }
    
    [locations removeObject:locationToRemove];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [plane fadeIn:1];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [plane fadeOut:1];
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
    
    NSString *location = locations[indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%@%@", [[RRGame sharedGame].location isEqualToString:location] ? @"<" : @"", location];
    
    UIImageView *image = (UIImageView *)[cell viewWithTag:200];
    image.image = [UIImage imageNamed:location];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return locations.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //select item
    NSString *location = locations[indexPath.row];
    
    if ([location isEqualToString:[RRGame sharedGame].location])
    {
        //just go back
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [RRGame sharedGame].location = location;
    
    [[RRGame sharedGame] advanceDay];
    
    [[RRAudioEngine sharedEngine] playSoundNamed:@"click" extension:@"aiff" loop:NO];
    [[RRAudioEngine sharedEngine] playSoundNamed:@"jet" extension:@"aiff" loop:NO];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, (int)(self.view.frame.size.height / locations.count + 1) - 2);
}


@end

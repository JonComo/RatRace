//
//  RRPackListViewController.m
//  RatRace
//
//  Created by David de Jesus on 9/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPackListViewController.h"
#import "RRPackCell.h"

@interface RRPackListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    __weak IBOutlet UICollectionView *packCollectionView;
}

@end

@implementation RRPackListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRPackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"packCell" forIndexPath:indexPath];
    
    return cell;
}



@end

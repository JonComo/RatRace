//
//  RRPackListViewController.m
//  RatRace
//
//  Created by David de Jesus on 9/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRPackListViewController.h"
#import "RRPackCell.h"

//
#import "RRPackArtist.h"
#import "RRPackDiamond.h"

#import "RRGame.h"
#import "RRMarketViewController.h"

@interface RRPackListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    __weak IBOutlet UICollectionView *packCollectionView;
    NSArray *packs;
}

@end

@implementation RRPackListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [packCollectionView registerNib:[UINib nibWithNibName:@"packCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"packCell"];
    
    packs = @[[RRPackDiamond details], [RRPackArtist details]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"playGame" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [RRGame clearGame];
        [[RRGame sharedGame] newGameWithOptions:note.object];
        
        RRMarketViewController *marketVC = [self.storyboard instantiateViewControllerWithIdentifier:@"marketVC"];
        [self presentViewController:marketVC animated:YES completion:nil];
        
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return packs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRPackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"packCell" forIndexPath:indexPath];
    
    cell.details = packs[indexPath.row];
    
    return cell;
}



@end

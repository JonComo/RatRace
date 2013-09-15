//
//  RRHistoryViewController.m
//  RatRace
//
//  Created by Jon Como on 9/15/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRHistoryViewController.h"

#import "RRHistoryCell.h"

#import "RRGraphics.h"
#import "RRButtonSound.h"

#import "RRStats.h"

@interface RRHistoryViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet UICollectionView *collectionViewCells;
    
    __weak IBOutlet RRButtonSound *buttonDone;
    
    NSArray *history;
}

@end

@implementation RRHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [collectionViewCells registerNib:[UINib nibWithNibName:@"historyCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"historyCell"];
    
    [RRGraphics buttonStyle:buttonDone];
    
    history = [RRStats history];
    [collectionViewCells reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRHistoryCell *cell = [collectionViewCells dequeueReusableCellWithReuseIdentifier:@"historyCell" forIndexPath:indexPath];
    
    NSDictionary *stats = history[indexPath.row];
    
    cell.gameStats = stats;
    
    if (indexPath.row == history.count-1)
    {
        //last cell, no sep
        cell.showSeperator = NO;
    }else{
        cell.showSeperator = YES;
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return history.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 160);
}

@end

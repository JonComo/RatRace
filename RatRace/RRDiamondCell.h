//
//  RRDiamondCell.h
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRDiamondCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *diamondLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

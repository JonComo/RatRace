//
//  RRHistoryCell.h
//  RatRace
//
//  Created by Jon Como on 9/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRHistoryCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *gameStats;

@property (nonatomic, assign) BOOL showSeperator;

@end

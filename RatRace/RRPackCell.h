//
//  RRPackCell.h
//  RatRace
//
//  Created by David de Jesus on 9/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRButtonSound.h"

@interface RRPackCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelMain;
@property (nonatomic, weak) IBOutlet UILabel *labelDetail;
@property (nonatomic, weak) IBOutlet UIImageView *imageMain;
@property (nonatomic, weak) RRButtonSound *buttonSelect;
@property (nonatomic, copy) NSMutableDictionary *details;

-(void)setDetails:(NSMutableDictionary *)details;

@end

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
{
    __weak IBOutlet UIImageView *imageMain;
    __weak IBOutlet UILabel *labelMain;
    __weak IBOutlet UILabel *labelDetail;
}

@property (nonatomic, weak) IBOutlet UIButton *buttonUnlock;
@property (nonatomic, copy) NSMutableDictionary *details;

@end

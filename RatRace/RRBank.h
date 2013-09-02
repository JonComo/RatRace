//
//  RRBank.h
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRBank : NSObject

@property float loan;
@property float interest;

+(RRBank *)loanAmount:(float)loan withInterest:(float)interest;

- (void)incrementLoan;
- (void)borrow:(float)amount;
- (void)payLoan:(float)amount;


@end

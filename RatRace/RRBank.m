//
//  RRBank.m
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRBank.h"

@implementation RRBank

+(RRBank *)loanAmount:(float)loan withInterest:(float)interest
{
    RRBank *bank = [RRBank new];
    bank.loan = loan;
    bank.interest = interest;
    return bank;
}

- (float)calculateInterest
{
    float calc;
    calc = self.loan * self.interest;
    return calc;
}

- (void)incrementLoan
{
    self.loan += [self calculateInterest];
}

- (void)payLoan:(float)amount
{
    self.loan = self.loan - amount;
    self.loan = MAX(0, self.loan);
}

- (void)borrow:(float)amount
{
    self.loan = self.loan + amount;
}

@end

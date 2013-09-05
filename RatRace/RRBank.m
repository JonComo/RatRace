//
//  RRBank.m
//  RatRace
//
//  Created by David de Jesus on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRBank.h"

#import "RRGame.h"

@implementation RRBank

+(RRBank *)bankWithLoanAmount:(float)loan withInterest:(float)interest limit:(float)limit
{
    RRBank *bank = [RRBank new];
    bank.loan = loan;
    bank.interest = interest;
    bank.loanLimit = limit;
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
    self.loan += amount;
    
    [RRGame sharedGame].player.money += amount;
}

@end

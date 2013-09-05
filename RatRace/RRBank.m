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
    float currentLoan = [RRGame sharedGame].bank.loan;
    
    NSLog(@"Loan: %f amount:%f", currentLoan, amount);
    
    if (currentLoan < amount)
    {
        float diff = amount - currentLoan;
        
        NSLog(@"Payed difference: %f" , (amount - diff));
        
        [RRGame sharedGame].player.money -= (amount - diff);
        [RRGame sharedGame].bank.loan -= (amount - diff);
        
    }else{
        NSLog(@"Payed full amount");
        [RRGame sharedGame].player.money -= amount;
        [RRGame sharedGame].bank.loan -= amount;
        
    }
}

- (void)borrow:(float)amount
{
    float currentLoan = [RRGame sharedGame].bank.loan;
    float limit = [RRGame sharedGame].bank.loanLimit;
    
    if (currentLoan + amount > limit) {
        float diff = (currentLoan + amount) - limit;
        
        [RRGame sharedGame].bank.loan += (amount - diff);
        [RRGame sharedGame].player.money += (amount - diff);
    }else{
        [RRGame sharedGame].bank.loan += amount;
        [RRGame sharedGame].player.money += amount;
    }
}

@end

//
//  RRStoreManager.m
//  RatRace
//
//  Created by Jon Como on 9/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRStoreManager.h"

#import <StoreKit/StoreKit.h>

#define PRODUCTS @[@"com.unmd76.theMerchant.packArtDealer", @"com.unmd76.theMerchant.handbagDealer"]

@interface RRStoreManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    productCompletion gotProducts;
}

@end

@implementation RRStoreManager
{
    SKProductsRequest *productRequest;
}

+(RRStoreManager *)store
{
    static RRStoreManager *store;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[self alloc] init];
    });
    
    return store;
}

-(id)init
{
    if (self = [super init]) {
        //init
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

-(void)requestProdcutsCompletion:(productCompletion)block
{
    gotProducts = block;
    
    NSSet *products = [NSSet setWithArray:PRODUCTS];
    productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:products];
    
    [productRequest setDelegate:self];
    
    [productRequest start];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    
    if (gotProducts) gotProducts(self.products);
}

-(void)buyProductWithID:(NSString *)productID completion:(void (^)(BOOL))purchaseHandler
{
    SKPayment *payment;
    
    for (SKProduct *product in self.products)
    {
        if ([product.productIdentifier isEqualToString:productID])
        {
            payment = [SKPayment paymentWithProduct:product];
        }
    }
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                
                //bought, so unlock
                
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                //Failed, don't unlock
                
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

@end
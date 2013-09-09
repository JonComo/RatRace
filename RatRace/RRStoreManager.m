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

@interface RRStoreManager () <SKProductsRequestDelegate>
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
    for (SKProduct *product in response.products)
    {
        
    }
    
    if (gotProducts) gotProducts(response.products);
}

@end
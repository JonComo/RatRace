//
//  RRStoreManager.h
//  RatRace
//
//  Created by Jon Como on 9/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKProduct;

typedef void (^productCompletion)(NSArray *prodcuts);

@interface RRStoreManager : NSObject

@property (nonatomic, strong) NSArray *products;

+(RRStoreManager *)store;

-(void)requestProdcutsCompletion:(productCompletion)block;

-(void)buyProductWithID:(NSString *)productID completion:(void(^)(BOOL success))purchaseHandler;

@end
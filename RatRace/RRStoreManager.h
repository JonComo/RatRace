//
//  RRStoreManager.h
//  RatRace
//
//  Created by Jon Como on 9/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^productCompletion)(NSArray *prodcuts);

@interface RRStoreManager : NSObject

+(RRStoreManager *)store;

-(void)requestProdcutsCompletion:(productCompletion)block;

@end
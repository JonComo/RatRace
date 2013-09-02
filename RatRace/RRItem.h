//
//  RRItem.h
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRItem : NSObject

@property (nonatomic, strong) NSString *name;
@property float value;
@property int amount;

+(RRItem *)item:(NSString *)name value:(float)value;

@end
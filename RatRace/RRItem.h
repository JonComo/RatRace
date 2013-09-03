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
@property BOOL hasItem;
@property BOOL selected;
@property (nonatomic, weak) UILabel *label;

+(RRItem *)item:(NSString *)name value:(float)value;

@end
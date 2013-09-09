//
//  RRGraphics.m
//  RatRace
//
//  Created by David de Jesus on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRGraphics.h"

@implementation RRGraphics

+(void)buttonStyle:(UIButton *)button
{
    [button setBackgroundImage:[RRGraphics resizableBorderImageName:@"border"] forState:UIControlStateNormal];
}

+(void)buttonStyleDark:(UIButton *)button
{
    [button setBackgroundImage:[RRGraphics resizableBorderImageName:@"borderDark"] forState:UIControlStateNormal];
}

+(UIImage *)resizableBorderImageName:(NSString *)name
{
    return [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
}

@end

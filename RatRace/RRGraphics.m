//
//  RRGraphics.m
//  RatRace
//
//  Created by David de Jesus on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRGraphics.h"

@implementation RRGraphics

+(void)load
{
    
}

+(void)buttonStyle:(UIButton *)button
{
    [button setBackgroundImage:[RRGraphics resizableBorderImage] forState:UIControlStateNormal];
}

+(UIImage *)resizableBorderImage
{
    return [[UIImage imageNamed:@"border"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
}

@end

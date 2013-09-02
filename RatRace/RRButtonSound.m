//
//  RRButtonSound.m
//  RatRace
//
//  Created by Jon Como on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRButtonSound.h"

#import "RRAudioEngine.h"

@implementation RRButtonSound

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (!self.soundName)
    {
        self.soundName = @"click";
        self.soundExt = @"aiff";
    }
    
    [[RRAudioEngine sharedEngine] playSoundNamed:self.soundName extension:self.soundExt loop:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

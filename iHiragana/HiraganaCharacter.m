//
//  HiraganaCharacter.m
//  iHiragana
//
//  Created by Nick Schorer on 2/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "HiraganaCharacter.h"

@implementation HiraganaCharacter

-(id)initWithPronounciation:(NSString*)pronounciation picture:(NSString*)picLink description:(NSString*)description andDrawingPNGS:(NSMutableArray *)dPNGs{
    self.characterPronounciation = pronounciation;
    self.characterPNG = picLink;
    self.characterDescription = description;
    self.drawingPNGs = dPNGs;
    return self;
}

@end

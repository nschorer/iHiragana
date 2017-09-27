//
//  HiraganaCharacter.h
//  iHiragana
//
//  Created by Nick Schorer on 2/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HiraganaCharacter : NSObject

@property NSString *characterPronounciation;
@property NSString *characterPNG;
@property NSString *characterDescription;
@property NSMutableArray *drawingPNGs;

-(id)initWithPronounciation:(NSString*)pronounciation picture:(NSString*)picLink description:(NSString*)description andDrawingPNGS:(NSMutableArray*)dPNGs;

@end

//
//  NormalLesson.h
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "Lesson.h"

@interface NormalLesson : Lesson

@property NSMutableArray *hiraganaCharacters;

-(id)initWithTitle:(NSString*)lessonTitle andDescription:(NSString*)lessonDescription andCharacters:(NSMutableArray*)characters;

@end

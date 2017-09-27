//
//  NormalLesson.m
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "NormalLesson.h"

@implementation NormalLesson

-(id)initWithTitle:(NSString *)lessonTitle andDescription:(NSString *)lessonDescription andCharacters:(NSMutableArray *)characters{
    self.title = lessonTitle;
    self.lessonDescription = lessonDescription;
    self.hiraganaCharacters = characters;
    
    return self;
}
@end

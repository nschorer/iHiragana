//
//  AnnouncementLesson.m
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "AnnouncementLesson.h"

@implementation AnnouncementLesson

-(id)initWithTitle:(NSString *)lessonTitle andDescription:(NSString *)lessonDescription{
    self.title = lessonTitle;
    self.lessonDescription = lessonDescription;
    
    return self;
}

@end

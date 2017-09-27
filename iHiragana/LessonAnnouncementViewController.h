//
//  LessonAnnouncementViewController.h
//  iHiragana
//
//  Created by Nick Schorer on 3/5/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnouncementLesson.h"
#import "HiraganaCharacter.h"

@interface LessonAnnouncementViewController : UIViewController

@property IBOutlet UILabel *lessonTitle;
@property IBOutlet UITextView *textView;
@property IBOutlet UIButton *okButton;
@property AnnouncementLesson *lesson;
@property id target;
@property SEL action;

-(void)setTitleandDescription;
-(IBAction)okButtonDidGetPressed:(id)sender;

@end

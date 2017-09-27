//
//  LessonListingViewController.h
//  iHiragana
//
//  Created by Nick Schorer on 2/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalLesson.h"
#import "AnnouncementLesson.h"
#import "LessonDetailViewController.h"
#import "LessonAnnouncementViewController.h"
#import "HiraganaCharacter.h"

@interface LessonListingViewController : UITableViewController

@property int currentLesson;
@property NSMutableArray *lessons;
@property LessonDetailViewController *lessonDetailViewController;
@property LessonAnnouncementViewController *lessonAnnouncementViewController;

@end

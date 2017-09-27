//
//  TitleViewController.h
//  iHiragana
//
//  Created by Nick Schorer on 2/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonListingViewController.h"

@interface TitleViewController : UIViewController

@property LessonListingViewController *lessonListingViewController;
@property IBOutlet UIButton *introductionButton;
@property IBOutlet UIButton *lessonsButton;

-(IBAction)introductionButtonDidGetPressed:(id)sender;
-(IBAction)lessonsButtonDidGetPressed:(id)sender;

@end

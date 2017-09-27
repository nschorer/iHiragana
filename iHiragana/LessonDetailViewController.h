//
//  LessonDetailViewController.h
//  iHiragana
//
//  Created by Nick Schorer on 2/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalLesson.h"
#import "HiraganaCharacter.h"
#import "HiraganaDetailViewController.h"
#import "ReviewLessonViewController.h"
#import "DrawingSelectionViewController.h"

@interface LessonDetailViewController : UIViewController

@property IBOutlet UILabel *lessonTitle;
@property IBOutlet UITextView *textView;
@property IBOutlet UIButton *learnCharacterButton;
@property IBOutlet UIButton *skipToQuizButton;
@property int characterCount;
@property NormalLesson *lesson;
@property NSMutableArray *handDrawnCharacters;
@property BOOL skippedToQuiz;
@property HiraganaDetailViewController *hiraganaDetailViewController;
@property ReviewLessonViewController *reviewLessonViewController;
@property DrawingSelectionViewController *drawingSelectionViewController;
@property id target;
@property SEL action;

-(IBAction)learnCharacterButtonDidGetPressed:(id)sender;
-(IBAction)skipToQuizButtonDidGetPressed:(id)sender;
-(void)setTitleandDescription;
-(void)nextCharacter:(UIImage*)drawing;
-(void)finishLesson:(UIImage*)drawing;

@end

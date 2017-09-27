//
//  ReviewLessonViewController.h
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewLessonViewController : UIViewController <UIAlertViewDelegate>

@property IBOutlet UILabel *statsLabel;
@property IBOutlet UILabel *percentLabel;
@property IBOutlet UIImageView *characterDisplay;
@property IBOutlet UIButton *button1;
@property IBOutlet UIButton *button2;
@property IBOutlet UIButton *button3;
@property IBOutlet UIButton *button4;
@property IBOutlet UIButton *button5;
@property NSMutableArray *picsArray;
@property NSMutableArray *guessesArray;
@property int currentQuestion;
@property int numCorrectAnswered;
@property int correctAnswer;
@property int button1AnswerKey;
@property int button2AnswerKey;
@property int button3AnswerKey;
@property int button4AnswerKey;
@property int button5AnswerKey;
@property id target;
@property SEL action;

-(void)setupPics:(NSArray*)pics andGuesses:(NSArray*)guesses;

-(IBAction)button1DidGetPressed:(id)sender;
-(IBAction)button2DidGetPressed:(id)sender;
-(IBAction)button3DidGetPressed:(id)sender;
-(IBAction)button4DidGetPressed:(id)sender;
-(IBAction)button5DidGetPressed:(id)sender;

@end

//
//  HiraganaDetailViewController.h
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiraganaCharacter.h"
#import "DrawingPracticeViewController.h"

@interface HiraganaDetailViewController : UIViewController

@property IBOutlet UIImageView *characterDisplay;
@property IBOutlet UIButton *drawingButton;
@property IBOutlet UITextView *textView;
@property HiraganaCharacter *hiraganaCharacter;
@property DrawingPracticeViewController *drawingPracticeViewController;
@property id target;
@property SEL action;

-(IBAction)drawingButtonDidGetPressed:(id)sender;

-(void)setImageAndDescriptionAndTitle;
-(void)nextCharacter:(UIImage*)drawing;

@end

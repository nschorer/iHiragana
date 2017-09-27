//
//  DrawingPracticeViewController.h
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//
//  Pixel Color Information retrieved from // This method retrieved from from user Olie at http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
//
//
// Drawing methods from Created by Nick Garcia on 10/29/12.
// Copyright (c) 2012 N-Works Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiraganaCharacter.h"

@interface DrawingPracticeViewController : UIViewController <UIAlertViewDelegate> {
    CGPoint lastPoint;
	CGPoint moveBackTo;
	CGPoint currentPoint;
	CGPoint location;
    NSDate *lastClick;
    BOOL mouseSwiped;
    UIImageView *drawImage;
    BOOL drawing;
    BOOL continuingFromGreen;
    BOOL freeform; //indicates whether the user is drawing the image within the outline or not
    int whereGreenLeftOff;
    int lowestPoint;
    int highestPoint;
    int leftestPoint;
    int rightestPoint;
    int touchesMovedCount;
    CGContextRef newContext;
    unsigned char *newRawData;
    UIColor *currentColor;
}

@property int practiceCounter;
@property int currentPNG;
@property HiraganaCharacter *hiraganaCharacter;
@property IBOutlet UIImageView *characterDisplay;
@property IBOutlet UIButton *nextButton;
@property IBOutlet UILabel *numTimesDrawLabel;
@property NSString *characterPng;
// I was having a weird issue where characterPng was becoming characterDisplay
@property NSString *otherString;
@property UIButton *showCharacterButton;
@property id target;
@property SEL action;

-(void)setupDisplay;
-(void)didPressBackButton;
-(IBAction)nextButtonDidGetPressed:(id)sender;

// This method retrieved from from user Olie at http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
-(UIColor*)getRGB_AtX:(int)xx andY:(int)yy;


@end

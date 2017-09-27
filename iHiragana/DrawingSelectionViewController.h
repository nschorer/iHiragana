//
//  DrawingSelectionViewController.h
//  iHiragana
//
//  Created by Nick Schorer on 3/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingSelectionViewController : UIViewController <UIAlertViewDelegate>{
    int arrayIndex;
}

@property IBOutlet UIButton *selectButton;
@property IBOutlet UIButton *leftButton;
@property IBOutlet UIButton *rightButton;
@property IBOutlet UIImageView *characterView;
@property NSMutableArray *drawingsArray;
@property UIImage *savedImage;
@property id target;
@property SEL action;

-(IBAction)selectButtonDidGetPressed:(id)sender;
-(IBAction)leftButtonDidGetPressed:(id)sender;
-(IBAction)rightButtonDidGetPressed:(id)sender;
-(void)setupImages:(NSMutableArray*)drawings;

@end

//
//  DrawingSelectionViewController.m
//  iHiragana
//
//  Created by Nick Schorer on 3/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "DrawingSelectionViewController.h"

@interface DrawingSelectionViewController ()

@end

@implementation DrawingSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.drawingsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(IBAction)selectButtonDidGetPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you sure this is your favorite drawing? It will be displayed in the lessons table." delegate:self cancelButtonTitle:@"Wait..." otherButtonTitles:@"Yup", nil];
    [alert show];
}

-(IBAction)leftButtonDidGetPressed:(id)sender{
    int arraySize = (int)[self.drawingsArray count];
    arrayIndex += (arraySize - 1);
    arrayIndex %= arraySize;
    [self.characterView setImage:[self.drawingsArray objectAtIndex:arrayIndex]];
}

-(IBAction)rightButtonDidGetPressed:(id)sender{
    int arraySize = (int)[self.drawingsArray count];
    arrayIndex += (arraySize + 1);
    arrayIndex %= arraySize;
    [self.characterView setImage:[self.drawingsArray objectAtIndex:arrayIndex]];
}

-(void)setupImages:(NSMutableArray *)drawings{
    
    self.drawingsArray = drawings;
    UIImage *temp = [self.drawingsArray objectAtIndex:0];
    self.savedImage = temp;
    arrayIndex = 0;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    arrayIndex = 0;
    [self.characterView setImage:self.savedImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        // Save the drawing!!!
        
        [self.navigationController popViewControllerAnimated:NO];
        [self.target performSelector:self.action withObject:self.characterView.image];
    }
}

@end

//
//  HiraganaDetailViewController.m
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "HiraganaDetailViewController.h"

@interface HiraganaDetailViewController ()

@end

@implementation HiraganaDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        #pragma GCC diagnostic ignored "-Wundeclared-selector"
        self.drawingPracticeViewController = [[DrawingPracticeViewController alloc] initWithNibName:@"DrawingPracticeViewController" bundle:nil];
        self.drawingPracticeViewController.target = self;
        self.drawingPracticeViewController.action = @selector(nextCharacter:);
    }
    return self;
}

-(IBAction)drawingButtonDidGetPressed:(id)sender{
    //NSString* pictureString = [NSString stringWithFormat:@"%@",self.hiraganaCharacter.characterPNG];
    NSString* temp = [[NSString alloc] initWithFormat:@"%@", self.hiraganaCharacter.characterPNG];
    
    // Should everything below this be in the DrawingPracticeViewController.m
    [self.drawingPracticeViewController setHiraganaCharacter:self.hiraganaCharacter];
    [self.drawingPracticeViewController setCharacterPng:temp];
    [self.drawingPracticeViewController setupDisplay];
    [self.navigationController pushViewController:self.drawingPracticeViewController animated:YES];
    
}

-(void)setImageAndDescriptionAndTitle{
    
    NSString *fileLocation = [[NSBundle mainBundle] pathForResource:self.hiraganaCharacter.characterPNG ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
    UIImage *charPic = [UIImage imageWithData:imageData];
    
    //UIImage *charPic = [UIImage imageNamed:self.hiraganaCharacter.characterPNG];
    
    [self.characterDisplay setImage:charPic];
    [self.textView setText:self.hiraganaCharacter.characterDescription];
    [self.navigationItem setTitle:self.hiraganaCharacter.characterPronounciation];
}

-(void)nextCharacter:(UIImage*)drawing{
    [self.navigationController popViewControllerAnimated:NO];
    
    /*
    SEL selector = self.action;
    IMP imp = [self.target methodForSelector:selector];
    void (*func)(id, SEL) = (void*)imp;
    func(self.target, selector);
    */
     
    [self.target performSelector:self.action withObject:drawing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Retrieve Image
    
    NSString *fileLocation = [[NSBundle mainBundle] pathForResource:self.hiraganaCharacter.characterPNG ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
    UIImage *charPic = [UIImage imageWithData:imageData];
    
    //UIImage *charPic = [UIImage imageNamed:self.hiraganaCharacter.characterPNG];
    [self.characterDisplay setImage:charPic];
    [self.textView setText:self.hiraganaCharacter.characterDescription];
    [self.navigationItem setTitle:self.hiraganaCharacter.characterPronounciation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  LessonDetailViewController.m
//  iHiragana
//
//  Created by Nick Schorer on 2/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "LessonDetailViewController.h"

@interface LessonDetailViewController ()

@end

@implementation LessonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        #pragma GCC diagnostic ignored "-Wundeclared-selector"
        
        // Set up transition from character detail screen to next character screen
        self.hiraganaDetailViewController = [[HiraganaDetailViewController alloc] initWithNibName:@"HiraganaDetailViewController" bundle:nil];
        self.hiraganaDetailViewController.target = self;
        self.hiraganaDetailViewController.action = @selector(nextCharacter:);
        
        // Set up transition from review character screen to drawing selection screen
        self.reviewLessonViewController = [[ReviewLessonViewController alloc] initWithNibName:@"ReviewLessonViewController" bundle:nil];
        self.reviewLessonViewController.target = self;
        self.reviewLessonViewController.action = @selector(goToDrawingSelectionScreen);
        
        // Set up transition from drawing selection screen back to lesson select list
        self.drawingSelectionViewController = [[DrawingSelectionViewController alloc] initWithNibName:@"DrawingSelectionViewController" bundle:nil];
        self.drawingSelectionViewController.target = self;
        self.drawingSelectionViewController.action = @selector(finishLesson:);
        
        self.characterCount = 0;
        
        //[self.lessonTitle setFont:[UIFont systemFontOfSize:40]];
        [self.lessonTitle setFont:[self.lessonTitle.font fontWithSize:40]];
        [self.lessonTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [self.lessonTitle setNumberOfLines:0];
        
        self.textView.editable = NO;
        
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back to Lessons" style:UIBarButtonItemStylePlain target:self action:@selector(resetCount)]];
    }
    return self;
}

-(IBAction)learnCharacterButtonDidGetPressed:(id)sender{
    
    // If we still have another character to learn in the lesson, then present the next details
    if (self.characterCount < [self.lesson.hiraganaCharacters count]){
        HiraganaCharacter *temp = [self.lesson.hiraganaCharacters objectAtIndex:self.characterCount];
    
        // Push the view controller.
        [self.hiraganaDetailViewController setHiraganaCharacter:temp];
        [self.navigationController pushViewController:self.hiraganaDetailViewController animated:YES];
        [self.hiraganaDetailViewController setImageAndDescriptionAndTitle];
        
    // Otherwise, grab the information needed for the review quiz (the characters, and the pronounciations)
    }else{
        NSMutableArray *picsArray = [[NSMutableArray alloc] init];
        NSMutableArray *guessesArray = [[NSMutableArray alloc] init];
        
        for (int i=0;i<[self.lesson.hiraganaCharacters count];i++){
            
            HiraganaCharacter *currentCharacter = [self.lesson.hiraganaCharacters objectAtIndex:i];
            NSString *grabStringName, *grabPronounciationName;
            
            grabStringName = [currentCharacter characterPNG];
            [picsArray addObject:grabStringName];
            
            grabPronounciationName = [currentCharacter characterPronounciation];
            [guessesArray addObject:grabPronounciationName];
            
        }
        
        [self.reviewLessonViewController setupPics:picsArray andGuesses:guessesArray];
        [self.navigationController pushViewController:self.reviewLessonViewController animated:YES];
    }
}

// User has decided to skip the lesson portion and go straight to the review quiz
-(IBAction)skipToQuizButtonDidGetPressed:(id)sender{
    [self setCharacterCount:(int)[self.lesson.hiraganaCharacters count]];
    [self setSkippedToQuiz:YES];
    [self.navigationController pushViewController:self.reviewLessonViewController animated:YES];
}

// Should be called before lesson is opened
-(void)setTitleandDescription{
    [self.lessonTitle setText:self.lesson.title];
    [self.textView setText:self.lesson.lessonDescription];
}

// Load the next character in the lesson
-(void)nextCharacter:(UIImage*)drawing{
    self.characterCount += 1;
    [self.handDrawnCharacters addObject:drawing]; //add the previous character's drawing before setting up next lesson
    
    if (self.characterCount < [self.lesson.hiraganaCharacters count]){
        HiraganaCharacter *temp = [self.lesson.hiraganaCharacters objectAtIndex:self.characterCount];
        
        // Push the view controller.
        [self.hiraganaDetailViewController setHiraganaCharacter:temp];
        [self.navigationController pushViewController:self.hiraganaDetailViewController animated:YES];
        [self.hiraganaDetailViewController setImageAndDescriptionAndTitle];
    }else{
        [self.navigationController pushViewController:self.reviewLessonViewController animated:YES];
        [self.drawingSelectionViewController setupImages:self.handDrawnCharacters];
    }
    
    
}

// Let user choose their favorite drawing to display next to the lesson
-(void)goToDrawingSelectionScreen{
    if (!self.skippedToQuiz){
        [self.navigationController pushViewController:self.drawingSelectionViewController animated:YES];
    // If user only did the quiz and no drawings, then just finish the lesson
    }else{
        UIImage* dummyImage;
        [self finishLesson:dummyImage];
    }
    
}

// End the lesson by returning to the lesson list and saving favorite drawing
-(void)finishLesson:(UIImage*)drawing{
    [self.navigationController popViewControllerAnimated:YES];
    self.characterCount = 0;
    [self.handDrawnCharacters removeAllObjects];
    [self setSkippedToQuiz:NO]; //this seems wrong
    [self.target performSelector:self.action withObject:drawing];
}

// Clean up when returning to lesson list
-(void)resetCount{
    self.characterCount = 0;
    [self.handDrawnCharacters removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.skipToQuizButton setEnabled:NO];
    
    // Do any additional setup after loading the view from its nib.
    [self.lessonTitle setTextAlignment: NSTextAlignmentCenter];
    [self.lessonTitle setText:self.lesson.title];

    [self.textView setText:self.lesson.lessonDescription];
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSMutableArray *picsArray = [[NSMutableArray alloc] init];
    NSMutableArray *guessesArray = [[NSMutableArray alloc] init];
    
    
    
    for (int i=0;i<[self.lesson.hiraganaCharacters count];i++){
        
        HiraganaCharacter *currentCharacter = [self.lesson.hiraganaCharacters objectAtIndex:i];
        NSString *grabStringName, *grabPronounciationName;
        
        grabStringName = [currentCharacter characterPNG];
        [picsArray addObject:grabStringName];
        
        grabPronounciationName = [currentCharacter characterPronounciation];
        [guessesArray addObject:grabPronounciationName];
        
    }
    
    if (self.handDrawnCharacters == nil) self.handDrawnCharacters = [[NSMutableArray alloc] init];
    [self.reviewLessonViewController setupPics:picsArray andGuesses:guessesArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ReviewLessonViewController.m
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "ReviewLessonViewController.h"

@interface ReviewLessonViewController ()

@end

@implementation ReviewLessonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.picsArray = [[NSMutableArray alloc] init];
        self.guessesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setupPics:(NSArray *)pics andGuesses:(NSArray *)guesses{
    
    [self.statsLabel setText:[NSString stringWithFormat:@"1/30"]];
    [self.percentLabel setText:@"0%"];
    
    self.correctAnswer = -1;
    self.numCorrectAnswered = 0;
    self.currentQuestion = 1;
    
    [self.picsArray setArray:pics];
    [self.guessesArray setArray:guesses];
    
    [self randomNewQuestion];
    //[self.characterDisplay setImage:[UIImage imageNamed:[self.picsArray objectAtIndex:self.correctAnswer]]];
    
    /*
    [self.button1 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:0]] forState:UIControlStateNormal];
    [self.button2 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:1]] forState:UIControlStateNormal];
    [self.button3 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:2]] forState:UIControlStateNormal];
    [self.button4 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:3]] forState:UIControlStateNormal];
    [self.button5 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:4]] forState:UIControlStateNormal];
     */
}

// Get new question. Make sure it isn't a repeat question.
// If the round is over, evaluate the grade.
-(void)randomNewQuestion{
    if(self.currentQuestion > 30){
        
        UIAlertView* alert;
        
        if (self.numCorrectAnswered >= 27){
            alert = [[UIAlertView alloc] initWithTitle:@"Nice Job!" message:@"Congratulations, you passed! Please click OK to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setTag:20];
            [alert show];
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"Please Try Again" message:@"You must get at least 90% to pass. You can do it!" delegate:self cancelButtonTitle:@"I will persevere!" otherButtonTitles:nil];
            [alert show];
            [self setupPics:self.picsArray andGuesses:self.guessesArray];
        }
        
    }else{
        
        [self.statsLabel setText:[NSString stringWithFormat:@"%d/30",self.currentQuestion]];
        
        int r = arc4random() % [self.guessesArray count];
        while (r == self.correctAnswer){
            r = arc4random() % [self.guessesArray count];
        }
        self.correctAnswer = r;
        
        NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.picsArray objectAtIndex:self.correctAnswer] ofType:nil];
        NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
        UIImage *temp = [UIImage imageWithData:imageData];
        
        //UIImage* temp = [UIImage imageNamed:[self.picsArray objectAtIndex:self.correctAnswer]];
        [self.characterDisplay setImage:temp];
    
    }
}

-(IBAction)finishButtonDidGetPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
    
    SEL selector = self.action;
    IMP imp = [self.target methodForSelector:selector];
    void (*func)(id, SEL) = (void*)imp;
    func(self.target, selector);
    
    //[self.target performSelector:self.action];
}

-(IBAction)button1DidGetPressed:(id)sender{
    if (self.correctAnswer == self.button1AnswerKey){
        self.numCorrectAnswered += 1;
    }else{
        NSString *correctString = [NSString stringWithFormat:@"%@", [self.guessesArray objectAtIndex:self.correctAnswer]];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:[NSString stringWithFormat:@"Sorry, the correct answer was: %@", correctString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    int percentageCorrect = 100 * self.numCorrectAnswered / self.currentQuestion;
    [self.percentLabel setText:[NSString stringWithFormat:@"%d%%", percentageCorrect]];
    
    self.currentQuestion += 1;
    
    [self randomNewQuestion];
}

-(IBAction)button2DidGetPressed:(id)sender{
    if (self.correctAnswer == self.button2AnswerKey){
        self.numCorrectAnswered += 1;
    }else{
        NSString *correctString = [NSString stringWithFormat:@"%@", [self.guessesArray objectAtIndex:self.correctAnswer]];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:[NSString stringWithFormat:@"Sorry, the correct answer was: %@", correctString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    int percentageCorrect = 100 * self.numCorrectAnswered / self.currentQuestion;
    [self.percentLabel setText:[NSString stringWithFormat:@"%d%%", percentageCorrect]];
    
    self.currentQuestion += 1;
    
    [self randomNewQuestion];
}

-(IBAction)button3DidGetPressed:(id)sender{
    if (self.correctAnswer == self.button3AnswerKey){
        self.numCorrectAnswered += 1;
    }else{
        NSString *correctString = [NSString stringWithFormat:@"%@", [self.guessesArray objectAtIndex:self.correctAnswer]];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:[NSString stringWithFormat:@"Sorry, the correct answer was: %@", correctString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    int percentageCorrect = 100 * self.numCorrectAnswered / self.currentQuestion;
    [self.percentLabel setText:[NSString stringWithFormat:@"%d%%", percentageCorrect]];
    
    self.currentQuestion += 1;
    
    [self randomNewQuestion];
}

-(IBAction)button4DidGetPressed:(id)sender{
    if (self.correctAnswer == self.button4AnswerKey){
        self.numCorrectAnswered += 1;
    }else{
        NSString *correctString = [NSString stringWithFormat:@"%@", [self.guessesArray objectAtIndex:self.correctAnswer]];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:[NSString stringWithFormat:@"Sorry, the correct answer was: %@", correctString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    int percentageCorrect = 100 * self.numCorrectAnswered / self.currentQuestion;
    [self.percentLabel setText:[NSString stringWithFormat:@"%d%%", percentageCorrect]];
    
    self.currentQuestion += 1;
    
    [self randomNewQuestion];
}

-(IBAction)button5DidGetPressed:(id)sender{
    if (self.correctAnswer == self.button5AnswerKey){
        self.numCorrectAnswered += 1;
    }else{
        NSString *correctString = [NSString stringWithFormat:@"%@", [self.guessesArray objectAtIndex:self.correctAnswer]];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:[NSString stringWithFormat:@"Sorry, the correct answer was: %@", correctString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    int percentageCorrect = 100 * self.numCorrectAnswered / self.currentQuestion;
    [self.percentLabel setText:[NSString stringWithFormat:@"%d%%", percentageCorrect]];
    
    self.currentQuestion += 1;
    
    [self randomNewQuestion];
}

- (void)viewDidLoad
{
    
    [self.statsLabel setText:[NSString stringWithFormat:@"1/30"]];
    [self.percentLabel setText:@"0%"];
    
    self.correctAnswer = -1;
    self.numCorrectAnswered = 0;
    self.currentQuestion = 1;
    
    [self randomNewQuestion];
    
    NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.picsArray objectAtIndex:self.correctAnswer] ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
    UIImage *temp = [UIImage imageWithData:imageData];
    [self.characterDisplay setImage:temp];
    
    /*
    [self.button1 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:0]] forState:UIControlStateNormal];
    [self.button2 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:1]] forState:UIControlStateNormal];
    [self.button3 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:2]] forState:UIControlStateNormal];
    [self.button4 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:3]] forState:UIControlStateNormal];
    [self.button5 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:4]] forState:UIControlStateNormal];
    */
     
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time to Review!" message:@"You will now be quizzed on the characters you just learned. If you don't answer 90% of the questions, you will be asked to take the quiz again." delegate:self cancelButtonTitle:@"Bring it on!" otherButtonTitles: nil];
    [alert show];
    
    [self randomNewQuestion];
    
    if ([self.guessesArray count] == 5){
        [self.button1 setEnabled:YES];
        [self.button4 setEnabled:YES];
        
        self.button1AnswerKey = 0;
        self.button2AnswerKey = 1;
        self.button3AnswerKey = 2;
        self.button4AnswerKey = 3;
        self.button5AnswerKey = 4;
        
        [self.button1 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:0]] forState:UIControlStateNormal];
        [self.button2 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:1]] forState:UIControlStateNormal];
        [self.button3 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:2]] forState:UIControlStateNormal];
        [self.button4 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:3]] forState:UIControlStateNormal];
        [self.button5 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:4]] forState:UIControlStateNormal];
    }else if ([self.guessesArray count] == 3){
        [self.button1 setEnabled:NO];
        [self.button4 setEnabled:NO];
        
        self.button1AnswerKey = -1;
        self.button2AnswerKey = 0;
        self.button3AnswerKey = 1;
        self.button4AnswerKey = -1;
        self.button5AnswerKey = 2;
        
        [self.button1 setTitle:@"" forState:UIControlStateNormal];
        [self.button2 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:0]] forState:UIControlStateNormal];
        [self.button3 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:1]] forState:UIControlStateNormal];
        [self.button4 setTitle:@"" forState:UIControlStateNormal];
        [self.button5 setTitle:[NSString stringWithFormat: @"%@", [self.guessesArray objectAtIndex:2]] forState:UIControlStateNormal];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 20){
        [self.navigationController popViewControllerAnimated:NO];
        
        SEL selector = self.action;
        IMP imp = [self.target methodForSelector:selector];
        void (*func)(id, SEL) = (void*)imp;
        func(self.target, selector);
        
        //[self.target performSelector:self.action];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

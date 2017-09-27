//
//  LessonAnnouncementViewController.m
//  iHiragana
//
//  Created by Nick Schorer on 3/5/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "LessonAnnouncementViewController.h"

@interface LessonAnnouncementViewController ()

@end

@implementation LessonAnnouncementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.lessonTitle setFont:[UIFont systemFontOfSize:40]];
        [self.lessonTitle setAdjustsFontSizeToFitWidth: NO];
        [self.lessonTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [self.lessonTitle setNumberOfLines:0];
        
        self.textView.editable = NO;
    }
    return self;
}

-(void)setTitleandDescription{
    [self.lessonTitle setText:self.lesson.title];
    [self.textView setText:self.lesson.lessonDescription];
}

-(void)okButtonDidGetPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    SEL selector = self.action;
    IMP imp = [self.target methodForSelector:selector];
    void (*func)(id, SEL) = (void*)imp;
    func(self.target, selector);
    
    //[self.target performSelector:self.action];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.lessonTitle setText:self.lesson.title];
    //[self.lessonTitle setText:self.lesson.title];
    [self.lessonTitle setTextAlignment: NSTextAlignmentCenter];
    
    [self.textView setText:self.lesson.lessonDescription];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

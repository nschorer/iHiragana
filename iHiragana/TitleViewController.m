//
//  TitleViewController.m
//  iHiragana
//
//  Created by Nick Schorer on 2/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "TitleViewController.h"

@interface TitleViewController ()

@end

@implementation TitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Initialize LessonListingViewController
        self.lessonListingViewController = [[LessonListingViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return self;
}

-(IBAction)introductionButtonDidGetPressed:(id)sender{
    NSLog(@"Intro button pressed");
}

-(IBAction)lessonsButtonDidGetPressed:(id)sender{
    NSLog(@"Lessons button pressed");
    [self.navigationController pushViewController: self.lessonListingViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

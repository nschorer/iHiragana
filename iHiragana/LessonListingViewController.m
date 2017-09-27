//
//  LessonListingViewController.m
//  iHiragana
//
//  Created by Nick Schorer on 2/27/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "LessonListingViewController.h"

@interface LessonListingViewController ()

@end

@implementation LessonListingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.lessons = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadLessonTable];
        
        // Initialize the view controller to view an individual lesson
        self.lessonDetailViewController = [[LessonDetailViewController alloc] initWithNibName:@"LessonDetailViewController" bundle:nil];
        self.lessonDetailViewController.target = self;
        self.lessonDetailViewController.action = @selector(finishedLesson:);
        
        self.lessonAnnouncementViewController = [[LessonAnnouncementViewController alloc] initWithNibName:@"LessonAnnouncementViewController" bundle:nil];
        self.lessonAnnouncementViewController.target = self;
        self.lessonAnnouncementViewController.action = @selector(readAnnouncement);
        
        // register the type of view to create for a table cell
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
    }
    return self;
}

// Read in lessons.txt which contains all the lesson info
- (void)loadLessonTable{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lessons" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSArray *listOfLessons = [fileContents componentsSeparatedByString:@"\n"];
    
    [self parseLessonFile:listOfLessons];
}

// At this point, we have an array of lessons.
// Each element in the array corresponds to a newline in the file; each lesson consists of multiple of these newlines.
//
// Now, 
-(void)parseLessonFile:(NSArray*)listOfLessons{
    
    int sizeOfLessonsArray = (int)[listOfLessons count];
    BOOL doneLoading = NO;
    int i = 0;
    
    while (i < sizeOfLessonsArray) {
        
        // DEAL WITH ANNOUNCMENT LESSON
        // Check for &, the marker for announcement lesson
        //NSLog(@"%hu",[[listOfLessons objectAtIndex:i] characterAtIndex:0]);
        if ([[listOfLessons objectAtIndex:i] characterAtIndex:0] == '&'){
            //1. Get the title from the first index of this group (ignore the & character)
            //2. Get the description of the announcement
            //Replace ^ with \n
            //Create the AnnouncementLesson
            //Add the AnnouncementLesson to the lesson array
            NSString *titleString = [listOfLessons[i] substringFromIndex:1];
            NSString *tempString = listOfLessons[i+1];
            NSArray *lessonDescriptionComponents = [tempString componentsSeparatedByString:@"^"];
            NSString *lessonDescriptionString = [lessonDescriptionComponents componentsJoinedByString:@"\n"];
            AnnouncementLesson *addAnnouncementLesson = [[AnnouncementLesson alloc] initWithTitle:titleString andDescription:lessonDescriptionString];
            
            // AnnouncementLessons have two components (title, description).
            // So increment the listOfLessons index by 2
            i+=2;
            [self.lessons addObject:addAnnouncementLesson];
        }
        
        // Safety check. Make sure we don't get Index OOB error
        if (i >= [listOfLessons count]){
            doneLoading = YES;
        }
        
        // DEAL WITH NORMAL LESSON
        // Check for *, the marker for normal lesson
        if (!doneLoading) {
            if ([[listOfLessons objectAtIndex:i] characterAtIndex:0] == '*'){
                //1. Get the title from the first index of this group (ignore the * character)
                //2. Get the description of the lesson
                //Replace ^ with \n
                NSString *titleString = [listOfLessons[i] substringFromIndex:1];
                NSString *tempString = listOfLessons[i+1];
                NSArray *lessonDescriptionComponents = [tempString componentsSeparatedByString:@"^"];
                NSString *lessonDescriptionString = [lessonDescriptionComponents componentsJoinedByString:@"\n"];
                
                // NormalLessons always have these two components (title, description).
                // So increment the listOfLessons index by 2
                i+=2;
                
                //3. Create a separate array to store each of the hiragana characters for the lesson
                NSMutableArray *charactersArray = [[NSMutableArray alloc] initWithCapacity:0];
                
                // Remember: & or * signals the start of a new lesson
                // Stop once we reach the start of the next lesson
                while (i < sizeOfLessonsArray &&
                       [[listOfLessons objectAtIndex:i] characterAtIndex:0] != '&' &&
                       [[listOfLessons objectAtIndex:i] characterAtIndex:0] != '*'){
                    
                    // Check for @, the marker for a hiragana
                    // This one isn't totally necessary at the moment
                    if ([[listOfLessons objectAtIndex:i] characterAtIndex:0] == '@'){
                        //3a. Get the English phonetic equivalent (ignore @)
                        //3b. Get a picture of the hiragana character
                        //3c. Get the description for the character, replace ^ with \n
                        //3d. Get the pictures used to teach stroke order
                        NSString *pronounciationString = [listOfLessons[i] substringFromIndex:1];
                        NSString *pngString = listOfLessons[i+1];
                        NSString *tempString = listOfLessons[i+2];
                        NSString *characterDescriptionString = [[tempString componentsSeparatedByString:@"^"] componentsJoinedByString:@"\n"];
                        NSString *drawingPNGsString = listOfLessons[i+3];
                        NSMutableArray *drawingPNGsArray = [[NSMutableArray alloc] initWithArray:[drawingPNGsString componentsSeparatedByString:@","]];
                        
                        // HiraganaCharacters have four components (pronounciation, picture, description, and pictures for stroke order)
                        i+=4;
                        HiraganaCharacter *addHiraganaCharacter = [[HiraganaCharacter alloc] initWithPronounciation:pronounciationString picture:pngString description:characterDescriptionString andDrawingPNGS:drawingPNGsArray];
                        [charactersArray addObject:addHiraganaCharacter];
                        
                        
                    // Maybe in the future we can add Katakana, which might be preceded by a different symbol
                    }else{
                        NSLog(@"Freak out");
                        i+=1;
                    }
                }
                
                NormalLesson *addNormalLesson = [[NormalLesson alloc] initWithTitle:titleString andDescription:lessonDescriptionString andCharacters:charactersArray];
                [self.lessons addObject:addNormalLesson];
            }
        }
    }
    
}

// Add a checkmark next to the announcement cell after user has read the annoucement
-(void)readAnnouncement{
    NSIndexPath *temp = [NSIndexPath indexPathForRow:self.currentLesson inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:temp];
    UIImageView *checkmarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
    
    [cell setAccessoryView:checkmarkView];
}

// Add a checkmark next to the lesson cell after user has read the announcement
// In addition, display user's favorite drawing of character from lesson
-(void)finishedLesson:(UIImage*)drawing{
    NSIndexPath *temp = [NSIndexPath indexPathForRow:self.currentLesson inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:temp];
    UIImageView *checkmarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
    
    [cell setAccessoryView:checkmarkView];
    if (drawing != nil){
        [cell.imageView setImage:drawing];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.lessons count];
}

// Each cell (row) is named after the title of the corresponding lesson
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Lesson *temp = [self.lessons objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@", temp.title]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    Lesson *temp = [self.lessons objectAtIndex:indexPath.row];
    [self setCurrentLesson:(int)indexPath.row];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    if ([temp isKindOfClass:[NormalLesson class]]){
        NSIndexPath *temp = [NSIndexPath indexPathForRow:self.currentLesson inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:temp];
        
        // If they have completed the lesson before (if there is a checkmark present), then enable the 'skip to quiz' button
        if ([cell accessoryView] == nil){
            [self.lessonDetailViewController.skipToQuizButton setEnabled:NO];
        }else{
            [self.lessonDetailViewController.skipToQuizButton setEnabled:YES];
        }
        
        [self.lessonDetailViewController setSkippedToQuiz:NO];
        
        [self.lessonDetailViewController setHandDrawnCharacters:nil];
        NormalLesson *temp2 = [self.lessons objectAtIndex:indexPath.row];
        [self.lessonDetailViewController setLesson:temp2];
        [self.navigationController pushViewController:self.lessonDetailViewController animated:YES];
        [self.lessonDetailViewController setTitleandDescription];
    }else if ([temp isKindOfClass:[AnnouncementLesson class]]){
        AnnouncementLesson *temp2 = [self.lessons objectAtIndex:indexPath.row];
        [self.lessonAnnouncementViewController setLesson:temp2];
        [self.navigationController pushViewController:self.lessonAnnouncementViewController animated:YES];
        [self.lessonAnnouncementViewController setTitleandDescription];
    }
}
 


@end

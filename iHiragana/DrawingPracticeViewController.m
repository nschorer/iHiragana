//
//  DrawingPracticeViewController.m
//  iHiragana
//
//  Created by Nick Schorer on 2/28/14.
//  Copyright (c) 2014 Nick Schorer. All rights reserved.
//

#import "DrawingPracticeViewController.h"

@interface DrawingPracticeViewController ()

@end

@implementation DrawingPracticeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *temp = [NSString stringWithFormat:@"Draw %d time(s)", self.practiceCounter];
        [self.numTimesDrawLabel setText:temp];
        
        touchesMovedCount = 0;
        
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Character Detail" style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)]];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    return self;
}

-(void)hideCharacter{
    [self.characterDisplay setImage:nil];
}

-(void)showCharacter{
    
    NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.hiraganaCharacter.drawingPNGs objectAtIndex:0] ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
    UIImage *temp = [UIImage imageWithData:imageData];
    
    [self.characterDisplay setImage:temp];
}

- (void)viewDidLoad
{
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(didPressBackButton)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	drawImage.image = [defaults objectForKey:@"drawImageKey"];
	drawImage = [[UIImageView alloc] initWithImage:nil];
	drawImage.frame = self.view.frame;
	[self.view addSubview:drawImage];
    
    drawing = NO;
    continuingFromGreen = NO;
    freeform = NO;
    self.currentPNG = 1;
    self.practiceCounter = 3;
    [self.nextButton setEnabled:NO];
    
    NSString *temp = [NSString stringWithFormat:@"Draw %d time(s)", self.practiceCounter];
    [self.numTimesDrawLabel setText:temp];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.hiraganaCharacter.drawingPNGs objectAtIndex:self.currentPNG] ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
    UIImage *charPic = [UIImage imageWithData:imageData];
    
    [self.characterDisplay setImage:charPic];
    
    CGRect frame = CGRectMake(self.characterDisplay.frame.origin.x, self.nextButton.frame.origin.y + self.nextButton.frame.size.height/2, self.nextButton.frame.size.width, self.nextButton.frame.size.height);
    //CGRect frame = CGRectMake(0, 20, 320, 320);
    self.showCharacterButton = [[UIButton alloc] initWithFrame:frame];
    //[self.showCharacterButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.showCharacterButton addTarget:self action:@selector(hideCharacter) forControlEvents:UIControlEventTouchCancel];
    [self.showCharacterButton addTarget:self action:@selector(hideCharacter) forControlEvents:UIControlEventTouchDragExit];
    [self.showCharacterButton addTarget:self action:@selector(hideCharacter) forControlEvents:UIControlEventTouchUpInside];
    [self.showCharacterButton addTarget:self action:@selector(showCharacter) forControlEvents:UIControlEventTouchDown];
    [self.showCharacterButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.showCharacterButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.showCharacterButton setTitle:@"Show" forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated{
    CGImageRef imageRef = [self.characterDisplay.image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    newRawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    [self createTheContext];
}

-(void)setupDisplay{
    self.currentPNG = 1;
    self.practiceCounter = 3;
    
    NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.hiraganaCharacter.drawingPNGs objectAtIndex:self.currentPNG] ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
    UIImage *charPic = [UIImage imageWithData:imageData];
    
    [self.characterDisplay setImage:charPic];
    NSString *temp = [NSString stringWithFormat:@"Draw %d time(s)", self.practiceCounter];
    [self.numTimesDrawLabel setText:temp];
    self.otherString = [NSString stringWithFormat:@"%@", self.characterPng];
    
    leftestPoint = self.view.frame.origin.x + self.view.frame.size.width*.5;
    rightestPoint = self.view.frame.origin.x + self.view.frame.size.width*.5;;
    lowestPoint = self.view.frame.origin.y + self.view.frame.size.height*.5;
    highestPoint = self.view.frame.origin.y + self.view.frame.size.height*.5;
}
         
-(void)didPressBackButton{
    self.currentPNG = 1;
    self.practiceCounter = 3;
    [self.numTimesDrawLabel setText:[NSString stringWithFormat:@"Draw %d time(s)", self.currentPNG]];
    [self.nextButton setEnabled:NO];
    [drawImage setImage:nil];
    
    if (!freeform){
        free (newRawData);
    }
    
    freeform = NO;
    [self.showCharacterButton removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)finishedDrawingLetter{
    self.practiceCounter --;
    
    // User must trace the outline three times. If they've only done it once or twice, have them start over with a decreased count.
    if (self.practiceCounter > 0){
        self.currentPNG = 1;
        
        NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.hiraganaCharacter.drawingPNGs objectAtIndex:self.currentPNG] ofType:nil];
        NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
        UIImage *charPic = [UIImage imageWithData:imageData];
        
        [self.characterDisplay setImage:charPic];
        [self createTheContext];
        
        
        NSString *temp = [NSString stringWithFormat:@"Draw %d time(s)", self.practiceCounter];
        [self.numTimesDrawLabel setText:temp];
        
    // Once user has traced character three times, have them enter freeform mode where they draw the character without help.
    }else{
        free (newRawData);
        [self.characterDisplay setImage:nil];
        [self.numTimesDrawLabel setText:@""];
        freeform = YES;
        [self.nextButton setEnabled:YES];
        [self.view addSubview:self.showCharacterButton];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well done!"
                                                        message:@"Now try to draw it once without the outline! Double-tap if you need to clear the screen."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// Before moving on to the next character or quiz, save drawn image.
-(IBAction)nextButtonDidGetPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you satisfied with your drawing?" delegate:self cancelButtonTitle:@"Not yet!" otherButtonTitles:@"Yes!", nil];
    [alert setTag:2];
    [alert show];
}

-(void)endDrawingTutorial{
    self.currentPNG = 1;
    self.practiceCounter = 3;
    freeform = NO;
    [self.numTimesDrawLabel setText:[NSString stringWithFormat:@"Draw %d time(s)", self.currentPNG]];
    self.practiceCounter = 3;
    [self.nextButton setEnabled:NO];
    
    int pictureLowestPoint = self.view.frame.origin.y + self.view.frame.size.height;
    int pictureHighestPoint = self.view.frame.origin.y;
    int pictureLeftestPoint = self.view.frame.origin.x;
    int pictureRightestPoint = self.view.frame.origin.x + self.view.frame.size.width;
    
    if (pictureLowestPoint < lowestPoint){
        lowestPoint = pictureLowestPoint;
    }
    if (pictureHighestPoint > highestPoint){
        highestPoint = pictureHighestPoint;
    }
    if (pictureLeftestPoint > leftestPoint) {
        leftestPoint = pictureLeftestPoint;
    }
    if (pictureRightestPoint < rightestPoint){
        rightestPoint = pictureRightestPoint;
    }
    
    CGRect tempFrame = CGRectMake(leftestPoint, highestPoint, rightestPoint-leftestPoint, lowestPoint-highestPoint);
    
    CGImageRef temp = CGImageCreateWithImageInRect(drawImage.image.CGImage, tempFrame);
    
    UIImage *croppedFromCG = [UIImage imageWithCGImage:temp];
    
    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
    
    [croppedFromCG drawInRect:CGRectMake(0,0, 300, 300)];
    
    UIImage *croppedUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRelease(temp);

    
    /*
    SEL selector = self.action;
    IMP imp = [self.target methodForSelector:selector];
    void (*func)(id, SEL) = (void*)imp;
    */
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.target performSelector:self.action withObject:croppedUIImage];
    //func(self.target, selector);
    drawImage.image = nil;
}

// This is used primarily for saving the image the user has drawn.
// Essentially, it's used to make sure that the image we save is centered.
// So, even if the user draws the picture in the top-left corner of the screen,
//     the saved image in the lesson table will be centered.
-(void)updateBorders:(CGPoint)point{
    if (point.x < leftestPoint + 50){
        leftestPoint = point.x - 50;
    }
    if (point.x > rightestPoint - 50){
        rightestPoint = point.x + 50;
    }
    if (point.y < highestPoint + 50){
        highestPoint = point.y - 50;
    }
    if (point.y > lowestPoint - 50) {
        lowestPoint = point.y + 50;
    }
}

// Render the hiragana image
-(void)createTheContext{
    // First get the image into your data buffer
    CGImageRef imageRef = [self.characterDisplay.image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //newRawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    //NSUInteger bytesPerPixel = 4;
    //NSUInteger bytesPerRow = bytesPerPixel * width;
    const int componentsPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bytesPerRow = ((bitsPerComponent * width) / 8) * componentsPerPixel;
    newContext = CGBitmapContextCreate(newRawData, width, height,
                                       bitsPerComponent, bytesPerRow, colorSpace,
                                       kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(newContext, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(newContext);
}

// Borrowed from StackOverflow
-(UIColor*)getColorFromImageContextAtX:(int)xx andY:(int)yy{
    CGImageRef imageRef = [self.characterDisplay.image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    NSUInteger bytesPerPixel = 4;
    //NSUInteger bytesPerRow = bytesPerPixel * width;
    const int componentsPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bytesPerRow = ((bitsPerComponent * width) / 8) * componentsPerPixel;
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    //int realX = xx / self.view.bounds.size.width * width;
	//int realY = yy / self.view.bounds.size.height * height;
    
    int topX = self.view.frame.origin.x;
    int topY = self.view.frame.origin.y;
    int dispX = self.characterDisplay.frame.origin.x - topX;
    int dispY = self.characterDisplay.frame.origin.y - topY;
    
    int realX = (xx - dispX) / self.characterDisplay.frame.size.width * width;
	int realY = (yy - dispY) / self.characterDisplay.frame.size.height * height;
    int byteIndex = (int)((bytesPerRow * realY) + realX * bytesPerPixel);
    //int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    
    CGFloat red   = (newRawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (newRawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (newRawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (newRawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return acolor;
}

// Borrowed from StackOverflow
- (UIColor*)getRGB_AtX:(int)xx andY:(int)yy
{
    
    // First get the image into your data buffer
    CGImageRef imageRef = [self.characterDisplay.image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    //NSUInteger bytesPerRow = bytesPerPixel * width;
    const int componentsPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bytesPerRow = ((bitsPerComponent * width) / 8) * componentsPerPixel;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    //int realX = xx / self.view.bounds.size.width * width;
	//int realY = yy / self.view.bounds.size.height * height;
    
    int topX = self.view.frame.origin.x;
    int topY = self.view.frame.origin.y;
    int dispX = self.characterDisplay.frame.origin.x - topX;
    int dispY = self.characterDisplay.frame.origin.y - topY;
    
    int realX = (xx - dispX) / self.characterDisplay.frame.size.width * width;
	int realY = (yy - dispY) / self.characterDisplay.frame.size.height * height;
    int byteIndex = (int)((bytesPerRow * realY) + realX * bytesPerPixel);
    //int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    free(rawData);
    
    return acolor;
}

// Draws a line based on user's touch.
// NOT CURRENTLY IN USE
-(void)lazyDraw{
    UIGraphicsBeginImageContext(CGSizeMake(320, 568));
    [drawImage.image drawInRect:CGRectMake(0, 0, 320, 568)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 25.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    
    [drawImage setFrame:CGRectMake(0, 0, 320, 568)];
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    lastPoint = currentPoint;
    
    [self.view addSubview:drawImage];
}

// Called when the user first places finger on screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	UITouch *touch = [[event allTouches] anyObject];
	
	location = [touch locationInView:touch.view];
	lastClick = [NSDate date];
	
    lastPoint = [touch locationInView:self.view];
    lastPoint.y -= 0;
    
    // User must draw within the outline
    if (!freeform){
        //UIColor *temp = [self getRGB_AtX:location.x andY:location.y];
        UIColor *temp = [self getColorFromImageContextAtX:location.x andY:location.y];
        const CGFloat *components = CGColorGetComponents(temp.CGColor);
        CGFloat red = 0.0, green = 0.0, blue = 0.0;
        
        red = components[0];
        green = components[1];
        blue = components[2];
        
        touchesMovedCount = 0;
        
        // Only start drawing if the user touches yellow
        if (red == 1.0 && green == 1.0 && blue == 0.0){
            drawing = YES;
        }
        
    // User is drawing without the outline
    }else{
        // Clear the image
        if ([touch tapCount] == 2) {
            drawImage.image = nil;
            
            leftestPoint = self.view.frame.origin.x + self.view.frame.size.width*.5;
            rightestPoint = self.view.frame.origin.x + self.view.frame.size.width*.5;;
            lowestPoint = self.view.frame.origin.y + self.view.frame.size.height*.5;
            highestPoint = self.view.frame.origin.y + self.view.frame.size.height*.5;
        }
        
        [self updateBorders:location];
    }
    
	[super touchesBegan: touches withEvent: event];

	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
    // The user is currently drawing within the outline...
	if (drawing && !freeform){
        
        UITouch *touch = [touches anyObject];
        currentPoint = [touch locationInView:self.view];
        
        //UIColor *temp = [self getRGB_AtX:currentPoint.x andY:currentPoint.y];
        UIColor *temp = [self getColorFromImageContextAtX:currentPoint.x andY:currentPoint.y];
        
        //NSLog(@"RGBA: %f, %f, %f, %f", red,green,blue,alpha);
        
        // Only continue drawing if in yellow (the starting area) or cyan (the body)
        if ([temp isEqual:[UIColor yellowColor]] || [temp isEqual:[UIColor cyanColor]]){
            
            //[self performSelectorInBackground:@selector(lazyDraw) withObject:nil];
            
            //Draw a line tracing user's finger path
            UIGraphicsBeginImageContext(CGSizeMake(320, 568));
            [drawImage.image drawInRect:CGRectMake(0, 0, 320, 568)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 25.0);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1);
            CGContextBeginPath(UIGraphicsGetCurrentContext());
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            
            
            [drawImage setFrame:CGRectMake(0, 0, 320, 568)];
            drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            lastPoint = currentPoint;
            
            [self.view addSubview:drawImage];
            
        }
        
        // If user made it to red (end area), start the next segment
        else if([temp isEqual:[UIColor redColor]]){
            self.currentPNG ++;
            
            
            NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.hiraganaCharacter.drawingPNGs objectAtIndex:self.currentPNG] ofType:nil];
            NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
            UIImage *temp = [UIImage imageWithData:imageData];
            
            [self.characterDisplay setImage:temp];
            drawing = NO;
            continuingFromGreen = NO;
            drawImage.image = nil;
            if (self.currentPNG == [self.hiraganaCharacter.drawingPNGs count] - 1){
                //NSLog(@"We did it!");
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishedDrawingLetter) userInfo:nil repeats:NO];
            }else{
                [self createTheContext];
            }
        }
        
        // Green is like red, in that it is the target area. However, red denotes the end of a stroke,
        // while green denotes that the stroke continues.
        else if ([temp isEqual:[UIColor greenColor]]){
            
            // Remember the first part of this stroke in case we have to reset
            if (!continuingFromGreen){
                whereGreenLeftOff = self.currentPNG;
            }
            self.currentPNG ++;
            
            // Like red, we need to load the next part of the stroke image
            NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.hiraganaCharacter.drawingPNGs objectAtIndex:self.currentPNG] ofType:nil];
            NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
            UIImage *temp = [UIImage imageWithData:imageData];
            
            drawImage.image = nil;
            continuingFromGreen = YES;
            [self.characterDisplay setImage:temp];
            //free (newRawData);
            [self createTheContext];
        }
        
        // If the user goes outside the outline, we need to reset the stroke.
        // For strokes with multiple parts (green sections), make sure we go back to the very first one.
        else{
            drawing = NO;
            if (continuingFromGreen){
                self.currentPNG = whereGreenLeftOff;
                
                NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.hiraganaCharacter.drawingPNGs objectAtIndex:self.currentPNG] ofType:nil];
                NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
                UIImage *temp = [UIImage imageWithData:imageData];
                
                [self.characterDisplay setImage:temp];
                continuingFromGreen = NO;
                //free (newRawData);
                [self createTheContext];
            }
            drawImage.image = nil;
            
        }
        
    }
    
    // Otherwise, user is drawing their own picture
    else if (freeform){
        UITouch *touch = [touches anyObject];
        currentPoint = [touch locationInView:self.view];
        UIGraphicsBeginImageContext(CGSizeMake(320, 568));
        [drawImage.image drawInRect:CGRectMake(0, 0, 320, 568)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 25.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        if (currentPoint.y > self.nextButton.frame.origin.y + self.nextButton.frame.size.height*2){
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
        }else{
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, self.nextButton.frame.origin.y + self.nextButton.frame.size.height*2);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, self.nextButton.frame.origin.y + self.nextButton.frame.size.height*2);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
        }
        
        
        [drawImage setFrame:CGRectMake(0, 0, 320, 568)];
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        lastPoint = currentPoint;
        
        [self updateBorders:currentPoint];
        
        [self.view addSubview:drawImage];
    }
}

// If user lifts their finger
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!freeform){
        drawing = NO;
        // For strokes with multiple parts (green sections), make sure we go back to the very first one.
        if (continuingFromGreen){
            self.currentPNG = whereGreenLeftOff;
            
            NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[self.hiraganaCharacter.drawingPNGs objectAtIndex:self.currentPNG] ofType:nil];
            NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];
            UIImage *temp = [UIImage imageWithData:imageData];
            
            [self.characterDisplay setImage:temp];
            continuingFromGreen = NO;
            //free (newRawData);
            [self createTheContext];
        }
        drawImage.image = nil;
    }
}

-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 2){
        if (buttonIndex == 1){
            [self.showCharacterButton removeFromSuperview];
            // Save the drawing!!!
            [self endDrawingTutorial];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

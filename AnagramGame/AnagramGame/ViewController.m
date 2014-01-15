//
//  ViewController.m
//  AnagramGame
//
//  Created by thiago ferreira patricio on 2/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Tile.h"
#import "AnagramGame.h"
#import <AVFoundation/AVFoundation.h>
#import "PListManager.h"

@implementation ViewController
@synthesize dropTarget;
@synthesize backgroundIMG;
@synthesize tileHolderIMG;
@synthesize dragObject;
@synthesize touchOffset;
@synthesize homePosition;
@synthesize backButton;
@synthesize scoreLabel;
@synthesize guessedLabel;
@synthesize testShakeLabel;
@synthesize timerLabel;
@synthesize testLabel;
@synthesize tile1, tile2, tile3, tile4, tile5, tile6;

//NSMutableArray *wordTiles; // holds the tiles object
NSArray *tileHomePosX; // home screen position for the tiles, only need the x value, the y are the same
AnagramGame *game;
PListManager *pm;
int secondsLeft; // for the timer


// After the user adds a tile to the dropTarget space
// the addTileOffset will be added to the y position of the next tile to be dropped at the dropTarget space,
// so that the tiles don't appear on top of each other and appear at the right of the previous tile added
int addTileOffset;


/*  
 * The Drag&Drop implementation was based on the tutorial found in www.edumobile.edu 
 * Reference here: http://www.edumobile.org/iphone/iphone-programming-tutorials/simple-drag-and-drop-on-iphone/
 *
 * This method makes sure that there is only one finger touching the screen,
 * It also looks at all UIImageViews (except the the background image UIImageView), 
 * and for each UIImageView, sees if a touch occured inside that view's frame.
 *
 * If the view is an UIImageView and if the touch occurred inside its frame (tile frame)
 * we then designate the view to the dragObject, get the offset of the touch 
 * from the upper left corner of the view as a CGPoint, and remember the view's
 * home position.
 */
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // one finger touching the screen
    if ([touches count] == 1)
    {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        for (UIImageView *iView in self.view.subviews)
        {
            if ([iView isMemberOfClass:[UIImageView class]])
            {
                // we don't want the background image to move
                if (iView != backgroundIMG && iView != tileHolderIMG)
                {
					
                    if(touchPoint.x > iView.frame.origin.x && 
					   touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
					   touchPoint.y > iView.frame.origin.y &&
					   touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
					{
						
						self.dragObject = iView;
						self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x, touchPoint.y - iView.frame.origin.y);
						self.homePosition = CGPointMake(iView.frame.origin.x,
                                                        iView.frame.origin.y);
						[self.view bringSubviewToFront:self.dragObject];
                        
					}   
                }
            }
        }
    }
}

/*
 * Get the position of the touch, 
 * then set the dragObject's frame to the new touch position minus the touchOffset coordinate (the width and height of the tiles don't change).
 */
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
    // If a tile is already in the dropTarget area, we don't want to move it.
    // It will only go back to its original position if the 'clear' button is pressed
    for (Tile *t in game.wordTiles) {
        
        if (self.dragObject == t.imageView && t.inPosition == NO)
        {
            CGRect newDragObjectFrame = CGRectMake(touchPoint.x-touchOffset.x, touchPoint.y-touchOffset.y, self.dragObject.frame.size.width, self.dragObject.frame.size.height);
            self.dragObject.frame = newDragObjectFrame;
        }
    }
}

/*
 * Observe whether the last touch point is inside the frame of the dropTarget. 
 * If it is, we make the new position of the dragObject (tile) the position inside the dropTarget area.
 * After the tile is inside we append the tile.letter to the testLabel
 * 
 *  *!* If you're using the simulator make sure that the mouse pointer is inside the dropTarget area *!*
 */
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (touchPoint.x > self.dropTarget.frame.origin.x &&
        touchPoint.x < self.dropTarget.frame.origin.x + self.dropTarget.frame.size.width &&
        touchPoint.y > self.dropTarget.frame.origin.y &&
        touchPoint.y < self.dropTarget.frame.origin.y + self.dropTarget.frame.size.height)
    {
		
        // Checks which tile is being moved to the dropTarget area and if it's not already there (tile.inPosition == NO)
        // If everything is alright, the tile position will be inside the dropTarget area, a tile offset is added, so that
        // the next tile appears in the right of the previous one, and the tile letter will be appended in the displayWord
        // Else, if the tile is already in the dropTarget area it will remain there.
        for (Tile *t in game.wordTiles) {
			
            if (self.dragObject == t.imageView && t.inPosition == NO)
            {
				self.dragObject.frame = CGRectMake(self.dropTarget.frame.origin.x + addTileOffset, self.dropTarget.frame.origin.y + 4, self.dragObject.frame.size.width, self.dragObject.frame.size.height);            
				addTileOffset += 48; 
				t.inPosition = YES;
				[displayWord appendFormat:[NSString stringWithFormat:@"%c", t.letter]];
				testLabel.text = [displayWord description];
                [self playAudio:2];
            } 
        }
    } else
    {
        for (Tile *t in game.wordTiles) {
			
            if (self.dragObject == t.imageView && t.inPosition == NO)
            {
                self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y, self.dragObject.frame.size.width, self.dragObject.frame.size.height);
            }
        }
    }
}

// --- End of the Drag&Drop manipulation

-(BOOL) canBecomeFirstResponder {
    return YES;
}


// Shake gesture recognizer
-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self playAudio:3];
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:6];
        
        for (id posX in tileHomePosX)
        {
            NSUInteger randomPos = arc4random()%( [tmp count]+1 );
            [tmp insertObject:posX atIndex:randomPos];
        }
        
        tileHomePosX = [NSArray arrayWithArray:tmp];
        [self resetPositions];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    timerLabel.hidden = NO;
    secondsLeft = 60;
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountdown) userInfo:nil repeats:YES];
    
    
    NSMutableArray *imageViewTiles;
    imageViewTiles = [NSMutableArray arrayWithObjects:tile1,tile2,tile3,tile4,tile5,tile6, nil];
    game = [[AnagramGame alloc] initWithTiles:imageViewTiles];

    testLabel.text = game.currentWord;
    scoreLabel.text = [NSString stringWithFormat:@"%d", game.score];
    displayWord = [[NSMutableString alloc] initWithCapacity:6];
    
	tileHomePosX = [NSArray arrayWithObjects:
	[NSNumber numberWithFloat:20],
	[NSNumber numberWithFloat:67],
	[NSNumber numberWithFloat:115],
	[NSNumber numberWithFloat:163],
	[NSNumber numberWithFloat:211],
	[NSNumber numberWithFloat:259], nil];    
	
    addTileOffset = 19;
	
}

- (void)viewDidUnload
{
    [self setDropTarget:nil];
    [self setBackgroundIMG:nil];
    [self setTile1:nil];
    [self setTile2:nil];
    [self setTile3:nil];
    [self setTile4:nil];
    [self setTile5:nil];
    [self setTile6:nil];
    
    [self setTestLabel:nil];
    [self setBackButton:nil];
    [self setScoreLabel:nil];
    [self setGuessedLabel:nil];
    [self setTestShakeLabel:nil];
    [self setTileHolderIMG:nil];
    [self setTimerLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // TODO: load previous game state
    [super viewWillAppear:animated];
	
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    // TODO: save the state of the game
    
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (IBAction)goBack:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// All the tiles go back to their home position so that the user can
// try to guess a word again
- (IBAction)clearButton:(id)sender {
    [self playAudio:1];
    testLabel.text = [NSString stringWithFormat:@"-"];
    displayWord = [NSMutableString stringWithCapacity:6];
    [self resetPositions];
}

-(void) resetPositions
{
    int i;
    Tile *t;
    for (i = 0; i < 6; i++) 
    {
        t = [game.wordTiles objectAtIndex:i];
        t.imageView.frame = CGRectMake( [[tileHomePosX objectAtIndex:i] floatValue] , 398, t.imageView.frame.size.width, t.imageView.frame.size.height);
        t.inPosition = NO;
    }
    
    addTileOffset = 19;
}

// Check if the user's guess is right, the checking is done by AnagramGame.h
// if the user already guess the same correct word twice, a AlertView is shown
- (IBAction)guessButton:(id)sender {
    
    
    if( [game guessWord:testLabel.text] && !game.finishedLevel )
    {
        NSMutableString *temp = [NSMutableString stringWithCapacity:1000];
        for ( NSString *str in game.correctAnswers )
        {
            [temp appendFormat:[NSString stringWithFormat:@"%@, ", str]];
        }
        
        guessedLabel.text = [temp description];
        scoreLabel.text = [NSString stringWithFormat:@"%d", game.score];
        testLabel.text = @"";
        displayWord = [NSMutableString stringWithCapacity:6];
        [self resetPositions];
        
        if ([game isLevelOver])
        {
            [self resetPositions];
            [game updateGame];
            if (game.finishedGame)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Your score was: %d", game.score] message:@"Enter a nickname" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil, nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;                
                [alert show];
                

            } else {
                testLabel.text = game.currentWord;
                guessedLabel.text = @"try to guess a word";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:@"You've reached a new level" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];   
            }

        }
        
    } else if ( [game isRepeatedGuess:testLabel.text] )
    {
        testShakeLabel.text = @"Already guessed";
         
    } else {
        testShakeLabel.text = @"Try Again";
    }
    
}

-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonPressedName = [alertView buttonTitleAtIndex:buttonIndex];
    if (buttonPressedName == @"Continue") {
        UITextField *nickname = [alertView textFieldAtIndex:buttonIndex];
        [pm createNewRecordWithName:nickname.text andScore:[NSNumber numberWithInt:game.score]];
    }
}

// TODO: move this to a SoundManager.m
- (void) playAudio:(int)whichSound
{
    AVAudioPlayer *audioPlayer;
    
    if (whichSound == 1)
    {
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"sound_clear" ofType:@"wav" ];
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        [audioPlayer play];
    } else if (whichSound == 2)
    {
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"sound_movetile" ofType:@"wav" ];
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        [audioPlayer play];
    } else if (whichSound == 3)
    {
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"sound_shuffle" ofType:@"wav" ];
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        [audioPlayer play];
    }
}

- (void) timerCountdown{
    secondsLeft--;
    timerLabel.text = [NSString stringWithFormat:@"00:%02d", secondsLeft];
    if (secondsLeft == 0)
    {
        [countdownTimer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Time's Up! Your score was: %d", game.score] message:@"Enter a nickname" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;                
        [alert show];
    }
}

@end

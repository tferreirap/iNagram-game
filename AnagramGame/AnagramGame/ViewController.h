//
//  ViewController.h
//  AnagramGame
//
//  Created by thiago ferreira patricio on 2/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSMutableString *displayWord;
    NSTimer *countdownTimer;
}


@property (weak, nonatomic) IBOutlet UIView *dropTarget; // UIView where the tiles are going to be dropped
@property (weak, nonatomic) IBOutlet UIImageView *backgroundIMG;
@property (weak, nonatomic) IBOutlet UIImageView *tileHolderIMG;
@property (strong, nonatomic) UIImageView *dragObject; // A tile that it will be dragged
@property (assign, nonatomic) CGPoint touchOffset;
@property (assign, nonatomic) CGPoint homePosition;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *guessedLabel;
@property (weak, nonatomic) IBOutlet UILabel *testShakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tile1;
@property (weak, nonatomic) IBOutlet UIImageView *tile2;
@property (weak, nonatomic) IBOutlet UIImageView *tile3;
@property (weak, nonatomic) IBOutlet UIImageView *tile4;
@property (weak, nonatomic) IBOutlet UIImageView *tile5;
@property (weak, nonatomic) IBOutlet UIImageView *tile6;

- (IBAction)goBack:(id)sender;
- (IBAction)clearButton:(id)sender;
- (IBAction)guessButton:(id)sender;
- (void)playAudio:(int)whichSound;
- (void)resetPositions;

@end

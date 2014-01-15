//
//  MainMenuViewController.h
//  AnagramGame
//
//  Created by thiago ferreira patricio on 2/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *topScoreButton;

- (IBAction)goToNewGame:(id)sender;

@end

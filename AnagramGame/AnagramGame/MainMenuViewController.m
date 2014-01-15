//
//  MainMenuViewController.m
//  AnagramGame
//
//  Created by thiago ferreira patricio on 2/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "TopScoreTableViewController.h"
#import "ViewController.h"

@implementation MainMenuViewController
@synthesize continueButton;
@synthesize gameButton;
@synthesize topScoreButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
   
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setTopScoreButton:nil];
    [self setContinueButton:nil];
    [self setGameButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goToNewGame:(id)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    ViewController *newGameVC = [storyboard instantiateViewControllerWithIdentifier:@"newGameVC"];
    [self presentViewController:newGameVC animated:YES completion:nil];
}

@end

//
//  AnagramGame.m
//  AnagramGame
//
//  Created by thiago ferreira patricio on 3/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AnagramGame.h"
#import "Tile.h"

//static AnagramGame *sharedInstance;

@implementation AnagramGame

@synthesize score, currentWord, dictAnagrams, correctAnswers, finishedLevel, finishedGame, level,
imageViewTiles, wordTiles;


- (id) initWithTiles:(NSMutableArray *)newImageViewTiles
{
    if (self = [super init])
    {
        score = 0;
        level = 0;
        finishedGame = NO;
        finishedLevel = NO;
        correctAnswers = [[NSMutableArray alloc] init];
        wordTiles = [[NSMutableArray alloc] init];
        imageViewTiles = newImageViewTiles;
        [self initializeDictAnagrams];
        currentWord = [[dictAnagrams allKeys] objectAtIndex:level];
        [self initializeTiles];
    }
    return self;
}

// Populate the dictionary with the anagrams found in Data.plist
- (void) initializeDictAnagrams
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    if( ![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    dictAnagrams = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!dictAnagrams)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
}

-(void) initializeTiles
{
    Tile *t1,*t2,*t3,*t4,*t5,*t6;
    
    t1 = [[Tile alloc] initWithLetter:[self.currentWord characterAtIndex:0] andImageView:[imageViewTiles objectAtIndex:0] andInPosition:NO];
    t2 = [[Tile alloc] initWithLetter:[self.currentWord characterAtIndex:1] andImageView:[imageViewTiles objectAtIndex:1] andInPosition:NO];
    t3 = [[Tile alloc] initWithLetter:[self.currentWord characterAtIndex:2] andImageView:[imageViewTiles objectAtIndex:2] andInPosition:NO];
    t4 = [[Tile alloc] initWithLetter:[self.currentWord characterAtIndex:3] andImageView:[imageViewTiles objectAtIndex:3] andInPosition:NO];
    t5 = [[Tile alloc] initWithLetter:[self.currentWord characterAtIndex:4] andImageView:[imageViewTiles objectAtIndex:4] andInPosition:NO];
    t6 = [[Tile alloc] initWithLetter:[self.currentWord characterAtIndex:5] andImageView:[imageViewTiles objectAtIndex:5] andInPosition:NO];
    
    [self.wordTiles addObject:t1];
    [self.wordTiles addObject:t2];
    [self.wordTiles addObject:t3];
    [self.wordTiles addObject:t4];
    [self.wordTiles addObject:t5];
    [self.wordTiles addObject:t6];
    
    
}

- (void) updateGame
{
    finishedLevel = YES;
    [correctAnswers removeAllObjects];
    level++;
    
    if (level >= [[dictAnagrams allKeys] count])
    {
        finishedGame = YES;
    } else {
        currentWord = [[dictAnagrams allKeys] objectAtIndex:level];
        
        int i;
        Tile *t;
        for (i=0; i < [self.wordTiles count]; i++) {
            t = [self.wordTiles objectAtIndex:i];
            t.letter = [self.currentWord characterAtIndex:i];
            t.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", t.letter]];
            // imageView.image = [UIImage imageNamed:filename];
        }
        
        finishedLevel = NO;
    }
}

// Check if the word that the user guessed can be found in the array of correct
// answers, if so, the user gains 10 points.
- (BOOL) guessWord:(NSString *)word
{
    if ( [self isLevelOver] == NO )
    {
        for (NSString *w in [dictAnagrams objectForKey:currentWord]) {
            if ( ([correctAnswers containsObject:w] == NO) && [word isEqualToString:w])
            {
                [correctAnswers addObject:word];
                score += 10;
                return YES;
            }
        }
    }
    return NO;
}


- (BOOL) isLevelOver
{
    return [correctAnswers count] == [[dictAnagrams objectForKey:currentWord] count];
}

- (BOOL) isRepeatedGuess:(NSString *)word
{
    return [correctAnswers containsObject:word];
}

// checks how many anagrams a word has
- (int) anagramsPerWord
{
    return [[dictAnagrams objectForKey:currentWord] count];
}

//- (id) init
//{
//    NSLog(@"Singleton class. No init.");
//    return nil;
//}

@end

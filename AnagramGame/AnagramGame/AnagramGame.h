//
//  AnagramGame.h
//  AnagramGame
//
//  Created by thiago ferreira patricio on 3/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AnagramGame : NSObject

@property(assign) int score;
@property(strong) NSString *currentWord;
@property(strong) NSDictionary *dictAnagrams;
@property(strong) NSMutableArray *correctAnswers; // Words answered correctly by the user
@property(strong) NSMutableArray *imageViewTiles;
@property(strong) NSMutableArray *wordTiles;
@property(assign) BOOL finishedLevel;
@property(assign) BOOL finishedGame;
@property(assign) int level;


- (id) initWithTiles:(NSMutableArray *) newImageViewTiles;
- (void) initializeDictAnagrams;
- (void) initializeTiles;
- (void) updateGame;
- (BOOL) guessWord: (NSString *) word;
- (BOOL) isLevelOver;
- (BOOL) isRepeatedGuess: (NSString *) word;
- (int)  anagramsPerWord;

@end

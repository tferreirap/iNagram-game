//
//  PListManager.h
//  AnagramGame
//
//  Created by thiago ferreira patricio on 3/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Based on the template and tutorial found here:
// http://mobile.tutsplus.com/tutorials/iphone/iphone-sdk_store-data/
@interface PListManager : NSObject

@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, assign) NSInteger currentPlayer;

+ (PListManager *) sharedPListManager;
- (void)createNewRecordWithName:(NSString *)playerName andScore:(NSNumber *)playerScore;
- (void)updateRecordWithName:(NSString *)playerName andScore:(NSNumber *)playerScore;
- (void)deleteRecordWithIndex:(NSInteger)index;
- (void)writeProductsToFile;
- (int)numberPlayers;

@end

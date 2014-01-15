//
//  PListManager.m
//  AnagramGame
//
//  Created by thiago ferreira patricio on 3/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PListManager.h"

@implementation PListManager

static PListManager *sharedInstance;

@synthesize players, currentPlayer;

- (id) initInternal
{
    if (self = [super init])
    {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"PLIST_topScore.plist"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
            self.players = [NSMutableArray arrayWithContentsOfFile: plistPath];
        } else {
            self.players = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

+ (PListManager *) sharedPListManager
{
    if (!sharedInstance)
    {
        sharedInstance = [[PListManager alloc] initInternal];
    }
    return sharedInstance;
}

- (void)createNewRecordWithName:(NSString *)playerName andScore:(NSNumber *)playerScore {
	
	NSDictionary *player = [[NSDictionary alloc] initWithObjectsAndKeys: playerName, @"name", playerScore, @"score", nil];
	[players addObject: player];
	[self writeProductsToFile];
	
	NSLog(@"[SUCCESS] PLIST: Inserted new player to document!");
	
}

- (void)updateRecordWithName:(NSString *)playerName andScore:(NSNumber *)playerScore {
	
	NSMutableDictionary *player = [[NSMutableDictionary alloc] initWithDictionary: [players objectAtIndex: currentPlayer]];
	
	[player setObject:playerName forKey:@"name"];
	[player setObject:playerScore forKey:@"score"];
	[players replaceObjectAtIndex:currentPlayer withObject:player];

	[self writeProductsToFile];	
	
	NSLog(@"[SUCCESS] PLIST: Updated product in the document!");
	
}

- (void)deleteRecordWithIndex:(NSInteger)index {
	
	[players removeObjectAtIndex: index];
	[self writeProductsToFile];
	
	NSLog(@"[SUCCESS] PLIST: Record deleted from the document!");
	
}

- (void)writeProductsToFile {
	
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"PLIST_topScore.plist"];
	
	[players writeToFile:plistPath atomically:YES];
	
	NSLog(@"[INFO] PLIST: Document was written to disk!");
	
}

- (int) numberPlayers
{
    return [players count];
}

- (id) init
{
    NSLog(@"Singleton class! Not allowed.");
    return nil;
}

@end
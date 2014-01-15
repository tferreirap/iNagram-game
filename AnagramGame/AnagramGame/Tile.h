//
//  Tile.h
//  AnagramGame
//
//  Created by thiago ferreira patricio on 2/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tile : NSObject

@property(assign) char letter;
@property(strong) UIImageView *imageView;
@property(assign) BOOL inPosition;

-(id) initWithLetter: (char) newLetter
        andImageView: (UIImageView *) newImageView
       andInPosition: (BOOL) newInPosition;



@end

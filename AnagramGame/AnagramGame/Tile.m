//
//  Tile.m
//  AnagramGame
//
//  Created by thiago ferreira patricio on 2/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"

@implementation Tile

@synthesize letter, imageView, inPosition;

-(id) initWithLetter:(char)newLetter 
        andImageView:(UIImageView *)newImageView
        andInPosition:(BOOL)newInPosition
{
    if (self = [super init])
    {
        letter = newLetter;
        imageView = newImageView;
        inPosition = newInPosition;
        
        NSString *filename = [NSString stringWithFormat:@"%c.png", letter];
        
        imageView.image = [UIImage imageNamed:filename];
                           
    }
    return self;
}

@end

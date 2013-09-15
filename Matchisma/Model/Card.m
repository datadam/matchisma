//
//  Card.m
//  Matchisma
//
//  Created by Derek Taylor on 8/27/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

@synthesize faceUp = _faceUp;
@synthesize unplayable = _unplayable;

- (int)match:(NSArray *)cards {
    int score = 0;
    
    for (Card *card in cards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end

//
//  PlayingCard.m
//  Matchisma
//
//  Created by Derek Taylor on 8/27/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (int)match:(NSArray *)cards {
    int score = 0;
    
    //Compare ourself against the other cards.
    for (PlayingCard *otherCard in cards) {
        // We only play with one deck, so we don't worry about finding
        // the same card.
        if ([otherCard.suit isEqualToString:self.suit]) {
            ++score;
        } else if (otherCard.rank == self.rank) {
            score += 4;
        }
    }
    
    // There can still be a match between the cards in the array.  Simple recursion helps here.
    // There can only be at most two cards in the othercards array, or this won't work.  We would
    // need to create a new array with all the rest of the objects in cards.
    if (cards.count > 1) {
        score += [[cards objectAtIndex:0] match:@[[cards objectAtIndex:1]]];
    }
    
    return score;
}

+ (NSArray *)validSuits {
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    return validSuits;
}

+ (NSArray *)rankStrings {
    static NSArray *_rankStrings = nil;
    if (!_rankStrings) {
        _rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    }
    return _rankStrings;
}
+ (NSUInteger)maxRank {
    return [self rankStrings].count-1;
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}
- (NSString *)suit {
    return _suit ? _suit : @"?";
}

-(void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end

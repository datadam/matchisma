//
//  CardMatchingGame.m
//  Matchisma
//
//  Created by Derek Taylor on 8/31/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@end


@implementation CardMatchingGame

#define MATCH_BONUS (4)
#define MISMATCH_PENALTY (2)
#define FLIP_COST (1)

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        NSArray *otherCards = self.findOtherFaceUpCards;
        self.currentScore = 0;
        if (!card.faceUp) {
            // We turned a card up, check if it matches.
            int matchScore = 0;
            
            // Try to find a match only if we have the right number of cards.
            if (otherCards.count == 1)
            {
                matchScore = [card match:otherCards];               
            }
            

            if (matchScore > 0) {
                // If there's any match, take the cards out of play and
                // alter the score.
                for (Card *otherCard in otherCards) {
                    otherCard.unplayable = YES;
                }
                card.unplayable = YES;
                
                self.currentScore = matchScore * MATCH_BONUS;
                self.score += self.currentScore;
                self.gameState = kMatch;

                self.activeCards = nil;
                [self.activeCards addObjectsFromArray:otherCards];
                [self.activeCards addObject:card];

            } else {
                if (otherCards.count < 1)
                {
                    self.gameState = kInProgress;
                    
                } else {
                    
                    // not a match. flip over other cards. Apply penalty.
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.currentScore = -MISMATCH_PENALTY;
                    self.score -= MISMATCH_PENALTY;
                    self.gameState = kNotMatch;
                    
                    self.activeCards = nil;
                    [self.activeCards addObjectsFromArray:otherCards];
                    [self.activeCards addObject:card];
                }
            }
        } else {
            self.score -= FLIP_COST;
            self.gameState = kInProgress;
        }
        card.faceUp = !card.faceUp;

        if (self.gameState == kInProgress) {
            self.activeCards = nil;
            [self.activeCards addObjectsFromArray:[self findOtherFaceUpCards]];
        }
    }
}
@end

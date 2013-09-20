//
//  SetCardGame.m
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "SetCardGame.h"

@interface SetCardGame()


@end


@implementation SetCardGame

#define MISMATCH_PENALTY (1)
#define MATCH_BONUS (3)

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        if (!card.faceUp) {
            // We turned up a new card.  See if any others are selected
            NSArray *otherCards = self.findOtherFaceUpCards;
            
            // Try to find a match only if the user has selected two other cards.
            if (otherCards.count == 2) {
                int matchScore = [card match:otherCards];
                
                if (matchScore > 0) {
                    // There's a match, so take the cards out of play and update score.
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    card.faceUp = YES;
                    card.unplayable = YES;
                    self.score += (matchScore * MATCH_BONUS);
                    self.gameState = kMatch;
                    
                    self.activeCards = nil;
                    [self.activeCards addObjectsFromArray:otherCards];
                    [self.activeCards addObject:card];
                    
                } else {
                    // not a match.  apply penalty
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    card.faceUp = NO;
                    self.score -= MISMATCH_PENALTY;
                    self.gameState = kNotMatch;

                    self.activeCards = nil;
                    [self.activeCards addObjectsFromArray:otherCards];
                    [self.activeCards addObject:card];
                    
                }
            } else if (otherCards.count == 1) {
                // Still picking cards
                card.faceUp = YES;
                self.gameState = kInProgress;

                self.activeCards = nil;
                [self.activeCards addObjectsFromArray:otherCards];
                [self.activeCards addObject:card];

            } else {
                // Still picking cards
                card.faceUp = YES;
                self.gameState = kInProgress;
                
                self.activeCards = nil;
                [self.activeCards addObject:card];

            }
        } else {
            // Card already faceUp.  Flip it back.
            card.faceUp = NO;
            self.gameState = kInProgress;
            
            // See if any others are still selected and update description.
            NSArray *otherCards = self.findOtherFaceUpCards;
            self.activeCards = nil;
            [self.activeCards addObjectsFromArray:otherCards];

        }
    }
}
@end

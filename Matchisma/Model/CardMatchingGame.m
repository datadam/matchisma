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

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super initWithCardCount:cardCount usingDeck:deck];
    
    if (self) {
        self.mode = TWO_CARD_MODE;
    }
    return self;
}


#define MATCH_BONUS (4)
#define MISMATCH_PENALTY (2)
#define FLIP_COST (1)

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        if (!card.faceUp) {
            // We turned a card up, check if it matches.
            NSArray *otherCards = self.findOtherFaceUpCards;
            int matchScore = 0;
            
            // Try to find a match only if we have the right number of cards.
            if (((otherCards.count == 1) && (self.mode == TWO_CARD_MODE)) ||
                ((otherCards.count == 2) && (self.mode == THREE_CARD_MODE)))
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
                int thisScore = matchScore * MATCH_BONUS;
                self.score += thisScore;
                
                if (self.mode == TWO_CARD_MODE) {
                    NSString *description = [NSString stringWithFormat:@"Matched %@ and %@: %d points",
                                            card.contents,
                                            [[otherCards objectAtIndex:0] contents],
                                            thisScore];
                    self.flipDescription = [[NSAttributedString alloc] initWithString:description];
                } else {
                    NSString *description = [NSString stringWithFormat:@"Matched %@, %@, %@: %d points",
                                            card.contents,
                                            [[otherCards objectAtIndex:0] contents],
                                            [[otherCards objectAtIndex:1] contents],
                                            thisScore];
                    self.flipDescription = [[NSAttributedString alloc] initWithString:description];
                }
            } else {
                if (((self.mode == TWO_CARD_MODE) && (otherCards.count < 1)) ||
                    ((self.mode == THREE_CARD_MODE) && (otherCards.count < 2)))
                {
                    NSString *description = [NSString stringWithFormat:@"Flipped up %@", card.contents];
                    self.flipDescription = [[NSAttributedString alloc] initWithString:description];
                } else {
                    
                    // not a match. flip over other cards. Apply penalty.
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    if (self.mode == TWO_CARD_MODE) {
                        NSString *description = [NSString stringWithFormat:@"Mismatch %@ and %@: -%d points",
                                                card.contents,
                                                [[otherCards objectAtIndex:0] contents],
                                                MISMATCH_PENALTY];
                        self.flipDescription = [[NSAttributedString alloc] initWithString:description];
                    } else {
                        // THREE_CARD_MODE
                        NSString *description = [NSString stringWithFormat:@"Mismatch %@, %@, %@: -%d points",
                                                card.contents,
                                                [[otherCards objectAtIndex:0] contents],
                                                [[otherCards objectAtIndex:1] contents],
                                                MISMATCH_PENALTY];
                        self.flipDescription = [[NSAttributedString alloc] initWithString:description];
                    }
                }
            }
                    } else {
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.faceUp;
    }
}
@end

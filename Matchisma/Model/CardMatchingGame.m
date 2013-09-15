//
//  CardMatchingGame.m
//  Matchisma
//
//  Created by Derek Taylor on 8/31/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; // of Card *
@property (nonatomic, readwrite) int score;

- (BOOL) setCardsFromDeck:(NSUInteger)cardCount usingDeck:(Deck *)deck;
- (NSMutableArray *)findOtherFaceUpCards;

@end

@implementation CardMatchingGame

//#define TEST_CODE (1)

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}
- (NSString *)flipDescription {
    if (!_flipDescription) _flipDescription = [[NSString alloc] init];
    return _flipDescription;
}

- (BOOL) setCardsFromDeck:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    for (int i=0; i < cardCount; ++i) {
#if TEST_CODE
        Card *card = [deck drawCardAtIndex:(14)];
#else
        Card *card = [deck drawRandomCard];
#endif
        if (!card) {
            return NO;
        } else {
            self.cards[i] = card;
        }
    }
    return YES;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        if (![self setCardsFromDeck:cardCount usingDeck:deck]) {
            return nil;
        }
        // Initialize the score and mode to two card mode.
        self.score = 0;
        self.mode = TWO_CARD_MODE;
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)reset:(NSUInteger)cardCount usingDeck:(Deck *)deck{
    // reinitialize the deck and make sure all cards are playable
    [self setCardsFromDeck:cardCount usingDeck:deck];
    for (Card *card in self.cards) {
        card.unplayable = NO;
        card.faceUp = NO;
    }
    // Also reset the score.
    // Flip count must be reset in the controller.
    self.score = 0;
}

- (NSMutableArray *)findOtherFaceUpCards {
    NSMutableArray *resultarray = [NSMutableArray arrayWithCapacity:2];
    for (Card *otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            [resultarray addObject:otherCard];
        }
    }
    return resultarray;
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
                    self.flipDescription = [NSString stringWithFormat:@"Matched %@ and %@: %d points",
                                            card.contents,
                                            [[otherCards objectAtIndex:0] contents],
                                            thisScore];
                } else {
                    self.flipDescription = [NSString stringWithFormat:@"Matched %@, %@, %@: %d points",
                                            card.contents,
                                            [[otherCards objectAtIndex:0] contents],
                                            [[otherCards objectAtIndex:1] contents],
                                            thisScore];
                }
            } else {
                if (((self.mode == TWO_CARD_MODE) && (otherCards.count < 1)) ||
                    ((self.mode == THREE_CARD_MODE) && (otherCards.count < 2)))
                {
                    self.flipDescription = [NSString stringWithFormat:@"Flipped up %@", card.contents];
                } else {
                    
                    // not a match. flip over other cards. Apply penalty.
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    if (self.mode == TWO_CARD_MODE) {
                        self.flipDescription = [NSString stringWithFormat:@"Mismatch %@ and %@: -%d points",
                                                card.contents,
                                                [[otherCards objectAtIndex:0] contents],
                                                MISMATCH_PENALTY];
                    } else {
                        // THREE_CARD_MODE
                        self.flipDescription = [NSString stringWithFormat:@"Mismatch %@, %@, %@: -%d points",
                                                card.contents,
                                                [[otherCards objectAtIndex:0] contents],
                                                [[otherCards objectAtIndex:1] contents],
                                                MISMATCH_PENALTY];
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

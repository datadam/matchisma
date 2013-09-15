//
//  SetCardGame.m
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "SetCardGame.h"

@interface SetCardGame()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) int score;

- (BOOL) setCardsFromDeck:(NSUInteger)cardCount usingDeck:(Deck *)deck;
- (NSMutableArray *)findOtherFaceUpCards;

@end

@implementation SetCardGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}
- (NSAttributedString *)flipDescription {
    if (!_flipDescription) _flipDescription = [[NSAttributedString alloc] initWithString:@""];
    return _flipDescription;
}
- (BOOL) setCardsFromDeck:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    for (int i=0; i < cardCount; ++i) {
        Card *card = [deck drawRandomCard];
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
        //Initialize the score to 0.
        self.score = 0;
    }
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)reset:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    [self setCardsFromDeck:cardCount usingDeck:deck];
    for (Card *card in self.cards) {
        card.unplayable = NO;
        card.faceUp = NO;
    }
    // Reset the score
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

#define MISMATCH_PENALTY (1)
#define MATCH_BONUS (3)

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        if (!card.faceUp) {
            // We turned up a card.  See if any others are selected
            NSArray *otherCards = self.findOtherFaceUpCards;
            
            // Try to find a match only if the user has selected two other cards.
            if (otherCards.count == 2) {
                int matchScore = [card match:otherCards];
                
                if (matchScore > 0) {
                    // There's a match, so take the cards out of play and update score.
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    card.unplayable = YES;
                    self.score += (matchScore * MATCH_BONUS);
                    
                    NSString *labelText = [NSString stringWithFormat:@"%@, %@, %@  form a set!", [[otherCards objectAtIndex:1] contents], [[otherCards objectAtIndex:0] contents], card.contents];
                    NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithString:labelText];
                    //Set attributes for each card...
                    NSRange range1;
                    NSDictionary *attributes1 = [[[otherCards objectAtIndex:1] attributedContents] attributesAtIndex:0 effectiveRange:&range1];
                    [labelAttributedText setAttributes:attributes1 range:range1];

                    NSRange range0;
                    NSDictionary *attributes0 = [[[otherCards objectAtIndex:0] attributedContents] attributesAtIndex:0 effectiveRange:&range0];
                    range0.location = range1.length + [@", " length];  // adjust the starting point for [0]
                    [labelAttributedText setAttributes:attributes0 range:range0];

                    NSRange range2;
                    NSDictionary *attributes2 = [[card attributedContents] attributesAtIndex:0 effectiveRange:&range2];
                    range2.location = range0.length + range1.length + 2*[@", " length];
                    [labelAttributedText setAttributes:attributes2 range:range2];

                    self.flipDescription = labelAttributedText;
                    //self.flipDescription = [NSString stringWithFormat:@"%@, %@, %@  form a set!", [[otherCards objectAtIndex:0] contents], [[otherCards objectAtIndex:1] contents], card.contents];
                } else {
                    // not a match.  apply penalty
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    
                    NSString *labelText = [NSString stringWithFormat:@"%@, %@, %@ do not form a set", [[otherCards objectAtIndex:1] contents], [[otherCards objectAtIndex:0] contents], card.contents];
                    NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithString:labelText];
                    
                    // Set attributes for each card...
                    NSRange range1;
                    NSDictionary *attributes1 = [[[otherCards objectAtIndex:1] attributedContents] attributesAtIndex:0 effectiveRange:&range1];
                    [labelAttributedText setAttributes:attributes1 range:range1];

                    NSRange range0;
                    NSDictionary *attributes0 = [[[otherCards objectAtIndex:0] attributedContents] attributesAtIndex:0 effectiveRange:&range0];
                    range0.location = range1.length + [@", " length];  // adjust the starting point for [1]
                    [labelAttributedText setAttributes:attributes0 range:range0];
                    
                    
                    NSRange range2;
                    NSDictionary *attributes2 = [[card attributedContents] attributesAtIndex:0 effectiveRange:&range2];
                    range2.location = range0.length + range1.length + 2*[@", " length];
                    [labelAttributedText setAttributes:attributes2 range:range2];
                    
                    self.flipDescription = labelAttributedText;
                    //self.flipDescription = [NSString stringWithFormat:@"%@, %@, %@ do not form a set", [[otherCards objectAtIndex:0] contents], [[otherCards objectAtIndex:1] contents], card.contents];
                }
            } else if (otherCards.count == 1) {
                // Still picking cards
                card.faceUp = YES;
                NSString *labelText = [NSString stringWithFormat:@"Selected %@, %@",
                                       [[otherCards objectAtIndex:0] contents], card.contents];
                NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithString:labelText];
                
                // Set attributes from card.
                NSRange range0;
                NSDictionary *attributes0 = [[[otherCards objectAtIndex:0] attributedContents] attributesAtIndex:0 effectiveRange:&range0];
                range0.location = [@"Selected " length];
                [labelAttributedText setAttributes:attributes0 range:range0];
                
                NSRange cardRange;
                NSRange searchExtents;
                searchExtents.location = 0;
                searchExtents.length = [card.contents length];
                
                NSDictionary *cardAttributes = [[card attributedContents] attributesAtIndex:0 longestEffectiveRange:&cardRange inRange:searchExtents];
                cardRange.location = [@"Selected " length] + range0.length + [@", " length];
                [labelAttributedText setAttributes:cardAttributes range:cardRange];
                self.flipDescription = labelAttributedText;

            } else {
                // Still picking cards
                card.faceUp = YES;
                NSString *labelText = [NSString stringWithFormat:@"Selected %@", card.contents];
                NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithString:labelText];
                // Set attributes from card.
                NSRange cardRange;
                NSRange searchExtents;
                searchExtents.location = 0;
                searchExtents.length = [card.contents length];
                
                NSDictionary *cardAttributes = [[card attributedContents] attributesAtIndex:0 longestEffectiveRange:&cardRange inRange:searchExtents];
                cardRange.location = [@"Selected " length];
                [labelAttributedText setAttributes:cardAttributes range:cardRange];
                self.flipDescription = labelAttributedText;
            }
        } else {
            // Card already faceUp.  Flip it back.
            card.faceUp = NO;
        }
    }
}
@end

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

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
                    card.unplayable = YES;
                    self.score += (matchScore * MATCH_BONUS);
                    
                    NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:[[otherCards objectAtIndex:1] attributedContents]];
                    [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                    [labelAttributedText appendAttributedString:[[otherCards objectAtIndex:0] attributedContents]];
                    [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                    [labelAttributedText appendAttributedString:[card attributedContents]];
                    [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" form a set!"]];
                    
                    self.flipDescription = labelAttributedText;
                } else {
                    // not a match.  apply penalty
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    
                    NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:[[otherCards objectAtIndex:1] attributedContents]];
                    [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                    [labelAttributedText appendAttributedString:[[otherCards objectAtIndex:0] attributedContents]];
                    [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                    [labelAttributedText appendAttributedString:[card attributedContents]];
                    [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" do not form a set!"]];

                    self.flipDescription = labelAttributedText;
                }
            } else if (otherCards.count == 1) {
                // Still picking cards
                card.faceUp = YES;

                NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:[[otherCards objectAtIndex:0] attributedContents]];
                [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                [labelAttributedText appendAttributedString:[card attributedContents]];
                [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" selected"]];

                self.flipDescription = labelAttributedText;

            } else {
                // Still picking cards
                card.faceUp = YES;
                
                NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:[card attributedContents]];
                [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" selected"]];
                self.flipDescription = labelAttributedText;
            }
        } else {
            // Card already faceUp.  Flip it back.
            card.faceUp = NO;
            
            // See if any others are still selected and update description.
            NSArray *otherCards = self.findOtherFaceUpCards;
            if (otherCards.count > 0) {
                NSMutableAttributedString *labelAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:[[otherCards objectAtIndex:0] attributedContents]];
                [labelAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" selected"]];
                self.flipDescription = labelAttributedText;
            } else {
                self.flipDescription = [[NSAttributedString alloc] initWithString:@"Nothing selected"];
            }
        }
    }
}
@end

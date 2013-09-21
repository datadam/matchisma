//
//  SetGameViewController.m
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardGame.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount
{
    return [[SetCardGame alloc] initWithCardCount:cardCount usingDeck:[[SetCardDeck alloc] init]];
}

- (void) oneTimeFormatButton:(UIButton *)button forCard:(Card *)card {
    [button setAttributedTitle:card.attributedContents forState:UIControlStateNormal];
    [button setAttributedTitle:card.attributedContents forState:UIControlStateSelected];
    [button setAttributedTitle:card.attributedContents forState:UIControlStateSelected|UIControlStateHighlighted];
}
- (void) formatButton:(UIButton *)button forCard:(Card *)card
{
    button.selected = card.isFaceUp;
    button.enabled = !card.isUnplayable;
    
    if (card.isFaceUp) {
        button.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    } else {
        button.backgroundColor = [UIColor whiteColor];
    }
    button.alpha = card.isUnplayable ? 0.0 : 1.0;
}

- (NSString *) flipSuffix {
    switch ([self.game gameState]) {
        case kMatch:
            return [[NSString alloc] initWithFormat:@" form a set! %d points", self.game.currentScore];
            break;
        case kNotMatch:
            return [[NSString alloc] initWithFormat:@" do not form a set. %d points", self.game.currentScore];
            break;
        case kInProgress:
            return @" selected";
            break;
        default:  // case kInit:
            return @"";
    }
}
@end

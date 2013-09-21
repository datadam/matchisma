//
//  MatchingCardGameViewController.m
//  Matchisma
//
//  Created by Derek Taylor on 9/17/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "MatchingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface MatchingCardGameViewController ()

@end

@implementation MatchingCardGameViewController

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount
{
    return [[CardMatchingGame alloc] initWithCardCount:cardCount usingDeck:[[PlayingCardDeck alloc] init]];
}
- (void) oneTimeFormatButton:(UIButton *)button forCard:(Card *)card {
    [button setTitle:card.contents forState:UIControlStateSelected];
    [button setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    [button setTitle:card.contents forState:UIControlStateSelected|UIControlStateHighlighted];
    
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    //UIImage *clear = [UIImage imageNamed:@"singlepix.png"];
    UIImage *clear = [[UIImage alloc] init];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [button setImage:clear forState:UIControlStateSelected];
    [button setImage:clear forState:UIControlStateSelected|UIControlStateDisabled];
    [button setImage:clear forState:UIControlStateSelected|UIControlStateHighlighted];
    [button setImage:cardBackImage forState:UIControlStateNormal];
}
- (void) formatButton:(UIButton *)button forCard:(Card *)card {
    button.selected = card.isFaceUp;
    button.enabled = !card.isUnplayable;
    button.alpha = card.isUnplayable ? 0.25 : 1.0;
}

- (NSString *) flipSuffix {
    switch ([self.game gameState]) {
        case kMatch:
            return [[NSString alloc] initWithFormat:@" match! %d points", self.game.currentScore];
            break;
        case kNotMatch:
            return [[NSString alloc] initWithFormat:@" do not match. %d points", self.game.currentScore];
            break;
        case kInProgress:
            return @" selected";
            break;
        default:  // case kInit:
            return @"";
    }
}


- (void) notifyCardWasFlipped {
}
- (void) notifyNewDeal {
}

@end

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

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControlEnable;

@end

@implementation MatchingCardGameViewController

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount
{
    return [[CardMatchingGame alloc] initWithCardCount:cardCount usingDeck:[[PlayingCardDeck alloc] init]];
}

- (void) formatButton:(UIButton *)button forCard:(Card *)card {
    [button setTitle:card.contents forState:UIControlStateSelected];
    [button setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    [button setTitle:card.contents forState:UIControlStateSelected|UIControlStateHighlighted];
        
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    UIImage *clear = [UIImage imageNamed:@"singlepix.png"];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [button setImage:clear forState:UIControlStateSelected];
    [button setImage:clear forState:UIControlStateSelected|UIControlStateDisabled];
    [button setImage:clear forState:UIControlStateSelected|UIControlStateHighlighted];
    [button setImage:cardBackImage forState:UIControlStateNormal];
        
    button.selected = card.isFaceUp;
    button.enabled = !card.isUnplayable;
    button.alpha = card.isUnplayable ? 0.25 : 1.0;
}

- (void) notifyCardWasFlipped {
    [self.modeControlEnable setEnabled:NO forSegmentAtIndex:0];
    [self.modeControlEnable setEnabled:NO forSegmentAtIndex:1];
}
- (void) notifyNewDeal {
    [self.modeControlEnable setEnabled:YES forSegmentAtIndex:0];
    [self.modeControlEnable setEnabled:YES forSegmentAtIndex:1];
    [self.modeControlEnable setSelectedSegmentIndex:[self.game mode]];
}

- (IBAction)modeControl:(UISegmentedControl *)sender {
    [self.game setMode:([sender selectedSegmentIndex])];
}

@end

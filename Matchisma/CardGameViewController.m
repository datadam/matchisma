//
//  CardGameViewController.m
//  Matchisma
//
//  Created by Derek Taylor on 8/26/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControlEnable;

@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;

- (void) updateUI;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count                                                       usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}
- (void) setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}
- (void) updateUI {
    for (UIButton *button in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:button]];
        //NSLog(@"Selected card %@.  Is %s, %s", card.contents, card.isFaceUp ? "faceup" : "not faceup", card.isUnplayable ? "unplayable" : "playable");
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
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipDescription.attributedText = self.game.flipDescription;
}
- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    //NSLog(@"Flips updated to %d", self.flipCount);
}
- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    if (!sender.isSelected) {
        self.flipCount++;
    }
    [self.modeControlEnable setEnabled:NO forSegmentAtIndex:0];
    [self.modeControlEnable setEnabled:NO forSegmentAtIndex:1];
    [self updateUI];
}

- (IBAction)dealButton:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    [self.modeControlEnable setEnabled:YES forSegmentAtIndex:0];
    [self.modeControlEnable setEnabled:YES forSegmentAtIndex:1];
    [self.modeControlEnable setSelectedSegmentIndex:[self.game mode]];
    [self updateUI];
}

- (IBAction)modeControl:(UISegmentedControl *)sender {
    [self.game setMode:([sender selectedSegmentIndex])];
}

@end

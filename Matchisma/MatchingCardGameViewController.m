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
@property (nonatomic) NSInteger resetWithMode;

@end

@implementation MatchingCardGameViewController

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount
{
    return [[CardMatchingGame alloc] initWithCardCount:cardCount usingDeck:[[PlayingCardDeck alloc] init] usingMode:self.resetWithMode];
}

- (void) formatButton:(UIButton *)button forCard:(Card *)card {
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
    // We only need to disable the other option.  Then they can't change modes.
    // Leaving the active mode enabled makes it stay highlighted.
    if (self.game.mode == 0) {
        [self.modeControlEnable setEnabled:NO forSegmentAtIndex:1];
    } else {
        [self.modeControlEnable setEnabled:NO forSegmentAtIndex:0];
    }
}
- (void) notifyNewDeal {
    // Enable all options on a new deal.
    [self.modeControlEnable setEnabled:YES forSegmentAtIndex:0];
    [self.modeControlEnable setEnabled:YES forSegmentAtIndex:1];
    [self.modeControlEnable setSelectedSegmentIndex:[self.game mode]];
    // Store in the controller the mode of the game before we deal a new deck.
    // That way, we can restore the game to the same mode.
    self.resetWithMode = [self.game mode];
}

- (IBAction)modeControl:(UISegmentedControl *)sender {
    [self.game setMode:([sender selectedSegmentIndex])];
}

@end

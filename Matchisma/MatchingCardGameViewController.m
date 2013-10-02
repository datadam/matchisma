//
//  MatchingCardGameViewController.m
//  Matchisma
//
//  Created by Derek Taylor on 9/17/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "MatchingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"
#import "CardMatchingGame.h"

@interface MatchingCardGameViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *matchCardCollectionView;

@end

@implementation MatchingCardGameViewController

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount
{
    return [[CardMatchingGame alloc] initWithCardCount:cardCount usingDeck:[[PlayingCardDeck alloc] init]];
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

- (NSUInteger) startingCardCount
{
    return 20;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        PlayingCard *playingCard = (PlayingCard *)card;
        playingCardView.rank = playingCard.rank;
        playingCardView.suit = playingCard.suit;
        playingCardView.faceUp = playingCard.faceUp;
        playingCardView.alpha = playingCard.isUnplayable ? 0.25 : 1.0;
    }
}

- (void) updateUI {
    for (UICollectionViewCell *cell in [self.matchCardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.matchCardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    [super updateUI];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}


- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.matchCardCollectionView];
    NSIndexPath *indexPath = [self.matchCardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        [super updateUI];
    }
}


@end

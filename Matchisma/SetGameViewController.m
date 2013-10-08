//
//  SetGameViewController.m
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardGame.h"

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *setCardCollectionView;

@end

@implementation SetGameViewController

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount
{
    return [[SetCardGame alloc] initWithCardCount:cardCount usingDeck:[[SetCardDeck alloc] init]];
}

- (NSUInteger) startingCardCount
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SetCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        SetCard *setCard = (SetCard *)card;
        setCardView.shading = setCard.shading;
        setCardView.color   = setCard.color;
        setCardView.symbol  = setCard.symbol;
        setCardView.number  = setCard.number;
        setCardView.faceUp = setCard.isFaceUp;
        setCardView.alpha = setCard.isUnplayable ? 0.35 : 1.0;
    }
}

- (void) updateUI {
    for (UICollectionViewCell *cell in [self.setCardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.setCardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    [super updateUI];
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

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.setCardCollectionView];
    NSIndexPath *indexPath = [self.setCardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        [self updateUI];
    }
}
@end

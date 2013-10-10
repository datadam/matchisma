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
@property (weak, nonatomic) IBOutlet SetCardView *firstCardView;
@property (weak, nonatomic) IBOutlet SetCardView *secondCardView;
@property (weak, nonatomic) IBOutlet SetCardView *thirdCardView;

@end

@implementation SetGameViewController

- (void)viewDidLoad
{
    [self setActiveCards];
    [super viewDidLoad];
}

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount
{
    return [[SetCardGame alloc] initWithCardCount:cardCount usingDeck:[[SetCardDeck alloc] init]];
}

- (NSUInteger) startingCardCount
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SetCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}
- (void)setCardView:(SetCardView *)view fromCard:(SetCard *)card
{
    view.shading = card.shading;
    view.color   = card.color;
    view.symbol  = card.symbol;
    view.number  = card.number;
    view.faceUp = card.isFaceUp;
    view.alpha = card.isUnplayable ? 0.35 : 1.0;
}
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        SetCard *setCard = (SetCard *)card;
        [self setCardView:setCardView fromCard:setCard];
    }
}

- (void) setActiveCards
{
    NSArray *cards = self.game.activeCards;
    if (cards.count > 0) {
        [self setCardView:self.firstCardView fromCard:cards[0]];
        self.firstCardView.faceUp = NO; // Don't want background greyed out.
        self.firstCardView.alpha = 1.0; // Don't want set dimmed on match.
        if (cards.count > 1) {
            [self setCardView:self.secondCardView fromCard:cards[1]];
            self.secondCardView.faceUp = NO;
            self.secondCardView.alpha = 1.0;
            if (cards.count > 2) {
                [self setCardView:self.thirdCardView fromCard:cards[2]];
                self.thirdCardView.faceUp = NO;
                self.thirdCardView.alpha = 1.0;
            } else {
                self.thirdCardView.alpha = 0.0;
            }
        } else {
            self.secondCardView.alpha = 0.0;
            self.thirdCardView.alpha = 0.0;
        }
    } else {
        // No active cards, so hide them all.
        self.firstCardView.alpha = 0.0;
        self.secondCardView.alpha = 0.0;
        self.thirdCardView.alpha = 0.0;
    }
}

- (void) doReload {
    //Nothing to do in base class;
    [self.setCardCollectionView reloadData];
}

- (void) updateUI {
    for (UICollectionViewCell *cell in [self.setCardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.setCardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    [self setActiveCards];
    [super updateUI];
}

- (NSMutableAttributedString *)activeDescribe
{
    NSMutableAttributedString *atext = [[NSMutableAttributedString alloc] initWithString:@""];
    return atext;
}

- (NSString *) flipSuffix {
    switch ([self.game gameState]) {
        case kMatch:
            return [[NSString alloc] initWithFormat:@"Set! %d points", self.game.currentScore];
            break;
        case kNotMatch:
            return [[NSString alloc] initWithFormat:@"Not a set. %d points", self.game.currentScore];
            break;
        case kInProgress:
            return @"";
            break;
        default:  // case kInit:
            return @"";
    }
}

- (void)removeCellsFromCollection:(NSArray *)indexesRemoved
{
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    for (NSNumber *indexRemoved in indexesRemoved) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:indexRemoved.integerValue inSection:0];
        [deleteArray addObject:indexPath];
    }
    [self.setCardCollectionView deleteItemsAtIndexPaths:deleteArray];
}
- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.setCardCollectionView];
    NSIndexPath *indexPath = [self.setCardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        NSArray *indexesRemoved = [self.game removeUnplayableCards];
        if (indexesRemoved.count > 0) {
            [self removeCellsFromCollection:indexesRemoved];
        }
        [self updateUI];
    }
}
@end

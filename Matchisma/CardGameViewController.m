//
//  CardGameViewController.m
//  Matchisma
//
//  Created by Derek Taylor on 8/26/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "CardGame.h"

@interface CardGameViewController ()


@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (nonatomic) BOOL endOfDeck;

- (void) updateUI;
- (void) setFlipDescription;

@end

@implementation CardGameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numItems = [self.game.cards count];
    //NSLog(@"Number of items in section: %d", numItems);
    return numItems;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Base Class tries to get a generic card.
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    //NSLog(@"Base class.  Should not be called.");
    return cell;
}
- (void)setup {
    // initialization that can't wait for viewDidLoad
}
- (void)awakeFromNib {
    [self setup];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.endOfDeck = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount {
    return nil; // base class implementation not meant to be used.
}

- (CardGame *)game {
    if (!_game) _game = [self createGameWithCardCount:self.startingCardCount];
    return _game;
}

- (NSMutableAttributedString *)activeDescribe
{
    NSArray *cards = self.game.activeCards;
    NSMutableAttributedString *atext = [[NSMutableAttributedString alloc] initWithString:@""];
    int cardindex = 0;
    for (Card *card in cards) {
        [atext appendAttributedString:[card attributedContents]];
        if (cardindex < cards.count - 1) {
            // Not yet last card, so add a ', '
            [atext appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
        }
        ++cardindex;
    }
    return atext;
}
- (void) setFlipDescription {
    NSMutableAttributedString *atext = [self activeDescribe];
    NSArray *cards = self.game.activeCards;
    if (cards.count > 0) {
        [atext appendAttributedString:[[NSAttributedString alloc] initWithString:[self flipSuffix]]];
    }
    if (self.endOfDeck) {
        [atext appendAttributedString:[[NSAttributedString alloc] initWithString:@" No more cards."]];
    }
    self.flipDescription.attributedText = atext;
}
- (NSString *) flipSuffix {
    // base class returns an empty string.  No other context available for suffix.
    return @"";
}
- (void) updateUI {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self setFlipDescription];
}

- (void)removeCellsFromCollection:(NSArray *)indexesRemoved
{
    //Nothing to do in base class.
}
- (void)removeCellsFromCollectionInRange:(int)start ToEnd:(int)end
{
    NSMutableArray *indexesToRemove = [[NSMutableArray alloc] init];
    for (int i=start; i<end; ++i) {
        [indexesToRemove addObject:[[NSNumber alloc] initWithInt:i]];
    }
    [self removeCellsFromCollection:indexesToRemove];
}

- (IBAction)dealButton:(UIButton *)sender {
    int previousCardCount = [self.game.cards count];
    self.game = nil;
    [self updateUI];
    
    int finalCardCount = [self.game.cards count];
    if (previousCardCount > finalCardCount) {
        //Remove extraneous cells on a Deal Reset.
        [self removeCellsFromCollectionInRange:finalCardCount ToEnd:previousCardCount];
    }
}
- (void) doReload {
    //Nothing to do in base class;
}
- (IBAction)addCardsButton:(UIButton *)sender {
    // Add cards to the game.
    if (![self.game addCardsFromDeck:3]) {
        self.endOfDeck = YES;
    }
    [self doReload];
    [self updateUI];
}

@end

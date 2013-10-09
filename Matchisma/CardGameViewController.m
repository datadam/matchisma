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
    return self.startingCardCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Base Class tries to get a generic card.
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    NSLog(@"Base class.  Should not be called.");
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
- (void)resetButtonFormat {
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetButtonFormat];
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

- (void) notifyNewDeal {
    //Nothing to do in base class.
}
- (IBAction)dealButton:(UIButton *)sender {
    // Must notify subclass of deal before we reconstruct the game state,
    // in case we need to save anything.  For example, game mode.
    [self notifyNewDeal];
    self.game = nil;
    [self resetButtonFormat];
    [self updateUI];
}

@end

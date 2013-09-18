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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipDescription;

@property (nonatomic) int flipCount;

- (void) updateUI;

@end

@implementation CardGameViewController

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
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount {
    return nil; // base class implementation not meant to be used.
    //return [[CardGame alloc] initWithCardCount:cardCount usingDeck:[[Deck alloc] init]];
}

- (CardGame *)game {
    if (!_game) _game = [self createGameWithCardCount:self.cardButtons.count];
    return _game;
}
- (void) setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}
- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void) formatButton:(UIButton *)button forCard:(Card *)card {
    NSLog(@"base class implementation should not be called.");
    [button setTitle:card.contents forState:UIControlStateSelected];
    [button setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    [button setTitle:card.contents forState:UIControlStateSelected|UIControlStateHighlighted];
    
    button.selected = card.isFaceUp;
    button.enabled = !card.isUnplayable;
    button.alpha = card.isUnplayable ? 0.25 : 1.0;
}
- (void) updateUI {
    for (UIButton *button in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:button]];
        [self formatButton:button forCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipDescription.attributedText = self.game.flipDescription;
}

- (void) notifyCardWasFlipped {
    //Nothing to do in base class.
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    if (!sender.isSelected) {
        self.flipCount++;
    }
    [self notifyCardWasFlipped];
    [self updateUI];
}

- (void) notifyNewDeal {
    //Nothing to do in base class.
}
- (IBAction)dealButton:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    [self notifyNewDeal];
    [self updateUI];
}

@end

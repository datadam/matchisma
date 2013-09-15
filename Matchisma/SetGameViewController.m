//
//  SetGameViewController.m
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardGame.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playDescription;

@property (nonatomic) int flipCount;
@property (strong, nonatomic) SetCardGame *game;

- (void) updateUI;

@end

@implementation SetGameViewController

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

- (SetCardGame *)game {
    if (!_game) {
        _game = [[SetCardGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[SetCardDeck alloc] init]];
    }
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
- (void) updateUI {
    for (UIButton *button in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:button]];

        [button setAttributedTitle:card.attributedContents forState:UIControlStateNormal];
        [button setAttributedTitle:card.attributedContents forState:UIControlStateSelected];
        [button setAttributedTitle:card.attributedContents forState:UIControlStateSelected|UIControlStateHighlighted];

        button.selected = card.isFaceUp;
        button.enabled = !card.isUnplayable;
        
        if (card.isFaceUp) {
            button.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
        } else {
            button.backgroundColor = [UIColor whiteColor];
        }
        button.alpha = card.isUnplayable ? 0.0 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.playDescription.attributedText = self.game.flipDescription;
}

- (IBAction)dealButton:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    Card *cardFlipped = [self.game cardAtIndex:[self.cardButtons indexOfObject:sender]];
    if (!cardFlipped.isFaceUp) {
        self.flipCount++;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
}

@end

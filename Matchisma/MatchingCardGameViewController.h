//
//  MatchingCardGameViewController.h
//  Matchisma
//
//  Created by Derek Taylor on 9/17/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface MatchingCardGameViewController : CardGameViewController

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount;
- (void) formatButton:(UIButton *)button forCard:(Card *)card;

@end

//
//  CardGameViewController.h
//  Matchisma
//
//  Created by Derek Taylor on 8/26/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardGame *game;

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount;
- (void) formatButton:(UIButton *)button forCard:(Card *)card;
- (void) oneTimeFormatButton:(UIButton *)button forCard:(Card *)card;

- (void) notifyCardWasFlipped;
- (void) notifyNewDeal;
- (NSString *) flipSuffix;

@end

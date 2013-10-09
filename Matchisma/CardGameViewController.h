//
//  CardGameViewController.h
//  Matchisma
//
//  Created by Derek Taylor on 8/26/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGame.h"

@interface CardGameViewController : UIViewController <UICollectionViewDataSource>

@property (nonatomic) NSUInteger startingCardCount;
@property (strong, nonatomic) CardGame *game;

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount;

- (void) updateUI;
- (void) doReload;
- (void) notifyNewDeal;
- (NSString *) flipSuffix;
- (NSMutableAttributedString *)activeDescribe;

@end

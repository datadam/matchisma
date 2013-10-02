//
//  SetGameViewController.h
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGameViewController.h"
#import "CardGame.h"

@interface SetGameViewController : CardGameViewController

- (CardGame *) createGameWithCardCount:(NSUInteger)cardCount;

@end

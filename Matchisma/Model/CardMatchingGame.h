//
//  CardMatchingGame.h
//  Matchisma
//
//  Created by Derek Taylor on 8/31/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardGame.h"

@interface CardMatchingGame : CardGame

#define TWO_CARD_MODE (0)
#define THREE_CARD_MODE (1)
@property (nonatomic) NSInteger mode;

@end

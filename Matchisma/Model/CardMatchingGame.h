//
//  CardMatchingGame.h
//  Matchisma
//
//  Created by Derek Taylor on 8/31/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger) cardCount
              usingDeck:(Deck *)deck;

- (Card *)cardAtIndex:(NSUInteger)index;

- (void)reset:(NSUInteger)cardCount
    usingDeck:(Deck *)deck;

@property (nonatomic, readonly) int score;
@property (nonatomic) NSString *flipDescription;

// Class specific implementation
- (void)flipCardAtIndex:(NSUInteger)index;

#define TWO_CARD_MODE (0)
#define THREE_CARD_MODE (1)
@property (nonatomic) NSInteger mode;

@end

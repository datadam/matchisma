//
//  CardGame.m
//  Matchisma
//
//  Created by Derek Taylor on 9/16/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "CardGame.h"

@interface CardGame()

@end

@implementation CardGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}
- (NSMutableArray *)activeCards {
    if (!_activeCards) _activeCards = [[NSMutableArray alloc] init];
    return _activeCards;
}
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        if (![self setCardsFromDeck:cardCount usingDeck:deck]) {
            return nil;
        }
        _score = 0;
        _gameState = kInit;
        _deck = deck;
    }
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (BOOL) setCardsFromDeck:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    for (int i=0; i < cardCount; ++i) {
        Card *card = [deck drawRandomCard];
        if (!card) {
            return NO;
        } else {
            self.cards[i] = card;
        }
    }
    return YES;
}

- (BOOL) addCardsFromDeck:(NSUInteger)cardCount {
    for (int i=0; i < cardCount; ++i) {
        Card *card = [self.deck drawRandomCard];
        if (!card) {
            return NO;
        } else {
            [self.cards addObject:card];
        }
    }
    return YES;
}

- (NSArray *) removeUnplayableCards
{
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    NSMutableArray *indexesRemoved = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (Card* card in self.cards) {
        if (card.isUnplayable) {
            [toRemove addObject:card];
            [indexesRemoved addObject:[[NSNumber alloc] initWithInt:index]];
        }
        ++index;
    }
    for (Card* card in toRemove) {
        [self.cards removeObject:card];
    }
    return indexesRemoved;
}

- (NSMutableArray *)findOtherFaceUpCards {
    NSMutableArray *resultarray = [NSMutableArray arrayWithCapacity:2];
    for (Card *otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            [resultarray addObject:otherCard];
        }
    }
    return resultarray;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    NSLog(@"Base class CardGame should not be called.  Override in derived class.");
}

@end

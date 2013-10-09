//
//  CardGame.h
//  Matchisma
//
//  Created by Derek Taylor on 9/16/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardGame : NSObject

// designated initializer
- (id) initWithCardCount:(NSUInteger) cardCount
               usingDeck:(Deck *)deck;
-(Card *)cardAtIndex:(NSUInteger)index;

// These should really be protected, but I don't know how to do that.
- (BOOL) setCardsFromDeck:(NSUInteger)cardCount usingDeck:(Deck *)deck;
- (BOOL) addCardsFromDeck:(NSUInteger)cardCount;
- (NSMutableArray *)findOtherFaceUpCards;

@property (nonatomic) int score;
@property (nonatomic) int currentScore;
@property (nonatomic) NSInteger mode;

typedef NS_ENUM(NSUInteger, MatchResult) {
    kInit,
    kNotMatch,
    kMatch,
    kInProgress
};
@property (nonatomic) MatchResult gameState;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (strong, nonatomic) NSMutableArray *activeCards; // of Card
@property (strong, nonatomic) Deck *deck;

// Class specific implementation
- (void)flipCardAtIndex:(NSUInteger)index;

@end

//
//  SetCardGame.h
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface SetCardGame : NSObject

// designated initializer
- (id) initWithCardCount:(NSUInteger) cardCount
               usingDeck:(Deck *)deck;
-(Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic) NSAttributedString *flipDescription;

// Class specific implementation
- (void)flipCardAtIndex:(NSUInteger)index;

@end

//
//  Deck.h
//  Matchisma
//
//  Created by Derek Taylor on 8/27/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;
- (Card *)drawCardAtIndex:(NSUInteger)index;

@end

//
//  SetCardDeck.m
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (NSString *)getStringFromSymbol:(SymbolType) symbol {
    if (symbol == kDiamond) {
        // TODO: Change the string descriptors...
        return @"▲";
    } else if (symbol == kSquiggle) {
        return @"■";
    } else { // (symbol == kOval)
        return @"●";
    }
}

- (NSString *)repeatStringFromString:(NSString*) string
                              Number:(NSNumber*) number
{
    NSString *newString = @"";
    /* Add 1 because index '0' has value 'kOne', or numeric '1' */
    for (int i = 0; i < ([number integerValue] + 1); ++i) {
        newString = [newString stringByAppendingString:string];
        //NSLog(@"Created string [%d]: %@", i, newString);
    }
    return newString;
}

- (id)init {
    self = [super init];
    if (self) {
        for (NSNumber *symbol in [SetCard validSymbols]) {
            NSString *thisSymbol = [self getStringFromSymbol:[symbol integerValue]];
            for (NSNumber *number in [SetCard validNumbers]) {
                NSString *cardText = [self repeatStringFromString:thisSymbol Number:number];
                for (NSNumber *shading in [SetCard validShading]) {
                    for (NSNumber *color in [SetCard validColors]) {
                        //TODO:  Change this to init with an attributed string.
                        // No, actually set this in the SetCard class contents method instead.
                        //NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] init];
                        SetCard *card = [[SetCard alloc]
                                         initWithNumber:[number integerValue]
                                         symbol:[symbol integerValue]
                                         shade:[shading integerValue]
                                         color:[color integerValue]
                                         text:cardText];
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end

//
//  SetCard.h
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

typedef NS_ENUM(NSUInteger, ShadeType) {
    kOpen,
    kStriped,
    kSolid
};

typedef NS_ENUM(NSUInteger, ColorType) {
    kRed,
    kGreen,
    kPurple
};

typedef NS_ENUM(NSUInteger, SymbolType) {
    kTriangle,
    kSquare,
    kCircle
};

typedef NS_ENUM(NSUInteger, NumberType) {
    kOne,
    kTwo,
    kThree
};

@property (strong, nonatomic) NSString *text;
@property (nonatomic) NumberType number;
@property (nonatomic) SymbolType symbol;
@property (nonatomic) ShadeType shading;
@property (nonatomic) ColorType color;

// designated initializer
- (id)initWithNumber:(NumberType) number
              symbol:(SymbolType) symbol
              shade:(ShadeType) shading
              color:(ColorType) color
              text:(NSString *) txt;

+ (NSArray *)validNumbers;
+ (NSArray *)validSymbols;
+ (NSArray *)validShading;
+ (NSArray *)validColors;

@end

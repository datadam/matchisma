//
//  SetCard.m
//  Matchisma
//
//  Created by Derek Taylor on 9/7/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (id)initWithNumber:(NumberType)number symbol:(SymbolType)symbol shade:(ShadeType)shading color:(ColorType)color text:(NSString *)txt
{
    self = [super init];
    
    if (self) {
        self.number = number;
        self.symbol = symbol;
        self.shading = shading;
        self.color = color;
        self.text = txt;
    }
    return self;
}

- (NSString *)contents {
    return self.text;
}

#define FONT_SIZE (20.0)
- (NSAttributedString *)attributedContents {
    UIColor *cardColor = nil;
    UIColor *stripedFillColor = nil;
    if (self.color == kRed) {
        //cardColor = (self.color == kRed) ? [UIColor redColor] : (self.color == kGreen) ? [UIColor greenColor] : [UIColor purpleColor];
        //stripedFillColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        cardColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        stripedFillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
    } else if (self.color == kGreen) {
        cardColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        stripedFillColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.2];
    } else { // self.color == kPurple
        cardColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.5 alpha:1.0];
        stripedFillColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.5 alpha:0.2];
    }
    UIColor *openFillColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    
    NSAttributedString *atext;
    if (self.shading == kOpen)
    {
        atext = [[NSAttributedString alloc] initWithString:self.text attributes:@{
                                      NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE],
                           NSForegroundColorAttributeName : openFillColor,
                               NSStrokeWidthAttributeName : @-5.0,
                                 NSStrokeColorAttributeName : cardColor}];
    } else if (self.shading == kStriped) {
        atext = [[NSAttributedString alloc] initWithString:self.text attributes:@{
                                      NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE],
                           NSForegroundColorAttributeName : stripedFillColor,
                               NSStrokeWidthAttributeName : @-5.0,
                                 NSStrokeColorAttributeName : cardColor}];
    } else { // self.shading == kSolid
        atext = [[NSAttributedString alloc] initWithString:self.text attributes:@{
                                      NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE],
                           NSForegroundColorAttributeName : cardColor,
                               NSStrokeWidthAttributeName : @-5.0,
                               NSStrokeColorAttributeName : cardColor}];
    }
    return atext;
}


- (int)match:(NSArray *)cards {
    int score = 0;
    // Compare ourself against the other two cards.
    if (cards.count != 2) {
        NSLog(@"Error:  wrong number of cards: %d", cards.count);
    } else {
        bool numberMatch = NO;
        bool symbolMatch = NO;
        bool shadingMatch = NO;
        bool colorMatch = NO;
        bool numberSet = NO;
        bool symbolSet = NO;
        bool shadingSet = NO;
        bool colorSet = NO;
        bool firstCardChecked = NO;
        for (SetCard *otherCard in cards) {
            if (!firstCardChecked) {
                if (self.number == otherCard.number) numberMatch = YES;
                if (self.symbol == otherCard.symbol) symbolMatch = YES;
                if (self.shading == otherCard.shading) shadingMatch = YES;
                if (self.color == otherCard.color) colorMatch = YES;
                firstCardChecked = YES;
            } else {
                if ((numberMatch && (self.number == otherCard.number)) ||
                    (!numberMatch && (self.number != otherCard.number)))
                {
                    numberSet = YES;
                }
                if ((symbolMatch && (self.symbol == otherCard.symbol)) ||
                    (!symbolMatch && (self.symbol != otherCard.symbol)))
                {
                    symbolSet = YES;
                }
                if ((shadingMatch && (self.shading == otherCard.shading)) ||
                    (!shadingMatch && (self.shading != otherCard.shading)))
                {
                    shadingSet = YES;
                }
                if ((colorMatch && (self.color == otherCard.color)) ||
                    (!colorMatch && (self.color != otherCard.color)))
                {
                    colorSet = YES;
                }
            }
        }
        if (numberSet && symbolSet && shadingSet && colorSet) {
            score = 1;
        }
    }
    return score;
}

+ (NSArray *)validNumbers {
    static NSArray *validNumbers = nil;
    if (!validNumbers) validNumbers = [NSArray arrayWithObjects:[NSNumber numberWithInt:kOne], [NSNumber numberWithInt:kTwo], [NSNumber numberWithInt:kThree], nil];
    return validNumbers;
}
+ (NSArray *)validSymbols {
    static NSArray *validSymbols = nil;
    if (!validSymbols) validSymbols = [NSArray arrayWithObjects:[NSNumber numberWithInt:kDiamond], [NSNumber numberWithInt:kSquiggle], [NSNumber numberWithInt:kOval], nil];
    return validSymbols;
}
+ (NSArray *)validShading {
    static NSArray *validShading = nil;
    if (!validShading) validShading = [NSArray arrayWithObjects:[NSNumber numberWithInt:kOpen], [NSNumber numberWithInt:kStriped], [NSNumber numberWithInt:kSolid], nil];
    return validShading;
}
+ (NSArray *)validColors {
    static NSArray *validColors = nil;
    if (!validColors) validColors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kOpen], [NSNumber numberWithInt:kStriped], [NSNumber numberWithInt:kSolid], nil];
    return validColors;
}
@end

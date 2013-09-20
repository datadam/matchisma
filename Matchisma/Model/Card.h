//
//  Card.h
//  Matchisma
//
//  Created by Derek Taylor on 8/27/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (strong, nonatomic) NSAttributedString *attributedContents;
@property (nonatomic, getter = isFaceUp, setter = faceUp:) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (NSAttributedString *)attributedContents;

- (int)match:(NSArray *)cards;
@end

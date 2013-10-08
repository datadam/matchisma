//
//  SetCardView.m
//  SuperCard
//
//  Created by Derek Taylor on 9/24/13.
//  Copyright (c) 2013 Derek Taylor. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic, strong) UIColor *drawColor;
@property (nonatomic) CGFloat alphaValue;

- (void)strokeAndFillWithBezierPath:(UIBezierPath *)path;
- (void)drawDiamondinRect:(CGRect)drawRect;
- (void)drawOvalinRect:(CGRect)drawRect;
- (void)drawSquiggleinRect:(CGRect)drawRect;
- (NSArray *)deriveDrawRectsFromNumber:(NumberType)number;
- (void) drawSymbol:(SymbolType)symbol
         withNumber:(NumberType)number;

@end

@implementation SetCardView

- (void) setup {
    //initialization here
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setSymbol:(SymbolType)symbol {
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NumberType)number {
    _number = number;
    [self setNeedsDisplay];
}

#define OPEN_ALPHA (0.0)
#define STRIPED_ALPHA (0.3)
#define SOLID_ALPHA (1.0)
- (void)setShading:(ShadeType)shading {
    _shading = shading;
    if (shading == kStriped) {
        self.alphaValue = STRIPED_ALPHA;
    } else if (shading == kSolid) {
        self.alphaValue = SOLID_ALPHA;
    } else {
        self.alphaValue = OPEN_ALPHA;
    }
    [self setNeedsDisplay];
}

- (void)setColor:(ColorType)color {
    _color = color;
    if (color == kGreen) {
        // self.drawColor = [UIColor greenColor];
        self.drawColor = [UIColor colorWithRed:0.25 green:0.85 blue:0.25 alpha:1.0];
    } else if (color == kRed) {
        // self.drawColor = [UIColor redColor];
        self.drawColor = [UIColor colorWithRed:1.0 green:0.25 blue:0.25 alpha:1.0];
    } else { // (color == kPurple)
        // self.drawColor = [UIColor purpleColor];
        self.drawColor = [UIColor colorWithRed:0.75 green:0.25 blue:1.0 alpha:1.0];
    }
    [self setNeedsDisplay];
}

- (void)strokeAndFillWithBezierPath:(UIBezierPath *)path {
    [self.drawColor setStroke];
    [[self.drawColor colorWithAlphaComponent:self.alphaValue] setFill];
    [path stroke];
    [path fill];
}

- (void)drawDiamondinRect:(CGRect)drawRect
{
    UIBezierPath * path= [[UIBezierPath alloc] init];
    CGPoint leftCenter, topCenter, rightCenter, bottomCenter;
    leftCenter.x = drawRect.origin.x;
    leftCenter.y = drawRect.origin.y + drawRect.size.height/2;
    
    topCenter.x = drawRect.origin.x + drawRect.size.width/2;
    topCenter.y = drawRect.origin.y;

    rightCenter.x = drawRect.origin.x + drawRect.size.width;
    rightCenter.y = drawRect.origin.y + drawRect.size.height/2;
    
    bottomCenter.x = drawRect.origin.x + drawRect.size.width/2;
    bottomCenter.y = drawRect.origin.y + drawRect.size.height;
    
    [path moveToPoint:leftCenter];
    [path addLineToPoint:topCenter];
    [path addLineToPoint:rightCenter];
    [path addLineToPoint:bottomCenter];
    [path closePath];
    [self strokeAndFillWithBezierPath:path];
}

- (void)drawOvalinRect:(CGRect)drawRect
{
    UIBezierPath * path= [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:drawRect.size.width > drawRect.size.height ? drawRect.size.height / 2.0 : drawRect.size.width / 2.0];
    [self strokeAndFillWithBezierPath:path];
}

- (void)drawSquiggleinRect:(CGRect)drawRect
{
    UIBezierPath * path= [[UIBezierPath alloc] init];
    CGPoint bottomLeft, topRight, control1, control2, control3, control4;
    bottomLeft.x = drawRect.origin.x;
    bottomLeft.y = drawRect.origin.y + drawRect.size.height;
    topRight.x = drawRect.origin.x + drawRect.size.width;
    topRight.y = drawRect.origin.y;
    control1.x = drawRect.origin.x + drawRect.size.width * 0.25;
    control1.y = drawRect.origin.y - drawRect.size.height * 0.5;
    control2.x = drawRect.origin.x + drawRect.size.width * 0.75;
    control2.y = drawRect.origin.y + drawRect.size.height * 0.5;
    control3.x = drawRect.origin.x + drawRect.size.width * 0.75;
    control3.y = drawRect.origin.y + drawRect.size.height * 1.5;
    control4.x = drawRect.origin.x + drawRect.size.width * 0.25;
    control4.y = drawRect.origin.y + drawRect.size.height * 0.5;

    [path moveToPoint:bottomLeft];
    [path addCurveToPoint:topRight controlPoint1:control1 controlPoint2:control2];
    [path addCurveToPoint:bottomLeft controlPoint1:control3 controlPoint2:control4];
    [self strokeAndFillWithBezierPath:path];
}

#define RECT_HEIGHT (0.2)
#define RECT_WIDTH (0.8)

- (NSArray *)deriveDrawRectsFromNumber:(NumberType)number
{
    NSMutableArray *rects = [[NSMutableArray alloc] init];
    if (rects) {
        CGRect templateRect;
        templateRect.origin.y = 0;
        templateRect.origin.x = self.bounds.size.width * (1.0 - RECT_WIDTH)/2;
        templateRect.size.height = self.bounds.size.height * RECT_HEIGHT;
        templateRect.size.width = self.bounds.size.width * RECT_WIDTH;
        if (number == kOne) {
            CGRect drawRect = templateRect;
            drawRect.origin.y = self.bounds.size.height * RECT_HEIGHT * 2.0;
            [rects addObject:[NSValue valueWithCGRect:drawRect]];

        } else if (number == kTwo) {
            CGRect drawRect = templateRect;
            drawRect.origin.y = self.bounds.size.height * RECT_HEIGHT;
            [rects addObject:[NSValue valueWithCGRect:drawRect]];
            
            CGRect drawRect2 = templateRect;
            drawRect2.origin.y = self.bounds.size.height * RECT_HEIGHT * 3.0;
            [rects addObject:[NSValue valueWithCGRect:drawRect2]];

        } else { // (number == kThree)
            CGRect drawRect = templateRect;
            drawRect.origin.y = self.bounds.size.height * RECT_HEIGHT * 0.5;
            [rects addObject:[NSValue valueWithCGRect:drawRect]];
            
            CGRect drawRect2 = templateRect;
            drawRect2.origin.y = self.bounds.size.height * RECT_HEIGHT * 2.0;
            [rects addObject:[NSValue valueWithCGRect:drawRect2]];
            
            CGRect drawRect3 = templateRect;
            drawRect3.origin.y = self.bounds.size.height * RECT_HEIGHT * 3.5;
            [rects addObject:[NSValue valueWithCGRect:drawRect3]];
        }
    }
    return rects;
}

- (void) drawSymbol:(SymbolType)symbol
         withNumber:(NumberType)number
{
    NSArray *drawRects = [self deriveDrawRectsFromNumber:number];
    for (NSValue *rect in drawRects) {
        switch (self.symbol) {
            case kDiamond:
                [self drawDiamondinRect:[rect CGRectValue]];
                break;
            case kSquiggle:
                [self drawSquiggleinRect:[rect CGRectValue]];
                break;
            case kOval:
                [self drawOvalinRect:[rect CGRectValue]];
                break;
        }
    }
}

#define CORNER_RADIUS 12.0

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    // [[UIColor whiteColor] setFill];
    if (self.faceUp) {
        [[UIColor lightGrayColor] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    
    UIRectFill(self.bounds);
    
    [self drawSymbol:self.symbol withNumber:self.number];
    
}


@end

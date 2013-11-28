//
//  SetCardView.m
//  Graphical -Set
//
//  Created by Juan Posadas on 10/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Properties

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma MARK - Drawing

#define DIAMOND 1
#define SQUIGGLE 2
#define OVAL 3

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];

    [roundedRect addClip];
    
    if (self.selected) {
        [[UIColor lightGrayColor] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [[UIColor whiteColor] setFill];
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    if (self.symbol == DIAMOND){
        [self drawDiamondsWithCenter:center];
    } else if (self.symbol == SQUIGGLE) {
        [self drawSquigglesWithCenter:center];
    } else if (self.symbol == OVAL) {
        [self drawOvalsWithCenter:center];
    }
    
    
}

#define SPACING_SCALE_FACTOR 0.1
#define DIAMOND_WIDTH_SCALE_FACTOR 0.30
#define DIAMON_HEIGHT_SCALE_FACTOR 0.1

- (void)drawDiamondsWithCenter: (CGPoint) center
{
    
    CGFloat widthFromCenter = self.bounds.size.width * DIAMOND_WIDTH_SCALE_FACTOR;
    CGFloat heightFromCenter = self.bounds.size.height * DIAMON_HEIGHT_SCALE_FACTOR;
    CGFloat diamondSpacing = self.bounds.size.height * SPACING_SCALE_FACTOR;
    
    NSMutableArray *diamondCenters = [[NSMutableArray alloc] init];
    
    if (self.number == 1) {
        [diamondCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y)]];
    } else if (self.number == 2) {
        [diamondCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y - (heightFromCenter + diamondSpacing))]];
        [diamondCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y + (heightFromCenter + diamondSpacing))]];
    } else if (self.number == 3) {
        [diamondCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y - (heightFromCenter + 2*diamondSpacing))]];
        [diamondCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y)]];
        [diamondCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y + (heightFromCenter + 2*diamondSpacing))]];
    }
    
    for (NSValue *center in diamondCenters) {
        [self drawDiamondFromCenter:[center CGPointValue] withHeight:heightFromCenter  andWidth:widthFromCenter];
    }
    
}

- (void) drawDiamondFromCenter: (CGPoint)center withHeight: (CGFloat)heightFromCenter andWidth: (CGFloat)widthFromCenter
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(center.x - widthFromCenter, center.y)];
    
    [path addLineToPoint:CGPointMake(center.x, center.y - heightFromCenter)];
    [path addLineToPoint:CGPointMake(center.x + widthFromCenter, center.y)];
    [path addLineToPoint:CGPointMake(center.x, center.y + heightFromCenter)];
    
    [path closePath];
    
    [[self returnColorWithIndex:self.color] setStroke];
    [path stroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawFillWithShadingIndex:self.shading
                        withCenter:center
                            onPath:path
                          andColor:[self returnColorWithIndex:self.color]
                       withContext:context withHeight:heightFromCenter andWidth:widthFromCenter];

}

#define SQUIGGLE_WIDTH_SCALE_FACTOR 0.30
#define SQUIGGLE_HEIGHT_SCALE_FACTOR 0.08

- (void)drawSquigglesWithCenter: (CGPoint) center
{
    
    CGFloat widthFromCenter = self.bounds.size.width * SQUIGGLE_WIDTH_SCALE_FACTOR;
    CGFloat heightFromCenter = self.bounds.size.height * SQUIGGLE_HEIGHT_SCALE_FACTOR;
    CGFloat squiggleSpacing = self.bounds.size.height * SPACING_SCALE_FACTOR;
    
    NSMutableArray *squiggleCenters = [[NSMutableArray alloc] init]; // Left vertex
    
    if (self.number == 1) {
        [squiggleCenters addObject:[NSValue valueWithCGPoint:center]];
    } else if (self.number == 2) {
        [squiggleCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y - (heightFromCenter + squiggleSpacing))]];
        [squiggleCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y + (heightFromCenter + squiggleSpacing))]];
    } else if (self.number == 3) {
        [squiggleCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y - (heightFromCenter + 2*squiggleSpacing))]];
        [squiggleCenters addObject:[NSValue valueWithCGPoint:center]];
        [squiggleCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y + (heightFromCenter + 2*squiggleSpacing))]];
    }
    
    for (NSValue *center in squiggleCenters) {
        [self drawSquiggleFromCenter:[center CGPointValue] withHeight:heightFromCenter andWidth:widthFromCenter];
    }

}

#define SIDE_CURVE_CONTROL_POINT_FACTOR 1.3
#define TOP_CURVE_CONTROL_POINT_FACTOR 0.1
#define BOTTOM_CURVE_CONTROL_POINT_FACTOR 1.8

- (void)drawSquiggleFromCenter:(CGPoint)center withHeight:(CGFloat)heightFromCenter andWidth:(CGFloat)widthFromCenter
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(center.x - widthFromCenter, center.y - heightFromCenter)];
    
    [path addQuadCurveToPoint:CGPointMake(center.x - widthFromCenter, center.y + heightFromCenter)
                 controlPoint:CGPointMake(center.x - SIDE_CURVE_CONTROL_POINT_FACTOR * widthFromCenter, center.y)];
   
    [path addCurveToPoint:CGPointMake(center.x + widthFromCenter, center.y + heightFromCenter)
            controlPoint1:CGPointMake(center.x - (TOP_CURVE_CONTROL_POINT_FACTOR * widthFromCenter), center.y)
            controlPoint2:CGPointMake(center.x + (TOP_CURVE_CONTROL_POINT_FACTOR * widthFromCenter), center.y + BOTTOM_CURVE_CONTROL_POINT_FACTOR * heightFromCenter)];
    
    [path addQuadCurveToPoint:CGPointMake(center.x + widthFromCenter, center.y - heightFromCenter)
                 controlPoint:CGPointMake(center.x + (1 + SIDE_CURVE_CONTROL_POINT_FACTOR * widthFromCenter), center.y)];
    
    [path addCurveToPoint:CGPointMake(center.x - widthFromCenter, center.y - heightFromCenter)
            controlPoint1:CGPointMake(center.x + TOP_CURVE_CONTROL_POINT_FACTOR * widthFromCenter, center.y)
            controlPoint2:CGPointMake(center.x - TOP_CURVE_CONTROL_POINT_FACTOR * widthFromCenter, center.y - BOTTOM_CURVE_CONTROL_POINT_FACTOR * heightFromCenter)];
    
    [[self returnColorWithIndex:self.color] setStroke];
    [path stroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawFillWithShadingIndex:self.shading
                        withCenter:center
                            onPath:path
                          andColor:[self returnColorWithIndex:self.color]
                       withContext:context withHeight:heightFromCenter andWidth:widthFromCenter];

}

#define OVAL_SCALE_WIDTH_FACTOR 0.30
#define OVAL_SCALE_HEIGHT_FACTOR 0.09
#define OVAL_CORNER_RADIUS 10
#define OVAL_SPACING_FACTOR

- (void)drawOvalsWithCenter: (CGPoint) center
{
    CGFloat widthFromCenter = self.bounds.size.width * OVAL_SCALE_WIDTH_FACTOR;
    CGFloat heightFromCenter = self.bounds.size.height * OVAL_SCALE_HEIGHT_FACTOR;
    CGFloat ovalSpacing = self.bounds.size.height * SPACING_SCALE_FACTOR;

    NSMutableArray *ovalCenters = [[NSMutableArray alloc] init];
    
    if (self.number == 1) {
        [ovalCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y)]];
    } else if (self.number == 2) {
        [ovalCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y - (heightFromCenter + ovalSpacing))]];
        [ovalCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y + (heightFromCenter + ovalSpacing))]];
    } else if (self.number == 3) {
        [ovalCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y - (heightFromCenter + 2*ovalSpacing))]];
        [ovalCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y)]];
        [ovalCenters addObject:[NSValue valueWithCGPoint:CGPointMake(center.x, center.y + (heightFromCenter + 2*ovalSpacing))]];
    }

    for (NSValue *center in ovalCenters) {
        [self drawOvalFromCenter:[center CGPointValue] withHeight:heightFromCenter andWidth:widthFromCenter];
    }
}

- (void)drawOvalFromCenter: (CGPoint) center withHeight: (CGFloat)heightFromCenter andWidth: (CGFloat)widthFromCenter
{
    CGRect rect = CGRectMake(center.x - widthFromCenter, center.y - heightFromCenter, 2 * widthFromCenter, 2 * heightFromCenter);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:OVAL_CORNER_RADIUS];
    
    [[self returnColorWithIndex:self.color] setStroke];
    [path stroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawFillWithShadingIndex:self.shading
                        withCenter:center
                            onPath:path
                          andColor:[self returnColorWithIndex:self.color]
                       withContext:context withHeight:heightFromCenter andWidth:widthFromCenter];
}

- (void)drawFillWithShadingIndex: (NSUInteger)shading withCenter: (CGPoint) center onPath: (UIBezierPath *)path andColor: (UIColor *)color withContext: (CGContextRef)ctxt withHeight: (CGFloat)heightFromCenter andWidth: (CGFloat)widthFromCenter
{
    if (shading == 2) {
        
        CGContextSaveGState(ctxt);
        
        [path addClip];
        [color setStroke];
        
        UIBezierPath *stripe1 = [[UIBezierPath alloc] init];
        [stripe1 moveToPoint:CGPointMake(center.x - 2 * widthFromCenter, center.y)];
        [stripe1 addLineToPoint:CGPointMake(center.x + 2 * widthFromCenter, center.y)];
        [stripe1 stroke];
        
        UIBezierPath *stripe2 = [[UIBezierPath alloc] init];
        [stripe2 moveToPoint:CGPointMake(center.x - 2 * widthFromCenter, center.y - heightFromCenter / 2)];
        [stripe2 addLineToPoint:CGPointMake(center.x + 2 * widthFromCenter, center.y - heightFromCenter / 2)];
        [stripe2 stroke];
        
        UIBezierPath *stripe3 = [[UIBezierPath alloc] init];
        [stripe3 moveToPoint:CGPointMake(center.x - 2 * widthFromCenter, center.y + heightFromCenter / 2)];
        [stripe3 addLineToPoint:CGPointMake(center.x + 2 * widthFromCenter, center.y + heightFromCenter / 2)];
        [stripe3 stroke];
        
        CGContextRestoreGState(ctxt);
        
    } else if (shading == 3) {
        
        [color setFill];
        [path fill];
        
    }
    
    
}

- (UIColor *)returnColorWithIndex: (NSUInteger) index
{
    return [self listOfColors][index - 1];
}

- (NSArray *)listOfColors
{
    return @[[UIColor redColor],[UIColor greenColor], [UIColor purpleColor]];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end

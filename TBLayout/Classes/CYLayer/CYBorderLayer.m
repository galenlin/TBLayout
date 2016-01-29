//
//  CYBorderLayer.m
//  MainWebsite
//
//  Created by galen on 13-7-27.
//  Copyright (c) 2013年 273.cn. All rights reserved.
//
//  Modify from |AUISelectiveBordersView|
//  https://github.com/adam-siton/AUISelectiveBordersView
//

#import "CYBorderLayer.h"

#pragma mark - CYBorderStyle

@interface CYBorderStyle : NSObject

@property (nonatomic, assign) UIEdgeInsets  insets;
@property (nonatomic, assign) CGFloat       width;
@property (nonatomic, strong) UIColor      *color;
@property (nonatomic, assign) CYBorderMask  mask;

@end

@implementation CYBorderStyle

- (id)initWithInsets:(UIEdgeInsets)insets width:(CGFloat)width color:(UIColor *)color mask:(CYBorderMask)mask
{
    if (self = [super init]) {
        self.insets = insets;
        self.width = width;
        self.color = color;
        self.mask = mask;
    }
    return self;
}

@end

@interface CYBorderLayer ()
{
    NSMutableDictionary  *extBorderStyles_;
}

//initialize the border property
- (void)config;
//draw borders
- (void)draw;

@end

@implementation CYBorderLayer

- (id)init
{
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config
{
    // Initialize defaults
    borderInsets_  = UIEdgeInsetsZero;
    borderWidth_   = 0.0;
    borderColor_   = [UIColor blackColor];
    _borderMask    = CYBorderNone;
}

- (void)dealloc
{
    borderColor_   = nil;
    borderLayer_   = nil;
}

// We need the borderLayer to always be the top most layer, so each time the subLayers positioning change, we place the borderLayer at the top.
-(void) layoutSublayers {
    [super layoutSublayers];
    [self draw];
    // Move the borders to the top
    borderLayer_.zPosition = self.sublayers.count;
}

- (void)draw
{
    [self drawBorderInLayer:borderLayer_ insets:borderInsets_ width:borderWidth_ color:borderColor_.CGColor mask:_borderMask];
    for (CAShapeLayer *layer in borderLayer_.sublayers) {
        CYBorderStyle *style = [extBorderStyles_ objectForKey:@([layer hash])];
        if (style) {
            [self drawBorderInLayer:layer insets:style.insets width:style.width color:style.color.CGColor mask:style.mask];
        }
    }
}

- (void)drawBorderInLayer:(CAShapeLayer *)layer
                   insets:(UIEdgeInsets)insets
                    width:(CGFloat)width
                    color:(CGColorRef)color
                     mask:(CYBorderMask)mask
{
    if (!layer)
        return;
    // Create border path
    CGRect r = UIEdgeInsetsInsetRect(self.bounds, insets);
    UIBezierPath *path = [self pathForLayerInRect:r width:width mask:mask];
    if (!path) {
        return;
    }
    
    layer.frame = r;
    layer.path = path.CGPath;
    layer.strokeColor = color;
    layer.lineWidth = width;
}

- (UIBezierPath *)pathForLayerInRect:(CGRect)rect
                               width:(CGFloat)width
                                mask:(CYBorderMask)mask
{
    if ([self.dataSource respondsToSelector:@selector(pathForBorderLayer:padding:width:)]) {
        return [self.dataSource pathForBorderLayer:self rect:rect width:width];
    }
    return [self _pathForLayerInRect:rect width:width mask:mask];
}

- (void)addBorder:(CYBorderMask)mask
           insets:(UIEdgeInsets)insets
            width:(CGFloat)width
            color:(UIColor *)color
{
    if (mask == CYBorderNone) {
        return;
    }
    
    if (!borderLayer_) { //!< Add base border
        borderInsets_ = insets;
        [self setBorderWidth:width];
        [self setBorderColor:color.CGColor];
        [self setBorderMask:mask];
    } else { //!< Add more border
        if (!extBorderStyles_) {
            extBorderStyles_ = [[NSMutableDictionary alloc] init];
        }
        // Create a new layer to draw border
        CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
        [borderLayer_ addSublayer:borderLayer];
        // Save border's style
        [extBorderStyles_ setObject:[[CYBorderStyle alloc] initWithInsets:insets width:width color:color mask:mask] forKey:@([borderLayer hash])];
    }
    return;
}

- (void)removeBorders
{
    [borderLayer_ removeFromSuperlayer];
    borderLayer_ = nil;
}

- (void)setBorder:(CYBorderMask)mask
           insets:(UIEdgeInsets)insets
            width:(CGFloat)width
            color:(UIColor *)color
{
    if (mask == CYBorderNone) {
        [self removeBorders];
        return;
    }
    if (borderLayer_) { //!< Remove ext-borders
        borderLayer_.sublayers = nil;
    }
    borderInsets_ = insets;
    [self setBorderWidth:width];
    [self setBorderColor:color.CGColor];
    [self setBorderMask:mask];
}

#pragma mark - Properties

- (void)setBorderMask:(CYBorderMask)borderMask
{
    // Lazily create the border layer only if setting the selective borders property
    if (!borderLayer_ && borderMask != CYBorderNone) {
        borderLayer_ = [[CAShapeLayer alloc] init];
        [self addSublayer:borderLayer_];
    }
    
    _borderMask = borderMask;
    
    [self draw];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    borderWidth_ = borderWidth;
    borderLayer_.lineWidth = borderWidth;
}

- (CGColorRef)borderColor
{
    return borderColor_.CGColor;
}

- (void)setBorderColor:(CGColorRef)borderColor
{
    borderColor_ = [UIColor colorWithCGColor:borderColor];
    borderLayer_.strokeColor = borderColor;
}

#pragma mark - Private

- (UIBezierPath *)_pathForLayerInRect:(CGRect)rect
                                width:(CGFloat)width
                                 mask:(CYBorderMask)mask
{
    if (_borderMask == CYBorderNone) {
        return nil;
    }
    
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    CGFloat d  = width / 2;
    CGFloat mx = rect.size.width;
    CGFloat my = rect.size.height;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    if (mask & CYBorderLeft) { // left border
        p1.x = d, p1.y = 0;
        p2.x = d, p2.y = my;
        [path moveToPoint:p1];
        [path addLineToPoint:p2];
    }
    if (mask & CYBorderRight) { // right border
        p1.x = mx - d, p1.y = 0;
        p2.x = mx - d, p2.y = my;
        [path moveToPoint:p1];
        [path addLineToPoint:p2];
    }
    if (mask & CYBorderTop) { // top border
        p1.x = 0, p1.y = d;
        p2.x = mx, p2.y = d;
        [path moveToPoint:p1];
        [path addLineToPoint:p2];
    }
    if (mask & CYBorderBottom) { // bottom border
        p1.x = 0, p1.y = my - d;
        p2.x = mx, p2.y = my - d;
        [path moveToPoint:p1];
        [path addLineToPoint:p2];
    }
    return path;
}

@end

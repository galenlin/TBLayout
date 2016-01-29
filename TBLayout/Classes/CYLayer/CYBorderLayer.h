//
//  CYBorderLayer.h
//  MainWebsite
//
//  Created by galen on 13-7-27.
//  Copyright (c) 2013年 273.cn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@protocol CYBorderLayerDataSource;

typedef NS_OPTIONS(NSUInteger, CYBorderMask) {
    CYBorderNone     = 0,
    CYBorderTop      = 1 << 0,
    CYBorderBottom   = 1 << 1,
    CYBorderLeft     = 1 << 2,
    CYBorderRight    = 1 << 3,
};

#define CYBorderLeftBottom  (CYBorderLeft | CYBorderBottom)
#define CYBorderTopRight    (CYBorderTop | CYBorderRight)
#define CYBorderAll         (CYBorderLeftBottom | CYBorderTopRight)

@interface CYBorderLayer : CALayer {
    UIEdgeInsets    borderInsets_;
    CGFloat         borderWidth_;
    UIColor       * borderColor_;
    CAShapeLayer  * borderLayer_;
}

@property (nonatomic, assign) CYBorderMask borderMask;
@property (nonatomic, assign) id<CYBorderLayerDataSource> dataSource;

/// Add border
- (void)addBorder:(CYBorderMask)mask
           insets:(UIEdgeInsets)insets
            width:(CGFloat)width
            color:(UIColor *)color;

- (void)removeBorders;

- (void)setBorder:(CYBorderMask)mask
           insets:(UIEdgeInsets)insets
            width:(CGFloat)width
            color:(UIColor *)color;

@end

//___________________________________________________________________________________________________

@protocol CYBorderLayerDataSource <NSObject>

- (UIBezierPath *)pathForBorderLayer:(id)layer rect:(CGRect)rect width:(CGFloat)width;

@end

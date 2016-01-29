//
//  UIView+CYBorderLayer.h
//  MainWebsite
//
//  Created by galen on 13-8-16.
//  Copyright (c) 2013年 273.cn. All rights reserved.
//
//  Customize your view with selective border.
//  - 1. add |SUPPORT_CYBORDER_DRAWING()| macro to your view's implement.
//  - 2. call [self addBorder:..] or [self setBorder:..].
//

#import <UIKit/UIKit.h>
#import "CYBorderLayer.h"

/**
 * 开启边框自绘支持
 */
#define SUPPORT_CYBORDER_DRAWING()   \
+ (Class)layerClass \
{   \
    return [CYBorderLayer class];   \
}

@interface UIView (CYBorderLayer)

/**
 * 添加边框
 * @param mask 需要绘制的边框位置：上左下右，可组合. @see CYBorderMask
 * @param insets 边框距离边界的距离：上左下右
 * @param width 边框宽度
 * @param color 边框颜色
 */
- (void)addBorder:(CYBorderMask)mask
           insets:(UIEdgeInsets)insets
            width:(CGFloat)width
            color:(UIColor *)color;

- (void)addBorder:(CYBorderMask)mask
            width:(CGFloat)width
            color:(UIColor *)color;
/**
 * 移除所有边框
 */
- (void)removeBorders;
/**
 * 设置边框
 * 将移除已添加的所有边框
 */
- (void)setBorder:(CYBorderMask)mask
           insets:(UIEdgeInsets)insets
            width:(CGFloat)width
            color:(UIColor *)color;

- (void)setBorder:(CYBorderMask)mask
            width:(CGFloat)width
            color:(UIColor *)color;

/**
 * 是否存在边框
 */
- (CYBorderMask)borderMask;

@end

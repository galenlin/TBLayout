//
//  UIView+CYBorderLayer.m
//  MainWebsite
//
//  Created by galen on 13-8-16.
//  Copyright (c) 2013年 273.cn. All rights reserved.
//

#import "UIView+CYBorderLayer.h"

@implementation UIView (CYBorderLayer)

- (void)addBorder:(CYBorderMask)mask
           insets:(UIEdgeInsets)insets
            width:(CGFloat)width
            color:(UIColor *)color
{
    if (![self.layer isKindOfClass:[CYBorderLayer class]]) {
        NSLog(@"[Warnning] `%s` can only be called by UIView with `CYBorderLayer`", __PRETTY_FUNCTION__);
    } else {
        [((CYBorderLayer *)self.layer) addBorder:mask insets:insets width:width color:color];
    }
}

- (void)addBorder:(CYBorderMask)mask width:(CGFloat)width color:(UIColor *)color
{
    return [self addBorder:mask insets:UIEdgeInsetsZero width:width color:color];
}

- (void)removeBorders
{
    if (![self.layer isKindOfClass:[CYBorderLayer class]]) {
        NSLog(@"[Warnning] `%s` can only be called by UIView with `CYBorderLayer`", __PRETTY_FUNCTION__);
    } else {
        [((CYBorderLayer *)self.layer) removeBorders];
    }
}

- (void)setBorder:(CYBorderMask)mask insets:(UIEdgeInsets)insets width:(CGFloat)width color:(UIColor *)color
{
    if (![self.layer isKindOfClass:[CYBorderLayer class]]) {
        NSLog(@"[Warnning] `%s` can only be called by UIView with `CYBorderLayer`", __PRETTY_FUNCTION__);
    } else {
        [((CYBorderLayer *)self.layer) setBorder:mask insets:insets width:width color:color];
    }
}

- (void)setBorder:(CYBorderMask)mask width:(CGFloat)width color:(UIColor *)color
{
    return [self setBorder:mask insets:UIEdgeInsetsZero width:width color:color];
}

- (CYBorderMask)borderMask
{
    if (![self.layer isKindOfClass:[CYBorderLayer class]]) {
        NSLog(@"[Warnning] `%s` can only be called by UIView with `CYBorderLayer`", __PRETTY_FUNCTION__);
        return CYBorderNone;
    } else {
        return [((CYBorderLayer *)self.layer) borderMask];
    }
}

@end

//
//  UIButton+TBLayoutAttribute.m
//  TBLayout
//
//  Created by galen on 15/1/16.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "UIButton+TBLayoutAttribute.h"
#import "UIButton+WebCache.h"

@implementation UIButton (TBLayoutAttribute)

- (void)setImageUrl:(NSString *)url {
    [self sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
}

@end

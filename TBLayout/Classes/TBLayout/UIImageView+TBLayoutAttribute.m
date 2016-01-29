//
//  UIImageView+TBLayoutAttribute.m
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "UIImageView+TBLayoutAttribute.h"
#import "UIImageView+WebCache.h"


@implementation UIImageView (TBLayoutAttribute)

- (void)setImageUrl:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void)setMaskImageName:(NSString *)imageName
{
    // Stretch image
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
//    // Mask layer
//    CALayer *mask = [CALayer layer];
//    mask.contents = (id)[image CGImage];
//    mask.frame = self.bounds;
//    self.layer.mask = mask;
//    self.layer.masksToBounds = YES;
    [self setImage:image];
}

- (void)setBundleImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName]];
}

@end

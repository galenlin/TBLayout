//
//  UIImageView+TBLayoutAttribute.h
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (TBLayoutAttribute)

- (void)setImageUrl:(NSString *)url;
- (void)setMaskImageName:(NSString *)imageName;
- (void)setBundleImageName:(NSString *)imageName;

@end

//
//  TBFrameLayout.m
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "TBFrameLayout.h"

@implementation TBFrameLayout

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)render {
    [super render];
    // Subviews
    for (NSInteger i = [_sublayouts count] - 1; i >= 0; i--) {
        TBLayout *layout = [_sublayouts objectAtIndex:i];
        [self addSubview:layout];
    }
}

@end

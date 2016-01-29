//
//  TBLinearLayout.m
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "TBLinerLayout.h"

@implementation TBLinerLayout

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)render {
    [super render];
    for (TBLayout *layout in _sublayouts) {
        CGRect frame = [layout frame];
        if (frame.size.width == 0) {
            NSLog(@"xxx");
        }
        if (self.orientation == 0) {
            // Horizental
            frame.origin.x = _currentOffset + layout.marginLeft;
            [layout setFrame:frame];
            _currentOffset += frame.size.width + layout.marginLeft + layout.marginRight;
        } else {
            // Vertical
            frame.origin.y = _currentOffset + layout.marginTop;
            [layout setFrame:frame];
            _currentOffset += frame.size.height + layout.marginTop + layout.marginBottom;
        }
        
        [self addSubview:layout];
    }
}

@end

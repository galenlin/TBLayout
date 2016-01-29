//
//  TBLinearLayout.h
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBLayout.h"

@interface TBLinerLayout : TBLayout
{
    CGFloat _currentOffset;
}

@property (nonatomic, assign) int orientation;

@end

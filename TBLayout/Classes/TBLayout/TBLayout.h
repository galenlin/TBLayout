//
//  TBLayout.h
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CYBorderLayer.h"

@interface TBLayout : UIView
{
  @protected
    NSMutableArray      *_sublayouts;
    NSMutableDictionary *_undefinedProperties;
}

@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;

@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) CGFloat marginLeft;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) CGFloat marginRight;

@property (nonatomic, strong) NSDictionary *style;
@property (nonatomic, strong) NSString *backgroundColor;

@property (nonatomic, strong) NSArray *viewItems;
@property (nonatomic, strong) NSDictionary *dataSource;

+ (TBLayout *)layoutWithDataSource:(NSDictionary *)dataSource parentSize:(CGSize)size;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)render;

@end

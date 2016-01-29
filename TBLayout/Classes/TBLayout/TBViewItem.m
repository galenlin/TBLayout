//
//  TBViewItem.m
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "TBViewItem.h"
#import "TBLayoutUtils.h"
#import "UIImageView+TBLayoutAttribute.h"

NSString *const TBViewItemClickNotification = @"TBViewItemClickNotification";

@implementation TBViewItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)render {
    [super render];
    if (self.viewClass == nil) {
        return;
    }
    
    Class viewClass = NSClassFromString(self.viewClass);
    if (viewClass == nil) {
        return;
    }
    
    // ContentView
    id contentView = [[viewClass alloc] initWithFrame:self.bounds];
    for (NSString *key in _undefinedProperties) {
        // KVC
        id value = [_undefinedProperties objectForKey:key];
        NSString *aKey = key;
        if ([key isEqualToString:@"NSLineBreakMode"]) {
            aKey = @"lineBreakMode";
        }
        value = [TBLayoutUtils valueForKey:aKey byReplaceValue:value withDataSource:self.dataSource];
        
        NSLog(@" -- %@=%@", key, value);
        
        if (value != nil) {
            @try {
                [contentView setValue:value forKey:aKey];
            }
            @catch (NSException *exception) {
                NSLog(@"<%@> set value to undefined key '%@'", self.viewClass, key);
            }
        }
    }
    
    if ([contentView isKindOfClass:[UIButton class]]) {
        [contentView addTarget:self action:@selector(linkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Internal UI components
    NSString *type = [self.dataSource objectForKey:@"type"];
    if ([type isEqualToString:@"banner"]) {
        
    }
    
    [self addSubview:contentView];
}

- (void)linkButtonClick:(id)sender {
    NSString *url = [TBLayoutUtils valueForKey:nil byReplaceValue:_url withDataSource:self.dataSource];
    [[NSNotificationCenter defaultCenter] postNotificationName:TBViewItemClickNotification object:url];
}

@end

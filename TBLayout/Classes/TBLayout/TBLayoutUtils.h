//
//  TBLayoutUtils.h
//  dependentDemo
//
//  Created by galen on 14/12/19.
//  Copyright (c) 2014年 galen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBLayout.h"

@interface TBLayoutUtils : NSObject

+ (UIColor *)colorWithString:(NSString *)aString;
+ (NSString *)templateForName:(NSString *)name;
+ (id)valueForKey:(NSString *)key byReplaceValue:(id)value withDataSource:(NSDictionary *)dataSource;

@end

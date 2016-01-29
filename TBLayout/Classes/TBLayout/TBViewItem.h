//
//  TBViewItem.h
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "TBLayout.h"

NSString *const TBViewItemClickNotification;

@interface TBViewItem : TBLayout

@property (nonatomic, strong) NSString *viewClass;

@property (nonatomic, strong) NSString *url; // for UIButton

@end

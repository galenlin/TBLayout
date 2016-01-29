//
//  LayoutScrollView.m
//  dependentDemo
//
//  Created by galen on 14/12/19.
//  Copyright (c) 2014年 galen. All rights reserved.
//

#import "LayoutScrollView.h"
#import "TBLayoutUtils.h"
#import "TBLinerLayout.h"

@interface LayoutScrollView ()
{
    NSMutableDictionary *_groups; // 分组数据
    NSInteger            _currentGroup;
    CGFloat              _contentHeight;
}

@end

@implementation LayoutScrollView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (void)awakeFromNib {
    [self config];
}

- (void)config {
    _currentGroup = 1;
    self.scrollEnabled = YES;
}

- (void)loadDataWithPlist:(NSString *)plist
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:plist ofType:nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *data = nil;
    for (NSString *key in dict) {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            data = value;
            break;
        }
    }
    NSArray *sections = [data objectForKey:@"section"];
    
    _groups = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0; i < [sections count]; i++) {
        NSDictionary *sectionItem = [sections objectAtIndex:i];
        // Group items by 'group'
        NSString *group = [sectionItem objectForKey:@"group"];
        NSMutableArray *groupItems = [_groups objectForKey:group];
        if (groupItems == nil) {
            groupItems = [[NSMutableArray alloc] init];
            [_groups setObject:groupItems forKey:group];
        }
        [groupItems addObject:sectionItem];
    }
    
    [self showViewForGroup:_currentGroup];
}

- (void)showViewForGroup:(NSInteger)group
{
    _contentHeight = 0;
    
    // 显示该组的全部数据
    NSArray *items = [_groups objectForKey:[NSString stringWithFormat:@"%i", (int)group]];
    if (items == nil) {
        return;
    }
    for (NSInteger i = 0; i < [items count]; i++) {
        [self addSubviewToLineWithData:[items objectAtIndex:i]];
    }
    
    // 显示下一组的第一个数据
    NSArray *nextItems = [_groups objectForKey:[NSString stringWithFormat:@"%i", (int)(group + 1)]];
    if (nextItems != nil) {
        [self addSubviewToLineWithData:[nextItems firstObject]];
    }
    
    [self setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, _contentHeight)];
}

- (void)addSubviewToLineWithData:(NSDictionary *)data
{
    TBLayout *layout = [TBLayout layoutWithDataSource:data parentSize:self.bounds.size];
    if (layout != nil) {
        CGRect frame = [layout frame];
        frame.origin.y = _contentHeight + layout.marginTop;
        [layout setFrame:frame];
        _contentHeight += frame.size.height + layout.marginTop + layout.marginBottom;
        
        [self addSubview:layout];
    }
}

@end

//
//  TBLayout.m
//  dependentDemo
//
//  Created by galen on 15/1/14.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "TBLayout.h"
#import "TBLayoutUtils.h"
#import "NSDictionary_JSONExtensions.h"
#import "UIImageView+WebCache.h"

@implementation TBLayout

SUPPORT_CYBORDER_DRAWING()

+ (TBLayout *)layoutWithDataSource:(NSDictionary *)dataSource parentSize:(CGSize)size
{
    NSString *template = nil;
    NSString *templateName = [dataSource objectForKey:@"template"];
    NSString *templateUrl = nil;
    if (templateName != nil) {
        template = [TBLayoutUtils templateForName:templateName];
    } else {
        templateUrl = [dataSource objectForKey:@"templateUrl"];
        if (templateUrl != nil) {
            NSError *error = nil;
            template = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:templateUrl] encoding:NSUTF8StringEncoding error:&error];
            if (error != nil) {
                NSLog(@"error: %@", error);
                return nil;
            }
        }
    }
    
    if (template == nil || [template isEqualToString:@""]) {
        NSLog(@"Missing template! (name=%@, url=%@)", templateName, templateUrl);
        return nil;
    }
    
    return [self layoutWithTemplate:template dataSource:dataSource parentSize:size];
}

+ (TBLayout *)layoutWithTemplate:(NSString *)aTemplate dataSource:(NSDictionary *)dataSource parentSize:(CGSize)size
{
    NSError *error = nil;
    NSDictionary *layoutDescriptor = [NSDictionary dictionaryWithJSONString:aTemplate error:&error];
    if (error != nil) {
        NSLog(@"Parse template error: %@", error);
        return nil;
    }
    
    return [self layoutWithDescriptor:layoutDescriptor dataSource:dataSource parentSize:size];
}

+ (TBLayout *)layoutWithDescriptor:(NSDictionary *)layoutDescriptor dataSource:(NSDictionary *)dataSource parentSize:(CGSize)size
{
    NSString *layoutType = [[layoutDescriptor allKeys] firstObject];
    Class layoutClass = NSClassFromString(layoutType);
    if (layoutClass == nil) {
        NSLog(@"Unknown layout type: %@", layoutType);
        return nil;
    }
    
    NSDictionary *layoutAttributes = [layoutDescriptor objectForKey:layoutType];
    TBLayout *layout = [[layoutClass alloc] initWithDictionary:layoutAttributes];
    [layout setDataSource:dataSource];
    [layout adjustSizeByParentSize:size];
    [layout render];
    return layout;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        for (NSString *key in dictionary) {
            // KVC
            id value = [dictionary objectForKey:key];
            @try {
                [self setValue:value forKey:key];
            }
            @catch (NSException *exception) {
                if (_undefinedProperties == nil) {
                    _undefinedProperties = [[NSMutableDictionary alloc] init];
                }
                [_undefinedProperties setObject:value forKey:key];
            }
        }
    }
    return self;
}

- (void)render
{
    CGRect frame = CGRectMake(0, 0, [self.width floatValue], [self.height floatValue]);
    // Margins
    UIEdgeInsets insets = UIEdgeInsetsMake(self.marginTop, self.marginLeft, self.marginBottom, self.marginRight);
    frame = UIEdgeInsetsInsetRect(frame, insets);
    [self setFrame:frame];
    if (frame.size.width == 0) {
        NSLog(@"333333");
    }
    NSLog(@">> %@ render at (%.2f,%.2f),[%.2f,%.2f]", [[self class] description], frame.origin.x, frame.origin.y ,frame.size.width,frame.size.height);
    if (self.viewItems == nil) {
        return;
    }
    
    // Styles
    [self applyStyles];
    
    // Generate sublayouts
    NSInteger itemCount = [self.viewItems count];
    _sublayouts = [[NSMutableArray alloc] initWithCapacity:itemCount];
    for (NSInteger i = 0; i < itemCount; i++) {
        NSDictionary *layoutDescriptor = [self.viewItems objectAtIndex:i];
        TBLayout *layout = [TBLayout layoutWithDescriptor:layoutDescriptor dataSource:self.dataSource parentSize:frame.size];
        if (layout != nil) {
            [_sublayouts addObject:layout];
        }
    }
}

- (void)setBackgroundColor:(NSString *)backgroundColor {
    [super setBackgroundColor:[TBLayoutUtils colorWithString:backgroundColor]];
}

- (void)adjustSizeByParentSize:(CGSize)size {
    if (self.width == nil) {
        self.width = @(size.width);
    } else if ([self.width isKindOfClass:[NSString class]]) {
        NSString *widthDesc = (id)self.width;
        if ([widthDesc isEqualToString:@"fill_parent"]) {
            self.width = @(size.width);
        }
    }
    
    if (self.height == nil) {
        self.height = @(size.width);
    } else if ([self.height isKindOfClass:[NSString class]]) {
        NSString *widthDesc = (id)self.height;
        if ([widthDesc isEqualToString:@"fill_parent"]) {
            self.height = @(size.height);
        }
    }
}

- (void)applyStyles
{
    [self applyStyle:self.style];
}

- (void)applyStyle:(NSDictionary *)style {
    if (style == nil) {
        return;
    }
    
    // Background - SolidFill
    NSDictionary *aStyle = [style objectForKey:@"TTSolidFillStyle"];
    if (aStyle != nil) {
        NSString *colorDesc = [aStyle objectForKey:@"color"];
        UIColor *color = [TBLayoutUtils colorWithString:colorDesc];
        [super setBackgroundColor:color];
        
        // Apply recursively
        return [self applyStyle:[aStyle objectForKey:@"next"]];
    }
    
    // Borders
    aStyle = [style objectForKey:@"TTFourBorderStyle"];
    if (aStyle != nil) {
        NSString *borderWidthDesc = [aStyle objectForKey:@"width"];
        CGFloat borderWidth = [borderWidthDesc floatValue];
        if (borderWidth != 0) {
            // Set border for 4 positions
            NSArray *positions = @[@"left", @"right", @"top", @"bottom"];
            NSArray *masks = @[@(CYBorderLeft), @(CYBorderRight), @(CYBorderTop), @(CYBorderBottom)];
            
            for (NSInteger i = 0; i < 4; i++) {
                NSString *position = [positions objectAtIndex:i];
                NSString *borderDesc = [aStyle objectForKey:position];
                if (borderDesc != nil) {
                    UIColor *borderColor = [TBLayoutUtils colorWithString:borderDesc];
                    CYBorderMask mask = (CYBorderMask)[[masks objectAtIndex:i] intValue];
                    [self addBorder:mask insets:UIEdgeInsetsZero width:borderWidth color:borderColor];
                }
            }
        }
        
        // Apply recursively
        return [self applyStyle:[aStyle objectForKey:@"next"]];
    }
}

@end

//
//  TBLayoutUtils.m
//  dependentDemo
//
//  Created by galen on 14/12/19.
//  Copyright (c) 2014年 galen. All rights reserved.
//

#import "TBLayoutUtils.h"

@implementation TBLayoutUtils

+ (NSString *)templateForName:(NSString *)name
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *jsonPath = [bundle pathForResource:name ofType:@"json"];
    NSData *templateData = [[NSFileManager defaultManager] contentsAtPath:jsonPath];
    NSString *templateString = [[NSString alloc] initWithData:templateData encoding:NSUTF8StringEncoding];
    return templateString;
}

+ (UIColor *)colorWithString:(NSString *)aString
{
    if ([aString isEqualToString:@"clear"]) {
        return [UIColor clearColor];
    }
    
    UIColor *color = nil;
    NSArray *components = [aString componentsSeparatedByString:@"_"];
    NSString *type = [components firstObject];
    if ([type isEqualToString:@"rgba"]) {
        NSArray *colors = [[components lastObject] componentsSeparatedByString:@","];
        CGFloat r = [[colors objectAtIndex:0] floatValue] / 0xff;
        CGFloat g = [[colors objectAtIndex:1] floatValue] / 0xff;
        CGFloat b = [[colors objectAtIndex:2] floatValue] / 0xff;
        CGFloat a = [[colors objectAtIndex:3] floatValue];
        color = [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return color;
}

+ (UIFont *)fontWithString:(NSString *)aString
{
    UIFont *font = nil;
    NSArray *components = [aString componentsSeparatedByString:@"_"];
    
    NSString *fontName = nil;
    CGFloat fontSize = 0;
    switch ([components count]) {
        case 1:
            // 12
            fontSize = [aString floatValue];
            font = [UIFont systemFontOfSize:fontSize];
            break;
        case 2:
            // Arial_12 or bold_12
            fontSize = [[components lastObject] floatValue];
            fontName = [components firstObject];
            if ([fontName isEqualToString:@"bold"]) {
                font = [UIFont boldSystemFontOfSize:fontSize];
            } else if ([fontName isEqualToString:@"italic"]) {
                font = [UIFont italicSystemFontOfSize:fontSize];
            } else {
                font = [UIFont fontWithName:fontName size:fontSize];
            }
            break;
            
        default:
            font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            break;
    }
    return font;
}

+ (id)valueForKey:(NSString *)key byReplaceValue:(id)value withDataSource:(NSDictionary *)dataSource
{
    if ([key isEqualToString:@"font"]) {
        return [self fontWithString:value];
    } else if ([key isEqualToString:@"textColor"] ||
               [key isEqualToString:@"backgroundColor"]) {
        return [self colorWithString:value];
    } else {
        if ([value isKindOfClass:[NSString class]]) {
            if ([value rangeOfString:@"$"].length != 0) {
                // TODO: parse macro
                NSError *error;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\$([^\\$]+)\\$" options:0 error:&error];
                
                if (regex != nil) {
                    NSArray *matches = [regex matchesInString:value options:0 range:NSMakeRange(0, [value length])];
                    NSString *macro = value;
                    value = dataSource;
                    for (NSInteger i = 0; i < [matches count]; i++) {
                        
                        NSTextCheckingResult *result = [matches objectAtIndex:i];
                        NSRange range = [result rangeAtIndex:1];
                        NSString *property = [macro substringWithRange:range];
                        
                        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w+)\\[(\\d+)\\]" options:0 error:&error];
                        NSTextCheckingResult *ret = nil;
                        if (regex != nil) {
                            ret = [regex firstMatchInString:property options:0 range:NSMakeRange(0, [property length])];
                        }
                        if (ret != nil) {
                            // Array
                            NSString *aKey = [property substringWithRange:[ret rangeAtIndex:1]];
                            NSInteger anIndex = [[property substringWithRange:[ret rangeAtIndex:2]] integerValue];
                            value = [value objectForKey:aKey];
                            if (anIndex < [value count]) {
                                value = [value objectAtIndex:anIndex];
                            } else {
                                value = nil;
                                break;
                            }
                        } else {
                            NSArray *arr = [property componentsSeparatedByString:@"@"];
                            if ([arr count] == 2) {
                                // xx@local
                                value = [value objectForKey:[arr firstObject]];
                            } else {
                                value = [value objectForKey:property];
                            }
                            NSLog(@" == %@ -> %@", macro, value);
                        }
                    }
                }
            }
        }
    }
    
    return value;
}

@end

//
//  UIColor+Extend.m
//  WuXin
//
//  Created by 姚梦龙 on 16/3/22.
//  Copyright © 2016年 WX. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)

+ (UIColor *)hexChangeFloat:(NSString *)hexColor
{
    return [self hexChangeFloat:hexColor alpha:1.0];
}

+ (UIColor *)hexChangeFloat:(NSString *)hexColor alpha:(CGFloat)alpha
{
    unsigned int redInt, greenInt, blueInt;
    NSRange range;
    range.length = 2;//长度范围为2
    
    //取红色的值
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&redInt];
    
    //取绿色的值
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&greenInt];
    
    //取蓝色值
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blueInt];
    
    if (alpha > 1) {
        alpha = 1.0;
    }else if (alpha < 0.0){
        alpha = 0.0;
    }
    
    return [UIColor colorWithRed:redInt/255.0 green:greenInt/255.0 blue:blueInt/255.0 alpha:alpha];
}


@end

//
//  UIColor+Extend.h
//  WuXin
//
//  Created by 姚梦龙 on 16/3/22.
//  Copyright © 2016年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)

+ (UIColor *)hexChangeFloat:(NSString *)hexColor;

+ (UIColor *)hexChangeFloat:(NSString *)hexColor alpha:(CGFloat)alpha;

@end

//
//  UIView+Extension.h
//  WuXin
//
//  Created by 姚梦龙 on 16/3/17.
//  Copyright © 2016年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

- (UIViewController *)viewController;
- (void)setBorderWidth:(CGFloat)width withBroderColor:(UIColor*)color withCornerRadius:(CGFloat)cornerRadius;

@end

//
//  SpecialView.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "SpecialView.h"
#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height
@implementation SpecialView




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ref, 30, 90);
    CGContextAddLineToPoint(ref,Kwidth - 30 , 90);
    CGContextAddLineToPoint(ref, Kwidth - 30, 90 + 122);
    CGContextAddLineToPoint(ref, 30, 90 + 122);
    CGContextAddLineToPoint(ref, 30, 90);
    CGContextClosePath(ref);
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(ref, kCGPathStroke);
}


@end

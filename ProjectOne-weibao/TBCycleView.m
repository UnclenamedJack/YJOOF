//
//  TBCycleView.m
//  TBCycleProgress
//
//  Created by qianjianeng on 16/2/22.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "TBCycleView.h"
#import "UIColor+Extend.h"
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
@interface TBCycleView ()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end
@implementation TBCycleView

- (UILabel *)label
{
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self addSubview:label];
        _label = label;
    }
   
    return _label;
}

- (void)drawProgress:(CGFloat )progress
{
    _progress = progress;
    _progressLayer.opacity = 0;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self drawCycleProgress];
}

- (void)drawCycleProgress
{
    CGPoint center = CGPointMake(0, 0);
    //CGPoint center = CGPointMake(kWidth/4.0 - 150, 152);
    CGFloat radius;
    if (kHeight == 480.0) {
         radius = 214.0/2.0;
    }else if (kHeight == 568.0) {
         radius = 214.0/2.0;
    }else if (kHeight == 667.0) {
         radius = 254/2.0;
    }else{
         radius = 429/3.0;
    }
    //CGFloat radius = 123;
    CGFloat startA = - M_PI*5/4;  //设置进度条起点位置
    CGFloat endA = -M_PI*5/4 + (M_PI * 3/2) * _progress;  //设置进度条终点位置
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为27，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    //_progressLayer.strokeColor = [UIColor hexChangeFloat:@"f4f6fa"].CGColor;
    _progressLayer.strokeColor = [[UIColor colorWithRed:71/255.0 green:72/255.0 blue:75/255.0 alpha:1.0] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapSquare;//指定线的边缘是圆的
    _progressLayer.lineWidth = 18;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    [self.layer addSublayer:_progressLayer];
    //生成渐变色
//    CALayer *gradientLayer = [CALayer layer];
//    
//    //左侧渐变色
//    CAGradientLayer *leftLayer = [CAGradientLayer layer];
//    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);    // 分段设置渐变色
//    leftLayer.locations = @[@0.3, @0.9, @1];
//    leftLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor greenColor].CGColor];
//    [gradientLayer addSublayer:leftLayer];
//    
//    //右侧渐变色
//    CAGradientLayer *rightLayer = [CAGradientLayer layer];
//    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
//    rightLayer.locations = @[@0.3, @0.9, @1];
//    rightLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor redColor].CGColor];
//    [gradientLayer addSublayer:rightLayer];
//    
//    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
//    [self.layer addSublayer:gradientLayer];
//    
}


@end

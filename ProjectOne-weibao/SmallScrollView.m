//
//  SmallScrollView.m
//  腾讯新闻
//
//  Created by qingyun on 16/1/25.
//  Copyright (c) 2016年 qingyun. All rights reserved.
//

#import "SmallScrollView.h"
#import "Header.h"
#import "UIColor+Extend.h"

#define ButtonWidth [UIScreen mainScreen].bounds.size.width/4

@interface SmallScrollView ()

@property(nonatomic,strong)NSArray *buttonArr;
@property(nonatomic,strong)UIView *sliderView;

@end
@implementation SmallScrollView
-(instancetype)initWithButtonsArr:(NSArray *)arr
{
    if (self = [super init]) {
        
        self.showsVerticalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        if (kHeight == 480.0) {
            self.frame = CGRectMake(0, 0, ScreenWidth, 30);
        }else if (kHeight == 568.0){
            self.frame = CGRectMake(0, 0, ScreenWidth, 35);
        }else{
            self.frame = CGRectMake(0, 0, ScreenWidth, 40);
        }
      
        self.contentSize = CGSizeMake(arr.count * ButtonWidth, 0);
        self.backgroundColor = [UIColor hexChangeFloat:@"ffffff"];
        self.selectedColor = [UIColor hexChangeFloat:@"0094e9"];
        
        [self createSlidView];

        NSMutableArray *btsArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTintColor:self.backgroundColor];
            if (kHeight == 480.0) {
                [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
                button.frame = CGRectMake(ButtonWidth * i, 0, ButtonWidth, 25);
            }else if (kHeight == 568.0){
                [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
                 button.frame = CGRectMake(ButtonWidth * i, 0, ButtonWidth, 35);
            }else{
                [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
                 button.frame = CGRectMake(ButtonWidth * i, 0, ButtonWidth, 40);
            }
           
            [self addSubview:button];
            
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
            [button setTitleColor:[UIColor hexChangeFloat:@"bbbbbb"] forState:UIControlStateNormal];
            [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
             button.tag = i +100;
            
            [button addTarget:self action:@selector(buttonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btsArr addObject:button];
        }
        self.buttonArr = btsArr;
        self.index = 0;
    }
    return self;
}
-(void)buttonIsClicked:(UIButton *)sender{
    self.index = sender.tag -100;
    self.btnTitle = sender.titleLabel.text;
    if (_changeIndexValue) {
        _changeIndexValue(_index);
    }
}
- (void)createSlidView
{
    if (kHeight == 480.0) {
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, ButtonWidth, 2)];
    }else if (kHeight == 568.0){
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, ButtonWidth, 2)];
    }else{
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, ButtonWidth, 2)];
    }
    _sliderView.backgroundColor = [UIColor hexChangeFloat:@"0094e9"];
    [self addSubview:_sliderView];
    [self bringSubviewToFront:_sliderView];
    
}
-(void)setIndex:(NSInteger)index
{
    UIButton *notSelectedButton = _buttonArr[_index];
    notSelectedButton.selected = NO;
    
    UIButton *selectedButton = _buttonArr[index];
    selectedButton.selected = YES;
    CGFloat offSetX = selectedButton.frame.origin.x - ScreenWidth/2;
    offSetX = offSetX > 0 ? (offSetX + ButtonWidth/2):0;
    offSetX = offSetX > self.contentSize.width - ScreenWidth ? self.contentSize.width - ScreenWidth : offSetX;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = CGPointMake(offSetX, 0);
        
    }];
    _index = index;
   
    CGRect frame = _sliderView.frame;
    frame.origin.x = _index*ButtonWidth;
    [UIView animateWithDuration:0.3 animations:^{
        _sliderView.frame = frame;
    }];

}
@end

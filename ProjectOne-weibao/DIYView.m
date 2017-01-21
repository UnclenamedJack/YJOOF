//
//  DIYView.m
//  ProjectOne-weibao
//
//  Created by jack on 17/1/13.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "DIYView.h"
#import "Masonry.h"

@implementation DIYView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"duihuakuang"]];
        [imgView setUserInteractionEnabled:YES];
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self).offset(64+30+30+10);
            make.height.equalTo(@80);
            make.width.equalTo(@120);
        }];
        
        UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        inputBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        inputBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0) ;
        inputBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [inputBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [inputBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [inputBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [inputBtn setTitle:@"输入MAC地址" forState:UIControlStateNormal];
        [inputBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
        [imgView addSubview:inputBtn];
        [inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView).offset(5);
            make.left.equalTo(imgView);
            make.right.equalTo(imgView);
        }];
        [inputBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *middleLine = [[UIView alloc] init];
        [middleLine setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
        [imgView addSubview:middleLine];
        [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(inputBtn.mas_bottom);
            make.left.equalTo(imgView);
            make.right.equalTo(imgView);
            make.height.equalTo(@2);
        }];
        
        UIButton *exceptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exceptionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        exceptionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        exceptionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [exceptionBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [exceptionBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [exceptionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [exceptionBtn setImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
        [exceptionBtn setTitle:@"异常反馈" forState:UIControlStateNormal];
        [imgView addSubview:exceptionBtn];
        [exceptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(inputBtn.mas_bottom).offset(2);
            make.left.equalTo(inputBtn);
            make.right.equalTo(inputBtn);
            make.bottom.equalTo(imgView);
            make.height.equalTo(inputBtn);
        }];
        [exceptionBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)click:(UIButton *)sender {
    NSLog(@"hahaha");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.block){
        self.block();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

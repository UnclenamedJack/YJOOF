//
//  ChaKongCell.m
//  ProjectOne-weibao
//
//  Created by jack on 17/1/17.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "ChaKongCell.h"
#import "Masonry.h"
#import "UIColor+Extend.h"
#import "Header.h"
#import "searchModel.h"

@implementation ChaKongCell


//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//        if (self) {
//            
//            UILabel *numL = [[UILabel alloc] init];
//            [numL setText:@"①"];
//            [self.contentView addSubview:numL];
//            if (_index < 5) {
//                [numL mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.and.bottom.equalTo(self.contentView);
//                }];
//            }else{
//                [numL mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.and.bottom.equalTo(self.contentView);
//                }];
//            }
//            
//            if (self.isBinding) {
//                UILabel *macL = [[UILabel alloc] init];
//                [macL setText:self.mac];
//                [self.contentView addSubview:macL];
//                
//                UILabel *nameL = [[UILabel alloc] init];
//                [nameL setText:[NSString stringWithFormat:@"8孔智能插座-%zd",self.index]];
//                [self.contentView addSubview:nameL];
//                
//                UIButton *detatilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [detatilBtn setTitle:@"查看详情" forState:UIControlStateNormal];
//                [self.contentView addSubview:detatilBtn];
//                
//               
//                
//                [macL mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(self.contentView);
//                    make.centerY.equalTo(self.contentView).offset(-10);
//                }];
//                
//                [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(self.contentView);
//                    make.top.equalTo(macL.mas_bottom);
//                }];
//                
//                [detatilBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(self.contentView);
//                    make.top.equalTo(nameL.mas_bottom).offset(5);
//                }];
//                
//
//            }else{
//                UIImageView *imageV;
//                if (_index < 5) {
//                    imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chakongttt"]];
//                }else{
//                    imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chakong"]];
//                }
//                [self.contentView addSubview:imageV];
//                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.center.equalTo(self.contentView);
//                    make.top.equalTo(self.contentView).offset(30);
//                    make.left.equalTo(self.contentView).offset(135/2.0);
//                }];
//            }
//        }
//    return self;
//}

- (void)setIndex:(NSInteger)index {
    if (_index != index) {
        _index = index;
    }
    UILabel *numL = [[UILabel alloc] init];
    [numL setTextAlignment:NSTextAlignmentCenter];
    [numL setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
    [numL setText:[NSString stringWithFormat:@"%zd",index]];
    [self.contentView addSubview:numL];
    if (_index < 5) {
        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-3);
            make.bottom.equalTo(self.contentView).offset(-3);
            make.height.equalTo(numL.mas_width);
        }];
    }else{
        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(3);
            make.bottom.equalTo(self.contentView).offset(-3);
            make.height.equalTo(numL.mas_width);
        }];
    }
    [numL setNeedsLayout];
    [numL layoutIfNeeded];
    [numL.layer setCornerRadius:numL.bounds.size.width/2.0];
    [numL.layer setBorderColor:[UIColor hexChangeFloat:@"0a88e7"].CGColor];
    [numL.layer setBorderWidth:0.5];
}
- (void)setIsBinding:(BOOL)isBinding {
    if (_isBinding != isBinding) {
        _isBinding = isBinding;
    }
    if (self.isBinding) {
        if (self.contentView.subviews.count == 2) {
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        UILabel *macL = [[UILabel alloc] init];
        [macL setText:[NSString stringWithFormat:@"%@",self.model.num]];
        if(ScreenHeight == 480.0){
            [macL setFont:[UIFont systemFontOfSize:15]];
        }else if (ScreenHeight==568) {
            [macL setFont:[UIFont systemFontOfSize:16]];
        }else if (ScreenHeight == 667){
            [macL setFont:[UIFont systemFontOfSize:17]];
        }else{
            [macL setFont:[UIFont systemFontOfSize:18]];
        }
        [macL setTextColor:[UIColor colorWithRed:119/255.0 green:117/255.0 blue:117/255.0 alpha:1.0]];
        [self.contentView addSubview:macL];
        
        UILabel *nameL = [[UILabel alloc] init];
        if(ScreenHeight == 480.0){
            [nameL setFont:[UIFont systemFontOfSize:9.0]];
        }else if (ScreenHeight==568) {
            [nameL setFont:[UIFont systemFontOfSize:10.0]];
        }else if (ScreenHeight == 667){
            [nameL setFont:[UIFont systemFontOfSize:11.0]];
        }else{
            [nameL setFont:[UIFont systemFontOfSize:11.0]];
        }
//        [nameL setFont:[UIFont systemFontOfSize:11.0]];
        [nameL setTextColor:[UIColor colorWithRed:176/255.0 green:175/255.0 blue:176/255.0 alpha:1.0]];
//        [nameL setText:[NSString stringWithFormat:@"8孔智能插座-%zd",self.index]];
        [nameL setText:self.model.device];
        [self.contentView addSubview:nameL];
        
        UIButton *detatilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [detatilBtn.layer setCornerRadius:5.0];
        if(ScreenHeight == 480.0){
            [detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        }else if (ScreenHeight==568) {
            [detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        }else if (ScreenHeight == 667){
            [detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        }else{
            [detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        }
//        [detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
//        [detatilBtn setBackgroundColor:[UIColor hexChangeFloat:@"0a88e7"]];
        [detatilBtn.layer setBorderColor:[UIColor hexChangeFloat:@"0a88e7"].CGColor];
        [detatilBtn.layer setBorderWidth:1.0];
        [detatilBtn setTitleColor:[UIColor hexChangeFloat:@"0a88e7"] forState:UIControlStateNormal];
        [detatilBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [self.contentView addSubview:detatilBtn];
        [detatilBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [detatilBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        
        [macL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(-20);
        }];
        
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(macL.mas_bottom);
        }];
        
        [detatilBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(nameL.mas_bottom).offset(20);
            make.width.equalTo(@80);
        }];
    }else{
        if (self.contentView.subviews.count > 2) {
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        UIImageView *imageV;
        if (_index < 5) {
            imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chakongttt"]];
        }else{
            imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chakong"]];
        }
        [self.contentView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(30);
            make.left.equalTo(self.contentView).offset(135/2.0);
        }];
    }
}
- (void)click:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"0a88e7"] forState:UIControlStateNormal];
    if (self.blcok) {
        self.blcok();
    }
}
- (void)touchDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"0a88e7"]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"ffffff"] forState:UIControlStateNormal];
}
@end

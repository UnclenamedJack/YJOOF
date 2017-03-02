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
#import "binddingModel.h"
#import "chapaiModel.h"

@interface ChaKongCell ()
@property(nonatomic,strong) UILabel *macL;
@property(nonatomic,strong) UILabel *nameL;
@property(nonatomic,strong) UIButton *detatilBtn;
@property(nonatomic,strong) UILabel *numL;
@property(nonatomic,strong) UIImageView *imageV;
@end
@implementation ChaKongCell


//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//        if (self) {
//            
//            UILabel *numL = [[UILabel alloc] init];
//            [numL setText:@"1"];
//            [self.contentView addSubview:numL];
//            if (_index < 5) {
//                [numL mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.equalTo(self.contentView).offset(-3);
//                    make.bottom.equalTo(self.contentView).offset(-3);
//                    make.height.equalTo(numL.mas_width);
//                }];
//            }else{
//                [numL mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.contentView).offset(3);
//                    make.bottom.equalTo(self.contentView).offset(-3);
//                    make.height.equalTo(numL.mas_width);
//                }];
//            }
//            [numL setNeedsLayout];
//            [numL layoutIfNeeded];
//            [numL.layer setCornerRadius:numL.bounds.size.width/2.0];
//            [numL.layer setBorderColor:[UIColor hexChangeFloat:@"0a88e7"].CGColor];
//            [numL.layer setBorderWidth:0.5];
//            
//                UILabel *macL = [[UILabel alloc] init];
//                [macL setText:self.model.num];
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
//            
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
//            
//            
//           
//    }
//    return self;
//}

//- (void)setIndex:(NSInteger)index {
//    if (_index != index) {
//        _index = index;
//    }
//    UILabel *numL = [[UILabel alloc] init];
//    [numL setTextAlignment:NSTextAlignmentCenter];
//    [numL setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
//    [numL setText:[NSString stringWithFormat:@"%zd",index]];
//    [self.contentView addSubview:numL];
//    if (_index < 5) {
//        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(-3);
//            make.bottom.equalTo(self.contentView).offset(-3);
//            make.height.equalTo(numL.mas_width);
//        }];
//    }else{
//        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(3);
//            make.bottom.equalTo(self.contentView).offset(-3);
//            make.height.equalTo(numL.mas_width);
//        }];
//    }
//    [numL setNeedsLayout];
//    [numL layoutIfNeeded];
//    [numL.layer setCornerRadius:numL.bounds.size.width/2.0];
//    [numL.layer setBorderColor:[UIColor hexChangeFloat:@"0a88e7"].CGColor];
//    [numL.layer setBorderWidth:0.5];
//}
- (void)setIsBinding:(BOOL)isBinding {
    if (_isBinding != isBinding) {
        _isBinding = isBinding;
    }
    if (self.isBinding) {
//        if (self.contentView.subviews.count == 2) {
//            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        }
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        if (!self.macL) {
            self.macL = [[UILabel alloc] init];
        }
        [self.macL setText:[NSString stringWithFormat:@"%@",self.model.num]];
        if(ScreenHeight == 480.0){
            [_macL setFont:[UIFont systemFontOfSize:15]];
        }else if (ScreenHeight==568) {
            [_macL setFont:[UIFont systemFontOfSize:16]];
        }else if (ScreenHeight == 667){
            [_macL setFont:[UIFont systemFontOfSize:17]];
        }else{
            [_macL setFont:[UIFont systemFontOfSize:18]];
        }
        [_macL setTextColor:[UIColor colorWithRed:119/255.0 green:117/255.0 blue:117/255.0 alpha:1.0]];
        [self.contentView addSubview:_macL];
        
        if (!self.nameL) {
            self.nameL = [[UILabel alloc] init];
        }
        [self.nameL setText:self.model.device];
        if(ScreenHeight == 480.0){
            [_nameL setFont:[UIFont systemFontOfSize:9.0]];
        }else if (ScreenHeight==568) {
            [_nameL setFont:[UIFont systemFontOfSize:10.0]];
        }else if (ScreenHeight == 667){
            [_nameL setFont:[UIFont systemFontOfSize:11.0]];
        }else{
            [_nameL setFont:[UIFont systemFontOfSize:11.0]];
        }
//        [nameL setFont:[UIFont systemFontOfSize:11.0]];
        [_nameL setTextColor:[UIColor colorWithRed:176/255.0 green:175/255.0 blue:176/255.0 alpha:1.0]];
//        [nameL setText:[NSString stringWithFormat:@"8孔智能插座-%zd",self.index]];
        [self.contentView addSubview:_nameL];
        
        if (!self.detatilBtn) {
            self.detatilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        [self.detatilBtn.layer setCornerRadius:5.0];
        if(ScreenHeight == 480.0){
            [_detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        }else if (ScreenHeight==568) {
            [_detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        }else if (ScreenHeight == 667){
            [_detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        }else{
            [_detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        }
//        [detatilBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
//        [detatilBtn setBackgroundColor:[UIColor hexChangeFloat:@"0a88e7"]];
        [_detatilBtn.layer setBorderColor:[UIColor hexChangeFloat:@"0a88e7"].CGColor];
        [_detatilBtn.layer setBorderWidth:1.0];
        [_detatilBtn setTitleColor:[UIColor hexChangeFloat:@"0a88e7"] forState:UIControlStateNormal];
        [_detatilBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [self.contentView addSubview:_detatilBtn];
        [_detatilBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_detatilBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        
        [_macL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(-20);
        }];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(_macL.mas_bottom);
        }];
        
        [_detatilBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(_nameL.mas_bottom).offset(20);
            make.width.equalTo(@80);
        }];
    }else{
//        if (self.contentView.subviews.count > 2) {
//            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        }
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (!self.imageV) {
            self.imageV = [[UIImageView alloc] init];
        }
        if (_index < 5) {
            [_imageV setImage:[UIImage imageNamed:@"chakongttt"]];
        }else{
            [_imageV setImage:[UIImage imageNamed:@"chakong"]];
        }
        [self.contentView addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(30);
            make.left.equalTo(self.contentView).offset(135/2.0);
        }];
    }
    UILabel *numL = [[UILabel alloc] init];
    [numL setTextAlignment:NSTextAlignmentCenter];
    [numL setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
    [numL setText:[NSString stringWithFormat:@"%zd",self.index]];
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
- (void)setImageV:(UIImageView *)imageV {
    if (_imageV != imageV) {
        _imageV = imageV;
    }
}
- (void)setMacL:(UILabel *)macL {
    if (!_macL) {
        _macL = [[UILabel alloc] init];
    }
}
- (void)setNameL:(UILabel *)nameL {
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
    }
}
- (void)setDetatilBtn:(UIButton *)detatilBtn {
    if (!_detatilBtn) {
        _detatilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
}

- (void)click:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"0a88e7"] forState:UIControlStateNormal];
    if (self.blcok) {
        self.blcok();
    }
}
- (void)setModel:(searchModel *)model {
    if (_model != model) {
        _model = model;
        self.macL.text = model.num;
        self.nameL.text = model.device;
//        self.detatilBtn.titleLabel.text = 
    }
}
- (void)setModel1:(binddingModel *)model1 {
    if (_model1 != model1) {
        _model1 = model1;
        self.macL.text = model1.num;
        self.nameL.text = model1.device;
    }
}

- (void)touchDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"0a88e7"]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"ffffff"] forState:UIControlStateNormal];
}
@end

//
//  ThreeCell.m
//  ProjectOne-weibao
//
//  Created by jack on 16/7/4.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "ThreeCell.h"
#import "Masonry.h"

#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height

@implementation ThreeCell

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        if (Kheight == 480.0) {
//            
//            [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
//        }else if (Kheight == 568.0){
//            [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//        }else{
//            [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
//        }
//    }
//    
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (Kheight == 480.0) {
        [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    }else if (Kheight == 568.0){
        [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    }else{
        [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    }
    [self.iconBTN setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
//    [self.iconBTN setBackgroundImage:[UIImage imageNamed:@"选项方块"] forState:UIControlStateNormal];
    [self.nameBTN.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.nameBTN addTarget:self action:@selector(nameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.iconBTN addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}
- (void)nameBtnClick:(UIButton *)sender {
    if (_block) {
        _block();
    }
}
- (void)click {
        switch (self.iconBTN.tag) {
            case 0:
                [self.iconBTN setTitle:nil forState:UIControlStateNormal];
                [self.iconBTN setBackgroundImage:[UIImage imageNamed:@"选择方块"] forState:UIControlStateNormal];
                //[self.iconBTN setImage:[UIImage imageNamed:@"yes@3x"] forState:UIControlStateNormal];
                
                [self.iconBTN setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
                [self.iconBTN setTag:1];
                
                //第一版本预约功能的cell icon 点击传值操作
                [[NSUserDefaults standardUserDefaults] setInteger:self.index forKey:@"tag"];
                [[NSUserDefaults standardUserDefaults] setObject:self.idStr forKey:@"roomid"];
                [[NSUserDefaults standardUserDefaults] setObject:self.nameBTN.titleLabel.text forKey:@"dressLabelText"] ;
                
                
                //第二版本（当前）cell icon 点击传值操作
                if (_block2) {
                    _block2();
                }
                
                self.iconBTN.tag = 1;
                
                break;
            case 1:
                
                //第一版设计
                [self.iconBTN setTitle:nil forState:UIControlStateNormal];
                [self.iconBTN setImage:nil forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"roomid"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dressLabelText"];
                [self.iconBTN setTag:0];
                
                //第二版设计
                [self.iconBTN setBackgroundImage:[UIImage imageNamed:@"选项方块"] forState:UIControlStateNormal];
                if (_block3) {
                    _block3();
                }
                break;
            default:
                break;
        }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

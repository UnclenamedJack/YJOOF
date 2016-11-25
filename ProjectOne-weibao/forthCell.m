//
//  forthCell.m
//  ProjectOne-weibao
//
//  Created by jack on 16/7/27.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "forthCell.h"
#import "Masonry.h"

#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height


@implementation forthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.iconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.iconBTN];
    
    self.nameBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.nameBTN];
    
    if (self) {
        if (Kheight == 480.0) {
            [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        }else if (Kheight == 568.0){
            [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        }else{
            [self.nameBTN.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        }
    }
    
    [self.iconBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        if (Kheight == 480.0) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
        }else if(Kheight == 568.0){
            make.top.equalTo(self.contentView.mas_top).offset(10);
        }else{
            make.top.equalTo(self.contentView.mas_top).offset(15);
        }
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(15);
        make.width.equalTo(self.iconBTN.mas_height);
    }];
    [self.iconBTN addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.nameBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBTN.mas_right).offset(10);
        make.centerY.equalTo(self.iconBTN.mas_centerY);
        make.right.lessThanOrEqualTo(self.mas_right).offset(8);
    }];
    
    return self;

}

-(void)click {
    switch (self.iconBTN.tag) {
        case 0:
            [self.iconBTN setTitle:nil forState:UIControlStateNormal];
            [self.iconBTN setBackgroundImage:[UIImage imageNamed:@"yixuanze@3x"] forState:UIControlStateNormal];
            //[self.iconBTN setImage:[UIImage imageNamed:@"yes@3x"] forState:UIControlStateNormal];
            
            [self.iconBTN setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
            [self.iconBTN setTag:1];
            [[NSUserDefaults standardUserDefaults] setInteger:self.index forKey:@"tag"];
            [[NSUserDefaults standardUserDefaults] setObject:self.idStr forKey:@"roomid"];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.nameBTN.titleLabel.text forKey:@"dressLabelText"] ;
            self.iconBTN.tag = 1;
            
            break;
        case 1:
            
            [self.iconBTN setTitle:nil forState:UIControlStateNormal];
            [self.iconBTN setImage:nil forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"roomid"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dressLabelText"];
            [self.iconBTN setTag:0];
            
            
            break;
        default:
            break;
    }
    
    
}

@end

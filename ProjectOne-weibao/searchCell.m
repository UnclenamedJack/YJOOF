//
//  searchCell.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/29.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "searchCell.h"
#import "Masonry.h"
#import "searchModel.h"

@implementation searchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label1 = [[UILabel alloc] init];
        [_label1 setText:@"label1"];
        [self.contentView addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.label2 = [[UILabel alloc] init];
        [_label2 setText:@"label2"];
        [self.contentView addSubview:_label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(0.75);
        }];
        
        self.label3 = [[UILabel alloc] init];
        [_label3 setText:@"label3"];
        [self.contentView addSubview:_label3];
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(1.25);
        }];
        
        self.label4 = [[UILabel alloc] init];
        [_label4 setText:@"label4"];
        [self.contentView addSubview:_label4];
        [_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView).multipliedBy(1.75);
        }];
        
    }
    return self;
}
- (void)setModel:(searchModel *)modle {
    if (_model != modle) {
        _model = modle;
        _label1.text = modle.num;
        _label2.text = modle.device;
        _label3.text = modle.college;
        _label4.text = modle.room;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

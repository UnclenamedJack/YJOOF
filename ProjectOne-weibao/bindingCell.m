//
//  bindingCell.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "bindingCell.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "binddingModel.h"
#import "Header.h"

@implementation bindingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        UILabel *label1 = [[UILabel alloc] init];
        [label1 setText:@"label1"];
        [label1 setNumberOfLines:2];
        [self.contentView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.centerY.equalTo(self.contentView);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        [label2 setText:@"label2"];
        [label2 setNumberOfLines:2];
        [self.contentView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(label1);
            make.left.equalTo(label1.mas_right).offset(10);
        }];
        
        UILabel *label3 = [[UILabel alloc] init];
        [label3 setText:@"label3"];
        [label3 setNumberOfLines:2];
        [self.contentView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(label2);
            make.left.equalTo(label2.mas_right).offset(10);
        }];
        
        UILabel *label4 = [[UILabel alloc] init];
        [label4 setText:@"label4"];
        [label4 setNumberOfLines:2];
        [self.contentView addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(label3);
            make.left.equalTo(label3.mas_right).offset(10);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"解绑" forState:UIControlStateNormal];
        [btn.layer setCornerRadius:3.0];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(label4);
            make.left.equalTo(label4.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-5);
        }];
        [btn addTarget:self action:@selector(cancelBinding:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)cancelBinding:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":_model.assetid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    [manager POST:JIECHUBANGDING parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        if ([responseObject[@"result"] intValue] == 1) {
            [hud hideAnimated:YES];
        }else{
            [hud setMode:MBProgressHUDModeCustomView];
            [hud.label setText:responseObject[@"msg"]];
            [hud hideAnimated:YES afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
#endif
        [hud setMode:MBProgressHUDModeCustomView];
        [hud.label setText:@"网络连接失败！"];
        [hud hideAnimated:YES afterDelay:1.5];
    }];

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

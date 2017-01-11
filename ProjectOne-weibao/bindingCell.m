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
#import "searchModel.h"
#import "binddingModel.h"
#import "Header.h"

@implementation bindingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        self.label1 = [[UILabel alloc] init];
        [_label1 setTextAlignment:NSTextAlignmentCenter];
//        [_label1 setText:@"label1"];
        [_label1 setNumberOfLines:2];
        [self.contentView addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.label2 = [[UILabel alloc] init];
        [_label2 setTextAlignment:NSTextAlignmentCenter];
//        [_label2 setText:@"label2"];
        [_label2 setNumberOfLines:2];
        [self.contentView addSubview:_label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(_label1);
            make.left.equalTo(_label1.mas_right).offset(10);
        }];
        
        self.label3 = [[UILabel alloc] init];
        [_label3 setTextAlignment:NSTextAlignmentCenter];
//        [_label3 setText:@"label3"];
        [_label3 setNumberOfLines:2];
        [self.contentView addSubview:_label3];
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(_label2);
            make.left.equalTo(_label2.mas_right).offset(10);
        }];
        
        self.label4 = [[UILabel alloc] init];
        [_label4 setTextAlignment:NSTextAlignmentCenter];
//        [_label4 setText:@"label4"];
        [_label4 setNumberOfLines:2];
        [self.contentView addSubview:_label4];
        [_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(_label3);
            make.left.equalTo(_label3.mas_right).offset(10);
        }];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn.layer setBorderColor:[UIColor blackColor].CGColor];
        [_btn.layer setBorderWidth:1.0];
        [_btn.layer setCornerRadius:3.0];
        [_btn setTag:0];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setTitle:@"解绑" forState:UIControlStateNormal];
        [_btn.layer setCornerRadius:3.0];
        [self.contentView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(_label4);
            make.left.equalTo(_label4.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-5);
        }];
        [_btn addTarget:self action:@selector(cancelBinding:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)cancelBinding:(UIButton *)sender {
    NSString *url;
    NSDictionary *parameters;
    if (self.hubid) {
        if (self.model) {
            parameters = @{@"hubid":self.hubid,@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else if (self.model1){
            parameters = @{@"hubid":self.hubid,@"bdmachineid":_model1.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else {
            return;
        }
        
        if (sender.tag == 0) {
            url = CHAPAICHAKONGBANDDING;
            //        parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else{
            url = JIECHUCHAPAICHAKONGBANDDING;
            //        parameters =  @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }

    }else{
        if (self.model) {
            parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else if (self.model1){
            parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdmachineid":_model1.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else {
            return;
        }
        
        if (sender.tag == 0) {
            url = JIECHUBANGDING;
            //        parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else{
            url = CHAZUOBANGDING;
            //        parameters =  @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }
        
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    NSDictionary *parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        if ([responseObject[@"result"] intValue] == 1) {
            [hud hideAnimated:YES];
            if (self.cancelBlock) {
                self.cancelBlock(sender);
            }
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

- (void)setModel:(searchModel *)modle {
    if (_model != modle) {
        _model = modle;
        _label1.text = modle.num;
        _label2.text = modle.device;
        _label3.text = modle.college;
        _label4.text = modle.room;
    }
}
- (void)setModel1:(binddingModel *)model1 {
    if (_model1 != model1) {
        _model1 = model1;
        _label1.text = model1.num;
        _label2.text = model1.device;
        _label3.text = model1.college;
        _label4.text = model1.room;
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

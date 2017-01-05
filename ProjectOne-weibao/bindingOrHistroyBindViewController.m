//
//  bindingOrHistroyBindViewController.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "bindingOrHistroyBindViewController.h"
#import "AFNetworking.h"
#import "Header.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "bindingCell.h"
#import "AttachVC.h"

@interface bindingOrHistroyBindViewController ()
@property(nonatomic,strong)UILabel *label;
@end

@implementation bindingOrHistroyBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.25);
    }];
    
    UILabel *macDress = [[UILabel alloc] init];
    if (_mac) {
        [macDress setText:_mac];
    }else{
        [macDress setText:@"MAC:5c:cf:7f:0a:11:d3:"];
    }
    [macDress setFont:[UIFont boldSystemFontOfSize:16.0]];
    [topView addSubview:macDress];
    [macDress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(topView).offset(-15);
    }];
    
    UILabel *macName = [[UILabel alloc] init];
    [macName setText:@"86型智能插座"];
    [macName setFont:[UIFont boldSystemFontOfSize:16.0]];
    [topView addSubview:macName];
    [macName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(macDress.mas_bottom).offset(8);
    }];

    self.label = [[UILabel alloc] init];
    [_label setText:@"已绑定资产"];
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view).offset(5);
    }];
    
    bindingCell *cell = [[bindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.model) {
        cell.model = self.model;
    }else if (self.model1){
        cell.model1 = self.model1;
    }
    [self.view addSubview:cell];
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
        make.height.equalTo(@40);
    }];
    
    UIButton *bindingNew = [UIButton buttonWithType:UIButtonTypeCustom];
    [bindingNew setTitle:@"绑定新资产" forState:UIControlStateNormal];
    [bindingNew setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bindingNew.layer setCornerRadius:3.0];
    [bindingNew.layer setBorderColor:[UIColor blackColor].CGColor];
    [bindingNew.layer setBorderWidth:1.0];
    [self.view addSubview:bindingNew];
    [bindingNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        make.width.equalTo(self.view).multipliedBy(0.35);
    }];
    [bindingNew setEnabled:NO];
    [bindingNew addTarget:self action:@selector(bindNewDevice:) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(bindingCell) *weakcell = cell;
    cell.cancelBlock = ^(UIButton *sender){
        if (sender.tag == 0) {
            _label.text = @"历史绑定资产";
            [bindingNew setEnabled:YES];
            [weakcell.btn setTitle:@"绑定" forState:UIControlStateNormal];
            sender.tag = 1;
        }else{
            _label.text = @"已绑定资产";
            [bindingNew setEnabled:NO];
            [weakcell.btn setTitle:@"解绑" forState:UIControlStateNormal];
            sender.tag = 0;
        }
    };
    // Do any additional setup after loading the view.
}
- (void)bindNewDevice:(UIButton *)sender {
    AttachVC *vc = [[AttachVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

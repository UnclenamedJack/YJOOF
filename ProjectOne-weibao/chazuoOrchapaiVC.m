//
//  chazuoOrchapaiVC.m
//  ProjectOne-weibao
//
//  Created by jack on 17/1/5.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "chazuoOrchapaiVC.h"
#import "Masonry.h"
#import "QRcodeViewController.h"

@interface chazuoOrchapaiVC ()

@end

@implementation chazuoOrchapaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.view setBackgroundColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];

    UIView *topview = [[UIView alloc] init];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chazuoClick:)];
    [topview addGestureRecognizer:gestureRecognizer];
    [topview setBackgroundColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:237/255.0 alpha:1.0]];
    [self.view addSubview:topview];
    [topview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(50+64);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    UILabel *topLabel = [[UILabel alloc] init];
    [topLabel setText:@"扫86插座二维码"];
    [topview addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topview);
    }];
    
    
    UIView *downView = [[UIView alloc] init];
    [downView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:229/255.0 blue:232/255.0 alpha:1.0]];
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topview);
        make.right.equalTo(topview);
        make.height.equalTo(topview);
        make.top.equalTo(topview.mas_bottom).offset(2);
    }];
    
    UILabel *downLabel = [[UILabel alloc] init];
    [downLabel setText:@"扫8孔插排二维码"];
    [downView addSubview:downLabel];
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(downView);
    }];
    
    
    UILabel *bottomL = [[UILabel alloc] init];
    [bottomL setText:@"请先扫描（插座/插排）二维码"];
    [self.view  addSubview:bottomL];
    [bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(downView.mas_bottom).offset(25);
    }];
    
    // Do any additional setup after loading the view.
}
- (void)chazuoClick:(UIButton *)sender {
    QRcodeViewController *vc = [[QRcodeViewController alloc] init];
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

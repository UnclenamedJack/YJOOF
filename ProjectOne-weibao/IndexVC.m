//
//  IndexVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "IndexVC.h"
#import "Masonry.h"
#import "saomiaoVC.h"

@interface IndexVC ()

@end

@implementation IndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    UIButton *TestingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [TestingBtn setTitle:@"调试匹配" forState:UIControlStateNormal];
    [TestingBtn setBackgroundColor:[UIColor whiteColor]];
    [TestingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:TestingBtn];
    [TestingBtn.layer  setBorderColor:[UIColor blackColor].CGColor];
    [TestingBtn.layer setBorderWidth:1.0];
    [TestingBtn.layer setCornerRadius:5.0];
    [TestingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.centerY.equalTo(self.view).offset(-40);
        make.height.equalTo(@50);
    }];
    
    
    UIButton *attachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attachBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [attachBtn setTitle:@"绑定工作" forState:UIControlStateNormal];
    [attachBtn setBackgroundColor:[UIColor whiteColor]];
    [attachBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [attachBtn.layer setBorderWidth:1.0];
    [attachBtn.layer setCornerRadius:5.0];
    [self.view addSubview:attachBtn];
    [attachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.centerY.equalTo(self.view).offset(40);
        make.height.equalTo(@50);
    }];
    [attachBtn addTarget:self action:@selector(bangding:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}
- (void)bangding:(UIButton *)sender {
    saomiaoVC *vc = [[saomiaoVC alloc] init];
    vc.identifier = @"IndexVC";
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];;
    [self presentViewController:navc animated:YES completion:nil];
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

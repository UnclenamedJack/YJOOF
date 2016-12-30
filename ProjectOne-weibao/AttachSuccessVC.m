//
//  AttachSuccessVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/27.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "AttachSuccessVC.h"
#import "Masonry.h"
@interface AttachSuccessVC ()

@end

@implementation AttachSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [view.layer setBorderWidth:1.0];
    [view.layer setCornerRadius:5.0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@120);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setText:@"绑定成功！"];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    label1.font = [UIFont boldSystemFontOfSize:16.0];
    [view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-10);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setText:@"3s后自动跳转"];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setFont:[UIFont systemFontOfSize:13.0]];
    [view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(label1);
        make.top.equalTo(label1.mas_bottom).offset(5);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    // Do any additional setup after loading the view.
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

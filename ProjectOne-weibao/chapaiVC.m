//
//  chapaiVC.m
//  ProjectOne-weibao
//
//  Created by jack on 17/1/3.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "chapaiVC.h"
#import "Masonry.h"
#import "saomiaoVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Header.h"
#import "binddingModel.h"
#import "AttachSuccessVC.h"

@interface chapaiVC ()

@end

@implementation chapaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    if (_mac1) {
        [macDress setText:_mac1];
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

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    [self.view addSubview:cell];
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
        make.height.equalTo(@40);
        make.top.equalTo(topView.mas_bottom).offset(25);
    }];
    [cell.textLabel setText:_mac2];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%zd孔智能插排",self.hubs.count]];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [cancelBtn.layer setBorderWidth:1.0];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-40);
        make.height.equalTo(@40);
    }];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bindingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bindingBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bindingBtn.layer setBorderWidth:1.0];
    [bindingBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.view addSubview:bindingBtn];
    [bindingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelBtn.mas_right).offset(25);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(cancelBtn);
        make.width.equalTo(cancelBtn);
        make.centerY.equalTo(cancelBtn);
    }];
    [bindingBtn addTarget:self action:@selector(binding:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)cancelClick:(UIButton *)sender {
    saomiaoVC *vc = [[saomiaoVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)binding:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdmachineid":self.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setRemoveFromSuperViewOnHide:YES];
    [manager POST:CHAZUOBANGDING parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        if ([responseObject[@"result"] intValue] == 1) {
            [hud hideAnimated:YES];
            AttachSuccessVC *vc = [[AttachSuccessVC alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
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

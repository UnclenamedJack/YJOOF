//
//  AttachVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "AttachVC.h"
#import "Masonry.h"
#import "ZichanVC.h"
#import "AFNetworking.h"
#import "Header.h"
#import "MBProgressHUD.h"

@interface AttachVC ()
@end

@implementation AttachVC

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
    
    
    UIButton *deviceCHAZUO = [UIButton buttonWithType:UIButtonTypeCustom];
    [deviceCHAZUO setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deviceCHAZUO.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [deviceCHAZUO setTitle:@"绑定插排" forState:UIControlStateNormal];
    [deviceCHAZUO setBackgroundColor:[UIColor clearColor]];
    [deviceCHAZUO.layer setBorderWidth:1.0];
    [deviceCHAZUO.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [deviceCHAZUO.layer setCornerRadius:5.0];
    [self.view addSubview:deviceCHAZUO];
    [deviceCHAZUO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.centerX.equalTo(self.view).multipliedBy(0.5);
        make.height.equalTo(@40);
        make.width.equalTo(@120);
    }];
    
    UIButton *deviceZICHAN = [UIButton buttonWithType:UIButtonTypeCustom];
    [deviceZICHAN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deviceZICHAN setTitle:@"绑定资产" forState:UIControlStateNormal];
    [deviceZICHAN.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [deviceZICHAN.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [deviceZICHAN.layer setBorderWidth:1.0];
    [deviceZICHAN.layer setCornerRadius:5.0];
    [self.view addSubview:deviceZICHAN];
    [deviceZICHAN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).multipliedBy(1.5);
        make.centerY.equalTo(self.view);
        make.height.equalTo(deviceCHAZUO);
        make.width.equalTo(deviceCHAZUO);
    }];
    [deviceZICHAN addTarget:self action:@selector(attachZICHAN:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/json",@"text/javascript", nil];
//    NSDictionary *parameters = @{@"mac":_mac,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [HUD setRemoveFromSuperViewOnHide:YES];
//    [manager POST:SAOMIAOCHAZUO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//#if DEBUG
//        NSLog(@"网路连接成功！");
//        NSLog(@"%@",responseObject);
//#endif
//        
//        if ([responseObject[@"result"] integerValue] == 1) {
//            [HUD hideAnimated:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"obj"][@"machineid"] forKey:@"machineid"];
//            if ([[responseObject[@"obj"] allKeys] containsObject:@"bdasset"] || [[responseObject[@"obj"] allKeys] containsObject:@"bdmachineid"]) {
//                
//            }else{
//                
//            }
//        }else{
//            [HUD setMode:MBProgressHUDModeCustomView];
//            [HUD hideAnimated:YES afterDelay:2.0];
//            [HUD.label setText:responseObject[@"msg"]];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//#if DEBUG
//        NSLog(@"网络连接失败！");
//        NSLog(@"%@",error);
//#endif
//        [HUD setMode:MBProgressHUDModeCustomView];
//        [HUD hideAnimated:YES afterDelay:2.0];
//        [HUD.label setText:@"网络连接失败！"];
//    }];
    
}
- (void)attachZICHAN:(UIButton *)sender {
    ZichanVC *vc = [[ZichanVC alloc] init];
    vc.mac = self.mac;
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

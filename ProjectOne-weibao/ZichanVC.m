//
//  ZichanVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "ZichanVC.h"
#import "Masonry.h"
#import "searchVC.h"
#import "searchCell.h"
#import "searchModel.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Header.h"
#import "AttachSuccessVC.h"

@interface ZichanVC ()<UITextFieldDelegate>
@property(nonatomic, strong)UITextField *field;
@property(nonatomic, assign)double assetid;
@property(nonatomic,strong)searchModel *model;
@end

@implementation ZichanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.25);
    }];
    
    UILabel *macDress = [[UILabel alloc] init];
    if (self.mac) {
        [macDress setText:_mac];
    }else{
        [macDress setText:@"MAC：5c:cf:7f:0a:11:d3"];
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
        make.top.equalTo(macDress.mas_bottom).offset(15);
        make.centerX.equalTo(topView);
    }];
    
    
    self.field = [[UITextField alloc] init];
    [_field setDelegate:self];
    [_field setBorderStyle:UITextBorderStyleLine];
    [_field setPlaceholder:@"请输入资产编码"];
    [_field setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Emoticon@3x"]]];
    [_field setLeftViewMode:UITextFieldViewModeAlways];
    [_field setClearButtonMode:UITextFieldViewModeUnlessEditing];
   
    [self.view addSubview:_field];
    [_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@25);
    }];
    UIButton *attach = [UIButton buttonWithType:UIButtonTypeCustom];
    [attach setBackgroundColor:[UIColor greenColor]];
    [attach setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [attach setTitle:@"绑定" forState:UIControlStateNormal];
    [attach.layer setCornerRadius:5.0];
    [attach.layer setBorderColor:[UIColor grayColor].CGColor];
    [attach.layer setBorderWidth:1.0];
    [self.view addSubview:attach];
    [attach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    [attach addTarget:self action:@selector(binding:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)binding:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"bdassetid":[NSNumber numberWithInteger:self.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:CHECKBINDING parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        if ([responseObject[@"result"] intValue] == 1) {
            [hud hideAnimated:YES];
            NSDictionary *parameters2 = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            [hud showAnimated:YES];
            [manager POST:CHAZUOBANGDING parameters:parameters2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
                NSLog(@"网路连接成功！");
                NSLog(@"%@",responseObject);
#endif
                if ([responseObject[@"result"] intValue] == 1) {
                    [hud hideAnimated:YES];
                    AttachSuccessVC *vc = [[AttachSuccessVC alloc] init];
                    vc.model = self.model;
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
                
            }];

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
        
    }];

}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    searchVC *vc = [[searchVC alloc] init];
    vc.mac = self.mac;
    vc.block = ^(NSString *str,searchModel *model){
        
        _field.text = str;
        _assetid = model.assetid;
        searchCell *cell = [[searchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [self.view addSubview:cell];
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_field.mas_bottom).offset(5);
            make.left.equalTo(self.view).offset(5);
            make.right.equalTo(self.view).offset(-5);
            make.height.equalTo(@40);
        }];
        cell.model = model;
        self.model = model;
    };
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

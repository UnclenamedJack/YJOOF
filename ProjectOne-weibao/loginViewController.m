//
//  loginViewController.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "loginViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "HomeVC.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "JPUSHService.h"
#import "UIColor+Extend.h"
#import "Header.h"
#import "IndexVC.h"





@interface loginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *PhoneTextFiled;
@property (strong, nonatomic) UITextField *PassWordTextField;
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation loginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController.navigationBar setTranslucent:NO];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    
    
    self.PhoneTextFiled.delegate = self;
    self.PassWordTextField.delegate = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *bgImagview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [bgImagview setAlpha:1.0];
    [self.view addSubview:bgImagview];
    [bgImagview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    
    UIImageView *littleImag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:littleImag];
    [littleImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset((130/667.0)*kHeight);
//        make.left.equalTo(self.view).offset(90);
//        make.right.equalTo(self.view).offset(-90);
        make.height.equalTo(@20);
        make.width.equalTo(@150);
        make.centerX.equalTo(self.view);
    }];
    
    self.PhoneTextFiled = [[UITextField alloc] init];
    [self.PhoneTextFiled setTintColor:[UIColor hexChangeFloat:@"828587"]];
    self.PhoneTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.PhoneTextFiled setBackgroundColor:[UIColor clearColor]];
    //    [self.PhoneTextFiled setPlaceholder:@"请输入手机号"];
    [self.PhoneTextFiled setBorderStyle:UITextBorderStyleNone];
    self.PhoneTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
//    [self.PhoneTextFiled.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [self.PhoneTextFiled.layer setBorderWidth:1.0];
//    [self.PhoneTextFiled.layer setCornerRadius:15.0];
    [self.PhoneTextFiled setTextColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0]];
    [self.PhoneTextFiled setFont:[UIFont systemFontOfSize:14.0]];
    [self.view addSubview:self.PhoneTextFiled];
    [self.PhoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(93*kHeight/(734*2.0));
        make.right.equalTo(self.view).offset(-93*kHeight/(734*2.0));
        make.height.equalTo(@46);
        if (kHeight == 480) {
            make.top.equalTo(self.view).offset(180);
        }else if (kHeight == 568){
            make.top.equalTo(self.view).offset(200);
        }else if (kHeight == 667){
            make.top.equalTo(self.view).offset(250);
        }else{
            make.top.equalTo(self.view).offset(280);
        }
        
    }];
    [self.view bringSubviewToFront:self.PhoneTextFiled];
    
    UIView *view1 = [[UIView alloc] init];
    [view1 setBackgroundColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0]];
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(self.PhoneTextFiled);
        make.right.equalTo(self.PhoneTextFiled);
        make.top.equalTo(self.PhoneTextFiled.mas_bottom);
    }];
    
    
    self.PassWordTextField = [[UITextField alloc] init];
    [self.PassWordTextField setTintColor:[UIColor hexChangeFloat:@"828587"]];
    [self.PassWordTextField setSecureTextEntry:YES];
    [self.PassWordTextField.leftView setBackgroundColor:[UIColor clearColor]];
    self.PassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.PassWordTextField setBackgroundColor:[UIColor clearColor]];
    [self.PassWordTextField setBorderStyle:UITextBorderStyleNone];
    [self.PassWordTextField setFont:[UIFont systemFontOfSize:14.0]];
    self.PassWordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
 //   [self.PassWordTextField setPlaceholder:@"请输入密码"];
//    [self.PassWordTextField.layer setBorderWidth:1.0];
//    [self.PassWordTextField.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [self.PassWordTextField.layer setCornerRadius:15.0];
    [self.PassWordTextField setTextColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0]];
    [self.view addSubview:self.PassWordTextField ];
    [self.PassWordTextField  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1).offset(20);
        make.left.equalTo(self.PhoneTextFiled.mas_left);
        make.right.equalTo(self.PhoneTextFiled.mas_right);
        make.height.equalTo(self.PhoneTextFiled);
    }];
    [self.view bringSubviewToFront:self.PassWordTextField ];
    
    UIView *view2 = [[UIView alloc] init];
    [view2 setBackgroundColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0]];
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PassWordTextField.mas_bottom);
        make.left.equalTo(self.PassWordTextField);
        make.right.equalTo(self.PassWordTextField);
        make.height.equalTo(@1);
    }];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [forgetBtn.titleLabel setTextColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0]];
    [forgetBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    if (kHeight == 480.0) {
        [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    }else{
        [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    }
    [self.view addSubview:forgetBtn];
        [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PassWordTextField);
        make.top.equalTo(view2.mas_bottom).offset(19.0);
        
    }];
    
    [forgetBtn addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    if (kHeight == 480.0) {
           [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    }else if (kHeight == 568.0){
           [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    }else if (kHeight == 667.0){
           [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:22.0]];
    }else {
           [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:24.0]];
    }
    [loginBtn.layer setBorderColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0].CGColor];
    [loginBtn.layer setBorderWidth:1.0];
    [loginBtn.layer setCornerRadius:20.0];
    [loginBtn setTitleColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PassWordTextField );
        make.right.equalTo(self.PassWordTextField );
        if (kHeight == 480.0) {
            make.bottom.equalTo(self.PassWordTextField ).offset((190.0/667.0)*kHeight);
        }else{
            make.bottom.equalTo(self.PassWordTextField ).offset((170.0/667.0)*kHeight);
        }
    }];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"zhanghao"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"mima"]) {
        [self fastLogin];
    }
    // Do any additional setup after loading the view.
}
-(void)forgetClick {
    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"registerNAVC"];
    [self showViewController:navc sender:nil];
}
-(void)fastLogin {
    if (!_manager) {
        self.manager = [AFHTTPSessionManager manager];
    }
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    //别忘了  把参数切回来
    NSLog(@"<><><>><<>%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    //@"3C2576E7-418A-4896-8D9E-4C465A8538C3"
    NSDictionary *parameters = @{@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:@"zhanghao"],@"pass":[[NSUserDefaults standardUserDefaults] objectForKey:@"mima"],@"uuid":[[[UIDevice currentDevice] identifierForVendor] UUIDString],@"type":@"ios"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_manager POST:LoginURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSNumber *yktid = responseObject[@"yktid"];
        if ([responseObject[@"result"] isEqualToString:@"1"]) {
//            [[NSUserDefaults standardUserDefaults] setObject:self.PhoneTextFiled.text forKey:@"zhanghao"];
//            [[NSUserDefaults standardUserDefaults] setObject:self.PassWordTextField.text forKey:@"mima"];
            if (![responseObject[@"logo"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"logo"] forKey:@"logoImage"];
            }else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logoImage"];
            }
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"yktname"] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"token"] forKey:@"accesstoken"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:yktid forKey:@"yktid"];
            int ykt = [yktid intValue];
            NSString *ykd = [NSString stringWithFormat:@"%zd",ykt];
            
            [JPUSHService setTags:[NSSet setWithObject:ykd] alias:ykd fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"注册别名=======%zd,%@,%@",iResCode,iTags,iAlias);
            }];
//            [JPUSHService setTags:nil alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//                NSLog(@"注册别名=======%zd,%@,%@",iResCode,iTags,iAlias);
//            }];
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
//            //请注意  请注意 老少爷们儿  请注意  这里用得是模态  为什么是模态呢？ 因为故事版里有多个UINavigationController ，从一个导航控制器跳转到另一个导航控制器，其实就是self.window.rootViewController 从一个UINavigationController 切换成了另外一个UINavigationController 在这样的情况下就用模态 （个人考虑）
//            [self presentViewController:navigationController animated:YES completion:nil];
            IndexVC *vc = [[IndexVC alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络连接失败！");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showOkayCancelAlert];
    }];
}
- (void)clickDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"00a0e9"]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)loginClick:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    
    if (_PhoneTextFiled.text.length < 11 && _PassWordTextField.text.length > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else if (_PassWordTextField.text.length == 0 || _PassWordTextField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"手机号或密码不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (!_manager) {
        self.manager = [AFHTTPSessionManager manager];
    }
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    //别忘了  把参数切回来  
    NSLog(@"<><><>><<>%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    //3C2576E7-418A-4896-8D9E-4C465A8538C3
    NSDictionary *parameters = @{@"phone":self.PhoneTextFiled.text,@"pass":self.PassWordTextField.text,@"uuid":[[[UIDevice currentDevice] identifierForVendor] UUIDString],@"type":@"ios"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_manager POST:LoginURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSNumber *yktid = responseObject[@"yktid"];
        if ([responseObject[@"result"] isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.PhoneTextFiled.text forKey:@"zhanghao"];
            [[NSUserDefaults standardUserDefaults] setObject:self.PassWordTextField.text forKey:@"mima"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"yktname"] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"token"] forKey:@"accesstoken"];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:yktid forKey:@"yktid"];
            if (![responseObject[@"logo"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"logo"] forKey:@"logoImage"];
            }else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logoImage"];
            }
            
             int ykt = [yktid intValue];
            NSString *ykd = [NSString stringWithFormat:@"%zd",ykt];
            
            [JPUSHService setTags:[NSSet setWithObject:ykd] alias:ykd fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"注册别名=======%zd,%@,%@",iResCode,iTags,iAlias);
            }];
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
//            
//            //请注意  请注意 老少爷们儿  请注意  这里用得是模态  为什么是模态呢？ 因为故事版里有多个UINavigationController ，从一个导航控制器跳转到另一个导航控制器，其实就是self.window.rootViewController 从一个UINavigationController 切换成了另外一个UINavigationController 在这样的情况下就用模态 （个人考虑）
//            [self presentViewController:navigationController animated:YES completion:nil];
            IndexVC *vc = [[IndexVC alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络连接失败！");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showOkayCancelAlert];
    }];
}
//解析失败之后的提示框
- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"抱歉", nil);
    NSString *message = NSLocalizedString(@"您的网络不是很好,检查一下吧,亲", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.PhoneTextFiled setText:nil];
    [self.PassWordTextField setText:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.PhoneTextFiled resignFirstResponder];
    [self.PassWordTextField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.PhoneTextFiled resignFirstResponder];
    [self.PassWordTextField resignFirstResponder];
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

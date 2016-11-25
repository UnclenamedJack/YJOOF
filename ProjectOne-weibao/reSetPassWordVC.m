//
//  reSetPassWordVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/7/13.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "reSetPassWordVC.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "UIColor+Extend.h"
#import "MBProgressHUD.h"



#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define CHANGEPASSURL1   @"http://192.168.5.10:8080/wuxin/api/changepass?"
#define CHANGEPASSURL   @"http://www.yjoof.com/ygapi/changepass?"



@interface reSetPassWordVC ()
@property (nonatomic,strong) UITextField *phone;
@property (nonatomic,strong) UITextField *oldPass;
@property (nonatomic,strong) UITextField *newpass;
@end

@implementation reSetPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    self.phone = [[UITextField alloc] init];
    [self.phone setTintColor:[UIColor hexChangeFloat:@"828587"]];
    [_phone setBackgroundColor:[UIColor clearColor]];
    [_phone setTextColor:[UIColor hexChangeFloat:@"828587"]];
    [_phone setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"828587"]}]];
    [backgroundView addSubview:self.phone];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(218*kHeight/(2*736.0));
        make.left.equalTo(backgroundView).offset(32*kWidth/414.0);
        make.right.equalTo(backgroundView).offset(-32*kWidth/414.0);
    }];
    
    
    UIView *view1 = [[UIView alloc] init];
    [view1 setBackgroundColor:[UIColor hexChangeFloat:@"293035"]];
    [backgroundView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phone);
        make.right.equalTo(self.phone);
        make.top.equalTo(self.phone.mas_bottom).offset(18*kHeight/736.0);
        make.height.equalTo(@1);
    }];
    
    
    
    self.oldPass = [[UITextField alloc] init];
    [self.oldPass setTintColor:[UIColor hexChangeFloat:@"828587"]];
    [_oldPass setSecureTextEntry:YES];
    [_oldPass setTextColor:[UIColor hexChangeFloat:@"828587"]];
    [_oldPass setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_oldPass setTextColor:[UIColor whiteColor]];
    [_oldPass setBackgroundColor:[UIColor clearColor]];
    [_oldPass setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"原密码" attributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"828587"]}]];
    [backgroundView addSubview:self.oldPass];
    [_oldPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom).offset(47*kHeight/736.0);
        make.left.equalTo(view1);
        make.right.equalTo(view1);
    }];
    
    
    UIView *view2 = [[UIView alloc] init];
    [view2 setBackgroundColor:[UIColor hexChangeFloat:@"293035"]];
    [backgroundView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldPass.mas_bottom).offset(18*kHeight/736.0);
        make.left.equalTo(self.oldPass);
        make.right.equalTo(self.oldPass);
        make.height.equalTo(@1);
    }];
    
    self.newpass = [[UITextField alloc] init];
    [_newpass setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_newpass setSecureTextEntry:YES];
    [_newpass setTextColor:[UIColor whiteColor]];
    [_newpass setBackgroundColor:[UIColor clearColor]];
    [_newpass setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"新密码" attributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"828587"]}]];
    [backgroundView addSubview:_newpass];
    [_newpass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom).offset(47*kHeight/736.0);
        make.left.equalTo(view2);
        make.right.equalTo(view2);
    }];
    
    
    UIView *view3 = [[UIView alloc] init];
    [view3 setBackgroundColor:[UIColor hexChangeFloat:@"293035"]];
    [backgroundView addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newpass.mas_bottom).offset(18*kHeight/736.0);
        make.left.equalTo(self.newpass);
        make.right.equalTo(self.newpass);
        make.height.equalTo(@1);
    }];

    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundColor:[UIColor clearColor]];
    [saveBtn.layer setBorderWidth:1.0];
    [saveBtn.layer setBorderColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0].CGColor];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor hexChangeFloat:@"1375cf"] forState:UIControlStateNormal];
    [saveBtn.layer setCornerRadius:15.0];
    [backgroundView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(32*kWidth/414.0);
        make.right.equalTo(backgroundView).offset(-32*kWidth/414.0);
        make.bottom.equalTo(backgroundView).offset(-393*kHeight/(2*736.0));
    }];
    [saveBtn addTarget:self action:@selector(saveAndBackToLogin) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)saveAndBackToLogin {
    if (self.phone.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else if (self.oldPass.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入原始密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else if (self.newpass.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入新密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([self.oldPass.text isEqualToString:self.newpass.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"新设密码不能和原密码相同！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"phone":_phone.text,@"oldpass":_oldPass.text,@"newpass":_newpass.text};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:CHANGEPASSURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger result =  [responseObject[@"result"] integerValue];
        if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES completion:nil];
            
        }
        if (result ==1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
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

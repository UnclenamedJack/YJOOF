//
//  RegisterVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/27.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "RegisterVC.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "Masonry.h"
#import "UIColor+Extend.h"
#import "MBProgressHUD.h"


#define YANURL1 @"http://192.168.5.10:8080/wuxin/ygapi/getcode?"
#define RESETURL1 @"http://192.168.5.10:8080/wuxin/ygapi/changepass?"
#define MESSAGE1 @"http://192.168.5.10:8080/wuxin/ygapi/sendmsg?"
#define FORGETPASSWORD1 @"http://192.168.5.10:8080/wuxin/ygapi/wjmm?"

#define YANURL @"http://www.yjoof.com/ygapi/getcode?"
#define RESETURL @"http://www.yjoof.com/ygapi/changepass?"
#define MESSAGE @"http://www.yjoof.com/ygapi/sendmsg?"
#define FORGETPASSWORD @"http://www.yjoof.com/ygapi/wjmm?"

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width
@interface RegisterVC ()<UITextFieldDelegate>
@property(strong,nonatomic) UITextField *phone;
@property(strong,nonatomic) UITextField *yanzhengma;
@property(strong,nonatomic) UITextField *repassWord;
@property(nonatomic,strong) NSString *yanzheng;
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backHome)];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setAlpha:0.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [backgroundView setUserInteractionEnabled:YES];
    [backgroundView setAlpha:1.0];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(self.view);
        make.width.equalTo(self.view);
        
//        make.top.equalTo(self.view).offset(-64);
//        make.bottom.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
    }];
    self.phone = [[UITextField alloc] init];
    [self.phone setTintColor:[UIColor hexChangeFloat:@"828587"]];
    [backgroundView addSubview:self.phone];
    [self.phone setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"828587"]}]];
    [self.phone setTextColor:[UIColor hexChangeFloat:@"828587"]];
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
    
    
    UIButton *getYZMBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getYZMBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    if (kHeight == 480.0) {
        [getYZMBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    }else if (kHeight == 568.0){
        [getYZMBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    }else if (kHeight == 667.0){
        [getYZMBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    }else{
        [getYZMBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    }
    
    [getYZMBtn setTitleColor:[UIColor hexChangeFloat:@"1375cf"] forState:UIControlStateNormal];
    [getYZMBtn.layer setBorderWidth:1.0];
    [getYZMBtn.layer setBorderColor:[UIColor hexChangeFloat:@"1375cf"].CGColor];
    if (kHeight == 568.0 || kHeight == 480.0) {
        [getYZMBtn.layer setCornerRadius:15.0];
    }else if (kHeight == 667.0){
        [getYZMBtn.layer setCornerRadius:16.0];
    }else{
        [getYZMBtn.layer setCornerRadius:18.0];
    }
    
    [backgroundView addSubview:getYZMBtn];
    [getYZMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(204*kHeight/(2*736.0));
        make.width.equalTo(@(162*kWidth/414.0));
        make.right.equalTo(backgroundView).offset(-32*kWidth/414.0);
    }];
    [getYZMBtn addTarget:self action:@selector(yanzhengmaClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.yanzhengma = [[UITextField alloc] init];
    [self.yanzhengma setTintColor:[UIColor hexChangeFloat:@"828587"]];
    [self.yanzhengma setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"828587"]}]];
    [self.yanzhengma setTextColor:[UIColor hexChangeFloat:@"828587"]];
    [backgroundView addSubview:self.yanzhengma];
    [self.yanzhengma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom).offset(47*kHeight/736.0);
        make.left.equalTo(view1);
        make.right.equalTo(view1);
    }];
    
    UIView *view2 = [[UIView alloc] init];
    [view2 setBackgroundColor:[UIColor hexChangeFloat:@"293035"]];
    [backgroundView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yanzhengma.mas_bottom).offset(18*kHeight/736.0);
        make.left.equalTo(self.yanzhengma);
        make.right.equalTo(self.yanzhengma);
        make.height.equalTo(@1);
    }];
    
    self.repassWord = [[UITextField alloc] init];
    [self.repassWord setTintColor:[UIColor hexChangeFloat:@"828587"]];
    [self.repassWord setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"重设密码" attributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"828587"]}]];
    [self.repassWord setTextColor:[UIColor hexChangeFloat:@"828587"]];
    [self.repassWord setBackgroundColor:[UIColor clearColor]];
    [backgroundView addSubview:self.repassWord];
    [self.repassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom).offset(47*kHeight/736.0);
        make.left.equalTo(view2);
        make.right.equalTo(view2);
    }];
    UIView *view3 = [[UIView alloc] init];
    [view3 setBackgroundColor:[UIColor hexChangeFloat:@"293035"]];
    [backgroundView addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.repassWord.mas_bottom).offset(18*kHeight/736.0);
        make.left.equalTo(self.repassWord);
        make.right.equalTo(self.repassWord);
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
    [saveBtn addTarget:self action:@selector(saveAndBackToLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.phone.delegate = self;
    self.repassWord.delegate = self;
    self.yanzhengma.delegate = self;
    self.manager = [AFHTTPSessionManager manager];
    // Do any additional setup after loading the view.
}
- (void)backHome {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//获取验证码（问题：网络请求的参数 type的类型？）
- (void)GETYanZhengMa:(NSString *)urlStr {
    
    NSDictionary *parameters = @{@"phone":self.phone.text,@"type":@"abc"};
    if (self.phone.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return ;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [_manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"网络请求成功！");
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        
    
        if ([responseObject[@"result"] isEqualToString:@"1"]) {
            self.yanzheng = responseObject[@"captcha"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                [NSThread sleepForTimeInterval:1.0f];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败！");
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败！" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
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
- (void)yanzhengmaClick:(id)sender {
    [self GETYanZhengMa:YANURL];
}
- (void)saveAndBackToLogin:(id)sender {
    if ([_yanzhengma.text isEqualToString:_yanzheng]) {
        [self reSetPassWord:_repassWord.text];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您输入的验证码不正确，请重新输入！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)reSetPassWord:(NSString *)passWord {
    
    NSDictionary *parameters =@{@"phone":_phone.text,@"password":passWord};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_manager POST:FORGETPASSWORD parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"网络连接成功！");
        if ([responseObject[@"result"] isEqualToString:@"1"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改失败！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络连接失败！");
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络请求失败！" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
        [self showOkayCancelAlert];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.phone resignFirstResponder];
    [self.repassWord resignFirstResponder];
    [self.yanzhengma resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phone resignFirstResponder];
    [self.repassWord resignFirstResponder];
    [self.yanzhengma resignFirstResponder];
    
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

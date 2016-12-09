//
//  ClassRoomVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/6/18.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "ClassRoomVC.h"
#import "UIColor+Extend.h"
#import "Masonry.h"
#import "Header.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"




@interface ClassRoomVC ()

@end

@implementation ClassRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"教室详情"];
    [self.navigationItem.leftBarButtonItem setTitle:nil];
    
    [self.view setBackgroundColor:[UIColor hexChangeFloat:@"f0f0f0"]];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"next" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [bgView.layer setBorderWidth:1.0];
    [bgView.layer setCornerRadius:10];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(self.view).multipliedBy(0.3);
    }];
    
    UILabel *locationL = [[UILabel alloc] init];
    [locationL setFont:[UIFont systemFontOfSize:13.0]];
    [locationL setTextAlignment:NSTextAlignmentCenter];
    [locationL setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    [locationL setText:@"地点:"];
    [bgView addSubview:locationL];
    [locationL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(20*ScreenHeight/736.0);
        make.left.equalTo(bgView).offset(24*ScreenWidth/414.0);
        
    }];
    
    UILabel *detailLocationL = [[UILabel alloc] init];
    [detailLocationL setFont:[UIFont systemFontOfSize:13.0]];
    [detailLocationL setText:@"青山湾校区创业路逸夫楼B栋302A"];
    [detailLocationL setText:self.roomDress];
    [detailLocationL setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    [detailLocationL setNumberOfLines:0];
    [detailLocationL setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:detailLocationL];
    [detailLocationL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationL.mas_right).offset(5);
        make.top.equalTo(locationL);
        make.height.equalTo(locationL);
        make.right.lessThanOrEqualTo(bgView);
    }];
    
    UILabel *contain = [[UILabel alloc] init];
    [contain setFont:[UIFont systemFontOfSize:13.0]];
    [contain setTextAlignment:NSTextAlignmentCenter];
    [contain setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    [contain setText:@"容纳:"];
    [bgView addSubview:contain];
    [contain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationL);
        make.right.equalTo(locationL);
        make.top.equalTo(locationL.mas_bottom).offset(5);
        
    }];
    
    UILabel *peopleNum = [[UILabel alloc] init];
    [peopleNum setFont:[UIFont systemFontOfSize:13.0]];
    [peopleNum setTextAlignment:NSTextAlignmentCenter];
    [peopleNum setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    [peopleNum setText:@"20人"];
    [peopleNum setText:[NSString stringWithFormat:@"%@人",self.capacity]];
    
    [bgView addSubview:peopleNum];
    [peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contain.mas_right).offset(5);
        make.top.equalTo(contain);
        make.height.equalTo(contain);
        make.right.lessThanOrEqualTo(bgView);
    }];
    
    UILabel *devcie = [[UILabel alloc] init];
    [devcie setFont:[UIFont systemFontOfSize:13.0]];
    [devcie setText:@"设备:"];
    [devcie setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    [devcie setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:devcie];
    [devcie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contain);
        make.right.equalTo(contain);
        make.top.equalTo(contain.mas_bottom).offset(5);
        make.height.equalTo(contain);
    }];
    
    UILabel *computer = [[UILabel alloc] init];
    [computer setFont:[UIFont systemFontOfSize:13.0]];
    [computer setTextAlignment:NSTextAlignmentCenter];
    [computer setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
//    [computer setText:@"苹果电脑 (编码XKAI1236586M)"];
    if (_assets.count >= 1) {
        [computer setText:[NSString stringWithFormat:@"%@(编码%@)",_assets[0][@"name"],_assets[0][@"num"]]];
    }else{
        [computer setText:@"该项暂无设备"];
    }
    
    [bgView addSubview:computer];
    [computer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(devcie);
        make.left.equalTo(devcie.mas_right).offset(5);
        make.right.lessThanOrEqualTo(bgView);
        make.height.equalTo(devcie);
    }];
    
    UILabel *touyingyi = [[UILabel alloc] init];
    [touyingyi setFont:[UIFont systemFontOfSize:13.0]];
//    [touyingyi setText:@"投影仪 (编码MKI58H)"];
    if (_assets.count >= 2) {
        [touyingyi setText:[NSString stringWithFormat:@"%@(编码%@)",_assets[1][@"name"],_assets[1][@"num"]]];
    }else{
        [touyingyi setText:@"该项暂无设备"];
    }
    
    [touyingyi setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    [touyingyi setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:touyingyi];
    [touyingyi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(computer);
        make.top.equalTo(computer.mas_bottom).offset(5);
        make.height.equalTo(computer);
    }];
    
    UILabel *speakDevice = [[UILabel alloc] init];
    [speakDevice setFont:[UIFont systemFontOfSize:13.0]];
//    [speakDevice setText:@"话筒 (编码NH1236987)"];
    if (_assets.count >= 3) {
        [speakDevice setText:[NSString stringWithFormat:@"%@(编码%@)",_assets[2][@"name"],_assets[2][@"num"]]];
    }else{
        [speakDevice setText:@"该项暂无设备"];
    }
    [speakDevice setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    [speakDevice setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:speakDevice];
    [speakDevice  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(touyingyi.mas_bottom).offset(5);
        make.left.equalTo(touyingyi);
        make.right.lessThanOrEqualTo(bgView);
        make.height.equalTo(touyingyi);
    }];
    // Do any additional setup after loading the view from its nib.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"next"] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"距离您使用结束还有三分钟，暂无下一个使用者，您是否延时？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"不延时" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"延时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"请输入延时时长" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert1 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField = [[UITextField alloc] init];
                [textField setBackgroundColor:[UIColor blackColor]];
                [textField setTextColor:[UIColor redColor]];
                [textField.layer setBorderWidth:1.0];
                [textField.layer setBorderColor:[UIColor redColor].CGColor];
            }];
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"延时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *delayTime = alert1.textFields[0].text;
                int delay = [delayTime intValue];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *parameters = @{@"bespeakid":[[NSUserDefaults standardUserDefaults] objectForKey:@"bookid"],@"extend":@(delay)};
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [manager POST:UPLOADDELAYTIME parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"延时连接成功！");
                    NSLog(@"%@",responseObject);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if ([responseObject[@"result"] intValue] == 0) {
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [alertVC addAction:actionA];
                        [self presentViewController:alertVC animated:YES completion:^{
                            [alert1 dismissViewControllerAnimated:YES completion:^{
                            }];
                        }];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setInteger:[responseObject[@"extendtime"] integerValue] forKey:@"endTime"];
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"延时成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                        [alertVC addAction:actionA];
                        [self presentViewController:alertVC animated:YES completion:^{
                            [alert1 dismissViewControllerAnimated:YES completion:^{
                            }];
                        }];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"延时连接失败！");
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:^{
                    }];
                }];
            }];
            [alert1 addAction:action3];
            [self presentViewController:alert1 animated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"next"] == 1){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"距离您使用结束还有三分钟，有下一个使用者，请您尽快关闭设备并提交反馈报告！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"next"] == 2){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"距离您预约时段开始还有三分钟！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"next"];
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

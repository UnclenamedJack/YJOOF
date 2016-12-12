//
//  ThirdVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/10/18.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "ThirdVC.h"
#import "Masonry.h"
#import "UIColor+Extend.h"
#import "Header.h"
#import "InformationVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"



@interface ThirdVC ()
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)NSDate *beginDate;
@property(nonatomic,strong)NSDate *beginDate2;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)int i;
@end

@implementation ThirdVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"next" options:NSKeyValueObservingOptionNew context:nil];
    [self startTimer];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black-BG"]];
    [self.view addSubview:bgImgView];
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
        
    }];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time"]];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        //make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.width.equalTo(@(204*ScreenWidth/320.0));
        make.height.equalTo(@(204*ScreenWidth/320.0));
        make.top.equalTo(self.view).offset(313*ScreenHeight/(568*4.0));
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.layer setBorderWidth:1.0];
    [btn.layer setBorderColor:[UIColor colorWithRed:0/255.0 green:172/255.0 blue:246/255.0 alpha:1.0].CGColor];
    [btn.layer setCornerRadius:18 *ScreenHeight/568.0];
    [btn setTitle:@"结束" forState:UIControlStateNormal];
    if (ScreenHeight==568) {
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];

    }else if (ScreenHeight == 667){
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];

    }else{
        [btn.titleLabel setFont:[UIFont systemFontOfSize:22]];

    }
    
    [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:172/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(changeColorForHighlight:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(changeColorAfterHighLight:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(143*ScreenHeight/(4*568.0)));
        make.bottom.equalTo(self.view.mas_bottom).offset(-309*ScreenHeight/(568*4.0));
        make.left.equalTo(self.view).offset(190*ScreenWidth/(320*4.0));
        make.right.equalTo(self.view).offset(-190*ScreenWidth/(320*4.0));
    }];
    
    UILabel *beginTimeLable = [[UILabel alloc] init];
    [beginTimeLable setNumberOfLines:2];
    [beginTimeLable setTextAlignment:NSTextAlignmentCenter];
    [beginTimeLable setText:@"开始时间\nStartTime"];
    [beginTimeLable setTextColor:[UIColor hexChangeFloat:@"a0a0a0"]];
    [imgView addSubview:beginTimeLable];
    [beginTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgView);
        make.centerY.equalTo(imgView.mas_centerY);
        
    }];
    
    
    _timeLabel = [[UILabel alloc] init];
    [_timeLabel setTextColor:[UIColor hexChangeFloat:@"a0a0a0"]];
    [_timeLabel setText:[self getCurrentTime]];
    [imgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgView);
        make.top.equalTo(beginTimeLable.mas_bottom).offset(10*ScreenHeight/568.0);
    }];
    // Do any additional setup after loading the view.                                                    
}
- (void)changeColorForHighlight:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor colorWithRed:23/255.0 green:70/255.0 blue:88/255.0 alpha:1.0]];
}
- (void)changeColorAfterHighLight:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json", nil]];
    NSDictionary *parameters = @{@"usageid":[[NSUserDefaults standardUserDefaults] objectForKey:@"usagesid"]};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:TIMEREND parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InformationVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"informationVC"];
        if ([responseObject[@"result"] isEqualToString:@"-1"]) {
            
            vc.beginTime = [self.timeLabel.text substringToIndex:5];
            vc.endTime = [[self getCurrentTime] substringToIndex:5];
            vc.totalTime = [self totalTime];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关机提示" message:@"友情提醒：您先关闭使用设备，再进入反馈意见！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"未关闭" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"已关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                vc.beginTime = [self.timeLabel.text substringToIndex:5];
                vc.endTime = [[self getCurrentTime] substringToIndex:5];
                vc.totalTime = [self totalTime];
                [self presentViewController:vc animated:YES completion:nil];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [hud setMode:MBProgressHUDModeCustomView];
        [hud.label setText:@"网络连接失败"];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:2.0];
    }];
    
    
}
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [NSDate date];
    self.beginDate = date;
    return [formatter stringFromDate:date];
}
- (NSString *)totalTime {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"HH:mm:ss"];
//    NSDate *endDate = [NSDate date];
//    NSTimeInterval value = [endDate timeIntervalSinceDate:self.beginDate];
//    return [NSString stringWithFormat:@"%zd",value];
    [self.timer invalidate];
    if (_i<60) {
        return [NSString stringWithFormat:@"%zd秒",_i];;
    }else{
        int a = _i%60;
        long b = _i/60;
        return [NSString stringWithFormat:@"%zd分钟%zd秒",b,a];
    }
}

- (void)startTimer {
    if (self.timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    }
    [_timer fire];
    
}
- (void)changeTime {
    _i = _i+1;
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

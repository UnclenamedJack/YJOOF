//
//  TimerVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "TimerVC.h"
#import "InformationVC.h"
#import "TBCycleView.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIColor+Extend.h"


#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width

#define UPLOADDELAYTIME1 @"http://192.168.5.10:8080/wuxin/ygapi/updatebespeak?"
#define UPLOADDELAYTIME @"http://www.yjoof.com/ygapi/updatebespeak?"


@interface TimerVC ()
@property (strong, nonatomic)  UILabel *timeLabel;
@property(nonatomic,assign)NSInteger i;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSTimer *secondTimer;
@property (strong,nonatomic) UILabel *finalTimeLabel;
//@property (strong,nonatomic) UILabel *beginTimeLabel;
@property(nonatomic,assign) BOOL haveNext;//是否有下一个使用者排队
@property (strong, nonatomic) TBCycleView *cycleView;
@property (strong,nonatomic) UIImageView *maskView;
@property(nonatomic,assign) NSTimeInterval time;
@property(nonatomic,strong) NSDate *goBackgroundDate;
@property(nonatomic,assign) NSTimeInterval totalTime;
@end

@implementation TimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.haveNext = NO;
    [self buildColorChangeImage];
    [self createTimeLabel];
    [self addObserver];
    //获取计时开始时间 beginTimeLabel
    //self.beginTimeLabel.text = [self getCurrentTime];
    _i = 0;
    //开始计时
    [self startTimer];
    [self StartFinalTime];
    
    // Do any additional setup after loading the view.
}
- (void)createTimeLabel {
    self.timeLabel = [[UILabel alloc] init];
    [self.view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (kHeight == 480.0) {
            make.centerY.equalTo(self.view.mas_top).offset(347/2.0);

        }else if (kHeight == 568.0) {
            make.centerY.equalTo(self.view.mas_top).offset(430/2.0);
        }else if (kHeight == 667.0) {
            make.centerY.equalTo(self.view.mas_top).offset(466/2.0);
        }else{
            make.centerY.equalTo(self.view.mas_top).offset(788/3.0);
        }
        make.height.equalTo(@60);
        //make.width.equalTo(@(180*kHeight/667.0));
    }];
    [self.timeLabel setText:@"05:32"];
    [self.timeLabel setBackgroundColor:[UIColor clearColor]];
    [self.timeLabel setTextColor:[UIColor whiteColor]];
    [self.timeLabel setFont:[UIFont systemFontOfSize:64.0]];
    //[timeLabel setFont:[UIFont fontWithName:@"Helvetica" size:66.0]];
    [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view bringSubviewToFront:self.timeLabel];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    [self.view addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.timeLabel);
    }];
    [statusLabel setText:@"已使用"];
    [statusLabel setTextColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0]];
    
    
    UILabel *Mlabel = [[UILabel alloc] init];
    [self.view addSubview:Mlabel];
    [Mlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel.mas_centerX).offset(-15);
        make.top.equalTo(self.timeLabel.mas_bottom);
    }];
    [Mlabel setText:@"minutes"];
    [Mlabel setTextColor:[UIColor grayColor]];
    [Mlabel setFont:[UIFont systemFontOfSize:15.0]];
    
    UILabel *Slabel = [[UILabel alloc] init];
    [self.view addSubview:Slabel];
    [Slabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_centerX).offset(18);
        make.top.equalTo(self.timeLabel.mas_bottom);
    }];
    [Slabel setText:@"second"];
    [Slabel setTextColor:[UIColor grayColor]];
    [Slabel setFont:[UIFont systemFontOfSize:15.0]];
    
    UILabel *begLabel = [[UILabel alloc] init];
    [self.view addSubview:begLabel];
    [begLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeLabel);
        if (kHeight == 480.0) {
            //radius = 214.0/2.0;
             make.top.equalTo(self.timeLabel.mas_bottom).offset(214/4.0);
        }else if (kHeight == 568.0) {
            //radius = 214.0/2.0;
             make.top.equalTo(self.timeLabel.mas_bottom).offset(214/4.0);
        }else if (kHeight == 667.0) {
            //radius = 254/2.0;
             make.top.equalTo(self.timeLabel.mas_bottom).offset(254.0/4.0);
        }else{
            //radius = 429/3.0;
             make.top.equalTo(self.timeLabel.mas_bottom).offset(429.0/6.0);
        }
       
    }];
    [begLabel setTextColor:[UIColor grayColor]];
    [begLabel setText:[NSString stringWithFormat:@"开始时间%@",[self getCurrentTime]]];
    
    
    self.finalTimeLabel = [[UILabel alloc] init];
    [self.view addSubview:self.finalTimeLabel];
    [self.finalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(begLabel.mas_bottom).offset(15);
        make.centerX.equalTo(begLabel);
    }];
    
    
    
    //请注意！
    //[self.finalTimeLabel setText:[NSString stringWithFormat:@"距离上课/预约结束还剩%@",[self getCurrentTime]]];
    [self.finalTimeLabel setTextColor:[UIColor grayColor]];
    [self.finalTimeLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.finalTimeLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:endBtn];
    [endBtn setTitle:@"结束" forState:UIControlStateNormal];
    [endBtn.titleLabel setFont:[UIFont systemFontOfSize:24.0]];
    [endBtn.layer setBorderColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0].CGColor];
    [endBtn.layer setBorderWidth:1.0];
    [endBtn.layer setCornerRadius:20];
    [endBtn setTitleColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [endBtn setBackgroundColor:[UIColor clearColor]];
    
    [endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.bottom.equalTo(self.view).offset(-50);
        make.height.equalTo(@40);
    }];
    
    [endBtn addTarget:self action:@selector(timerOver) forControlEvents:UIControlEventTouchUpInside];
}
//-(NSString *)caculatorRemainingTime {
//
//    NSLog(@"????????????????????????????????????%zd",_i);
//   // NSInteger minate = ([[NSUserDefaults standardUserDefaults] integerForKey:@"AllTime"]/1000 - self.i)/60;
//    
//    
//    //NSInteger second = (([[NSUserDefaults standardUserDefaults] integerForKey:@"AllTime"] - self.i)/1000)%60;
//    
//    NSDate *date = [NSDate date];
//    NSTimeInterval timeInterval = [date timeIntervalSince1970];
//    NSLog(@"%zd",timeInterval);
//    NSLog(@"<><><<><><<><><><%zd",[[NSUserDefaults standardUserDefaults] integerForKey:@"endTime"]);
//    NSInteger Minate = ([[NSUserDefaults standardUserDefaults] integerForKey:@"endTime"]/1000 - timeInterval )/60;
//    self.finalTimeLabel.text = [NSString stringWithFormat:@"距离上课/预约结束还剩%zd分钟",Minate];
//    return [NSString stringWithFormat:@"距离上课/预约结束还剩%zd分钟",Minate];
//}
- (void)caculatorRemainingTime {
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSInteger Minate = ([[NSUserDefaults standardUserDefaults] integerForKey:@"endTime"]/1000 - timeInterval )/60 + 1;
    self.finalTimeLabel.text = [NSString stringWithFormat:@"距离上课/预约结束还剩%zd分钟",Minate];
}
- (NSString *)getCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
- (void)startTimer {
    if (self.timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    }
    [_timer fire];
    
}
- (void)changeTime {
    
    _i = _i+1;
    if (_i<10) {
        self.timeLabel.text = [NSString stringWithFormat:@"00:0%zd",_i];
    }else if (_i>9 && _i<60){
        self.timeLabel.text = [NSString stringWithFormat:@"00:%zd",_i];
    }else if (_i>59 && _i<60*10){
        int a = _i%60;
        long b = _i/60;
        if (a<10) {
            self.timeLabel.text = [NSString stringWithFormat:@"0%zd:0%zd",b,a];
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"0%zd:%zd",b,a];
        }
    }else{
        long a = _i/60;
        int b = _i%60;
        if (b<10) {
            self.timeLabel.text = [NSString stringWithFormat:@"%zd:0%zd",a,b];
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"%zd:%zd",a,b];
        }
    }
}
- (void)timerOver {
    if (!self.timer) {
        return;
    }
    if ([self.finalTimeLabel.text isEqualToString:@"0"]) {
        [self.timer invalidate];
        [self.secondTimer invalidate];
        //结束前将计时时长本地化到plist文件中
        [self saveTotalTime];
        NSLog(@"<><><>%@",[self getCurrentTime]);
        [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentTime] forKey:@"endtime"];
        UIViewController *vc  =[self.storyboard instantiateViewControllerWithIdentifier:@"informationVC"];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关机提示" message:@"友情提醒：您先关闭使用设备，再进入反馈意见！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"未关闭" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"已关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.timer invalidate];
            [self.secondTimer invalidate];
            //结束前将计时时长本地化到Plist文件中
            [self saveTotalTime];
            NSLog(@"<><><>%@",[self getCurrentTime]);
            [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentTime] forKey:@"endtime"];
            UIViewController *vc  =[self.storyboard instantiateViewControllerWithIdentifier:@"informationVC"];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    //_finalTimeLabel.text = [NSString stringWithFormat:@"%zd",self.i];
   }
- (void)saveTotalTime {
    [[NSUserDefaults standardUserDefaults] setValue:self.timeLabel.text forKey:@"totalTime"];
}
#pragma mark finalTimeLabel
- (void)StartFinalTime {
    _secondTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(caculatorRemainingTime) userInfo:nil repeats:YES];
    [_secondTimer fire];
}
- (void)elseTime {
    NSString *endDate =[self getCurrentTime];
    self.finalTimeLabel.text = endDate;
    
}
- (BOOL)getCurrentTimeInterval {
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    if((timeInterval - [[NSUserDefaults standardUserDefaults] integerForKey:@"endTime"]/1000) == 0){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark JudgeMent
- (void)addObserver {
    [self.finalTimeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.timeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"next" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([object isEqual:self.timeLabel]) {
        
        if ([self getCurrentTimeInterval]) {
            
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您预约的时段已经结束，请尽快提交使用报告并关闭设备！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIViewController *vc  =[self.storyboard instantiateViewControllerWithIdentifier:@"informationVC"];
                    [self saveTotalTime];
                    NSLog(@"<><><>%@",[self getCurrentTime]);
                    [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentTime] forKey:@"endtime"];
                    [_secondTimer invalidate];
                    [_timer invalidate];

                    [self presentViewController:vc animated:YES completion:nil];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:^{
                    
                    [NSThread sleepForTimeInterval:2.0];
                    [alert dismissViewControllerAnimated:YES completion:^{
                        UIViewController *vc  =[self.storyboard instantiateViewControllerWithIdentifier:@"informationVC"];
                        [self saveTotalTime];
                        NSLog(@"<><><>%@",[self getCurrentTime]);
                        [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentTime] forKey:@"endtime"];
                        [_secondTimer invalidate];
                        [_timer invalidate];
                        [self presentViewController:vc animated:YES completion:nil];

                    }];
                   
                }];
                return;
            }else {
                
//                
//                [self saveTotalTime];
//                NSLog(@"<><><>%@",[self getCurrentTime]);
//                [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentTime] forKey:@"endtime"];
//                [_secondTimer invalidate];
//                [_timer invalidate];
                //这里有一个遗留问题  就是有没有下一个使用者的情况  但是又考虑到 这时时间已经用完 剩余时间为0，所以我觉得这一块可以不用考虑下一个时段有没有使用者的情况！
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //本地推送
                    UILocalNotification*notification = [[UILocalNotification alloc]init];
                    NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:0];
                    if (notification) {
                        notification.fireDate = pushDate;
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.repeatInterval = kCFCalendarUnitDay;
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        
                        notification.alertBody = @"您预约的时段已经结束，请尽快提交使用报告并关闭设备！";
                        notification.alertAction = @"确定";
                        
                        notification.applicationIconBadgeNumber = 0;
                        NSDictionary*info = [NSDictionary dictionaryWithObject:@"test" forKey:@"name"];
                        notification.userInfo = info;
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    }
                });

            }
            return;
            
        }else {
        
            [self.cycleView setBackgroundColor:[UIColor redColor]];
            //NSInteger PastTime = [self.timeLabel.text integerValue];
            //注意1000和1000.0的区别
            //CGFloat progress = self.i/([[NSUserDefaults standardUserDefaults] integerForKey:@"AllTime"]/1000.0);
            CGFloat progress = self.i/(self.totalTime);

            [self.cycleView drawProgress:progress];
            
            //[self.finalTimeLabel setText:[self caculatorRemainingTime]];
           
            
        }
        
    }
    else if ([object isEqual:self.finalTimeLabel]){
        //[self judgeNotice];
    }else if ([object isEqual:[NSUserDefaults standardUserDefaults]]){
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
                        if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
                            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES completion:nil];
                        }
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
                            [_finalTimeLabel removeObserver:self forKeyPath:@"text"];
                            [self reloadTotalTimeAfterDelay];
                            [self caculatorRemainingTime];
                            [_finalTimeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
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
        }else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"next"] == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"距离您预约时段开始还有三分钟！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
    
    
}
- (void)judgeNotice {
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if ([self.finalTimeLabel.text isEqualToString:@"距离上课/预约结束还剩3分钟"]) {
            
            if (self.haveNext) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"距离您上课/预约使用结束时间还有3分钟，现有下一个使用者排队，请尽快结束：填写使用反馈并提交，关闭设备！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"距离您上课/预约使用结束时间还有3分钟，暂无下一个使用排队者，是否延时？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
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
                       // __weak TimerVC *weakSelf = self;
                        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSString *delayTime = alert1.textFields[0].text;
                            int delay = [delayTime intValue];
                            
                            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                            NSDictionary *parameters = @{@"bespeakid":[[NSUserDefaults standardUserDefaults] objectForKey:@"bookid"],@"extend":@(delay)};
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [manager POST:UPLOADDELAYTIME parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                NSLog(@"网络请求成功！");
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
                                    [_finalTimeLabel removeObserver:self forKeyPath:@"text"];
                                    [self reloadTotalTimeAfterDelay];
                                    [self caculatorRemainingTime];
                                    [_finalTimeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
                                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"延时成功" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                                    [alertVC addAction:actionA];
                                    [self presentViewController:alertVC animated:YES completion:^{
                                        [alert1 dismissViewControllerAnimated:YES completion:^{
                                            
                                        }];
                                    }];
  
                                }
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                NSLog(@"网络连接失败！");
                                [self showOkayCancelAlert];
                            }];

                        }];
                        [alert1 addAction:action3];
                        [self presentViewController:alert1 animated:YES completion:nil];
                    
                    
                }];
                //选择延时的时候需要上传申请延时的时长，更新后台预约时间表，所以客户端这里需要上传信息的API
                //并且选择延时的时候，需要执行相应地方法 例如delayTime 
                [alert addAction:action1];
                [alert addAction:action2];
                
                [self presentViewController:alert animated:YES completion:nil];
                }
        }
    }else{
        if ([self.finalTimeLabel.text isEqualToString:@"距离上课/预约结束还剩3分钟"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //本地推送
                UILocalNotification*notification = [[UILocalNotification alloc]init];
                NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:0];
                if (notification != nil) {
                    notification.fireDate = pushDate;
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    notification.repeatInterval = kCFCalendarUnitDay;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    if (self.haveNext) {
                        notification.alertBody = @"距离您上课/预约使用结束时间还有3分钟，现有下一个使用者排队，请尽快结束：填写使用反馈并提交，关闭设备！";
                        notification.alertAction = @"确定";
                    }else{
                        notification.alertBody = @"距离您上课/预约使用结束时间还有3分钟，暂无下一个使用排队者，是否延时？";
                        notification.alertAction = @"确定";
                        notification.alertAction = @"取消";
                    }
                    
                    notification.applicationIconBadgeNumber = 0;
                    NSDictionary*info = [NSDictionary dictionaryWithObject:@"test" forKey:@"name"];
                    notification.userInfo = info;
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                }
            });
        }
    }
}

//-(UIView *)DefineAlertView {
//    
//    UIView *view = [[UIView alloc] init];
//
//    UIImageView *presentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invoice"]];
//    [view addSubview:presentView];
//    [view bringSubviewToFront:presentView];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(view);
//        make.height.equalTo(view);
//        make.width.equalTo(view);
//    }];
//
//    UILabel *titleL = [[UILabel alloc] init];
//    [titleL setText:@"您的预约"];
//    [titleL setFont:[UIFont systemFontOfSize:20.0]];
//    [presentView addSubview:titleL];
//    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(presentView).offset(62*kHeight/736.0);
//        make.left.equalTo(presentView).offset(50*kWidth/414.0);
//
//    }];
//    UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rectangle-"]];
//    [presentView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.top.equalTo(presentView).offset(100*kHeight/736.0);
//        make.left.equalTo(presentView).offset(30*kWidth/414.0);
//        make.width.equalTo(@1);
//        //make.height.equalTo(@(90*kHeight/736.0));
//    }];
//
//
//    UILabel *dateL = [[UILabel alloc] init];
//    [dateL setText:@"2016年05月24日 星期二 13:00"];
//    [dateL setFont:[UIFont systemFontOfSize:15.0]];
//    [dateL setTextAlignment:NSTextAlignmentLeft];
//    [presentView addSubview:dateL];
//    [dateL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(titleL.mas_bottom).offset(20);
//        make.left.equalTo(titleL);
//        make.right.lessThanOrEqualTo(presentView);
//    }];
//
//
//    UIImageView *sanjiaoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle-"]];
//    [presentView addSubview:sanjiaoView];
//    [sanjiaoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(dateL);
//        make.left.equalTo(lineView.mas_right);
//        make.width.equalTo(@4);
//        make.height.equalTo(@5);
//        make.top.equalTo(lineView);
//    }];
//
//
//    UILabel *room = [[UILabel alloc] init];
//    [room setTextAlignment:NSTextAlignmentLeft];
//    [room setText:@"信息学院A102"];
//    [presentView addSubview:room];
//    [room mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(dateL);
//        make.top.equalTo(dateL.mas_bottom).offset(16.0);
//    }];
//
//
//    UIImageView *sanjiaoView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle-"]];
//    [presentView addSubview:sanjiaoView2];
//    [sanjiaoView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(sanjiaoView);
//        make.centerY.equalTo(room);
//        make.height.equalTo(sanjiaoView);
//        make.width.equalTo(sanjiaoView);
//    }];
//
//
//
//    UILabel *bookTotaLTime = [[UILabel alloc] init];
//    [bookTotaLTime setTextAlignment:NSTextAlignmentLeft];
//    [bookTotaLTime setText:@"预约设备使用，13：00~14：00"];
//    [bookTotaLTime setTextColor:[UIColor hexChangeFloat:@"167dfb"]];
//    [presentView addSubview:bookTotaLTime];
//    [bookTotaLTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(room);
//        make.top.equalTo(room.mas_bottom).offset(16.0);
//        make.right.lessThanOrEqualTo(presentView);
//
//    }];
//
//
//    UIImageView *sanjiaoView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle-"]];
//    [presentView addSubview:sanjiaoView3];
//    [sanjiaoView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(sanjiaoView);
//        make.centerY.equalTo(bookTotaLTime);
//        make.height.equalTo(sanjiaoView);
//        make.width.equalTo(sanjiaoView);
//        make.bottom.equalTo(lineView);
//    }];
//    
//    return view;
//
//}
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
#pragma marks DrawProgressLayer
- (void)buildColorChangeImage {
    UIImageView *littleImg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    [littleImg setImage:[UIImage imageNamed:@"home_gb@2x"]];
    [self.view addSubview:littleImg];
    TBCycleView *cview = [[TBCycleView alloc] init];
    self.cycleView = cview;
    [self.cycleView setBackgroundColor:[UIColor clearColor]];
    
    [littleImg addSubview:self.cycleView];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(littleImg.mas_centerX);
        if (kHeight == 480.0) {
            make.top.equalTo(littleImg).offset(347/2.0);
        }else if (kHeight == 568.0) {
            make.top.equalTo(littleImg).offset(430/2.0);
        }else if (kHeight == 667.0) {
            make.top.equalTo(littleImg).offset(466/2.0);
        }else{
            make.top.equalTo(littleImg).offset(788/3.0);
        }
        //make.top.equalTo(littleImg).offset(152);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    UIImageView *imgview2 = [[UIImageView alloc] initWithFrame:self.view.bounds];
    if (kHeight == 480.0) {
        [imgview2 setImage:[UIImage imageNamed:@"4s"]];
        
    }else if (kHeight == 568.0) {
        [imgview2 setImage:[UIImage imageNamed:@"5s"]];
        
    }else if (kHeight == 667.0) {
        [imgview2 setImage:[UIImage imageNamed:@"6s"]];
        
    }else{
        [imgview2 setImage:[UIImage imageNamed:@"6p"]];
        
    }
    [imgview2 setAlpha:1.0];
    [self.view addSubview:imgview2];


}
- (NSTimeInterval)fingureOutTotalTime {
//    NSDate *date = [NSDate date];
//    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    NSTimeInterval totalTimeInterval = [[NSUserDefaults standardUserDefaults] integerForKey:@"endTime"]/1000 - [[NSUserDefaults standardUserDefaults] integerForKey:@"start"];
    NSLog(@"()()()((()(()()(()()()()(()%f",totalTimeInterval);
    return totalTimeInterval;
}
- (void)reloadTotalTimeAfterDelay {
    self.totalTime = [self fingureOutTotalTime];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setInteger:timeInterval forKey:@"start"];
    [self reloadTotalTimeAfterDelay];
    
}
//-(void)viewWillAppear:(BOOL)animated{
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appGoBackgroud) name:@"程序进入后台" object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appGoForegroud) name:@"程序进入前台" object:nil];
//    
//}
//- (void)appGoBackgroud{
//    
//    self.goBackgroundDate = [NSDate date];
//    
//}
//
//- (void)appGoForegroud{
//    
//    NSTimeInterval timeGone = [[NSDate date] timeIntervalSinceDate:_goBackgroundDate];
//    NSLog(@"<><><<><><<><<><>><><><<><<><><><>%zd",_i);
//    self.i = timeGone + _i;
//    
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
    [_finalTimeLabel removeObserver:self forKeyPath:@"text"];
    [_timeLabel removeObserver:self forKeyPath:@"text"];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"next"];
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

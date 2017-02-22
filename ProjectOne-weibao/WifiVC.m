//
//  WifiVC.m
//  ProjectOne-weibao
//
//  Created by jack on 17/2/8.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "WifiVC.h"
#import "UIColor+Extend.h"
#import "Masonry.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESPTouchDelegate.h"
#import "MBProgressHUD.h"
#import "Header.h"

#define HEIGHT_KEYBOARD 216
#define HEIGHT_TEXT_FIELD 30
#define HEIGHT_SPACE (6+HEIGHT_TEXT_FIELD)

@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>

@end

@implementation EspTouchDelegateImpl

-(void) dismissAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
}

-(void) showAlertWithResult: (ESPTouchResult *) result
{
    NSString *title = nil;
    NSString *message = [NSString stringWithFormat:@"%@ is connected to the wifi" , result.bssid];
    NSTimeInterval dismissSeconds = 3.5;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:dismissSeconds];
}

-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithResult:result];
    });
}

@end

@interface WifiVC ()<UITextFieldDelegate>
@property(nonatomic,strong) ESPTouchTask *esptouchTask;
@property(nonatomic,assign) BOOL isConfirmState;
@property(nonatomic,strong) NSCondition *condition;
@property(nonatomic,strong) EspTouchDelegateImpl *esptouchDelegte;
@property(nonatomic,strong) UITextField *field1;
@property(nonatomic,strong) UITextField *field2;
@property(nonatomic,strong) UIButton *btn;
@end

@implementation WifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连接";
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_big"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    [self.navigationController.navigationBar setTintColor:[UIColor hexChangeFloat:@"ffffff"]];
    [self.view setBackgroundColor:[UIColor hexChangeFloat:@"ffffff"]];
    
    UIImageView *wifiImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wi-fi"]];
    [self.view addSubview:wifiImageView];
    [wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(82*ScreenHeight/(2.0*568.0) );
        make.left.equalTo(self.view).offset(230*ScreenWidth/(2.0*320));
        make.right.equalTo(self.view).offset(-230*ScreenWidth/(2.0*320));
        make.width.equalTo(wifiImageView.mas_height);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setText:@"接通电源，红灯长亮，确认插座处于待连接状态"];
    [label1 setFont:[UIFont systemFontOfSize:12.0]];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(wifiImageView.mas_bottom).offset(38*ScreenHeight/(2.0*568.0));
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setText:@"等待连接状态，蓝灯快速闪烁"];
    [label2 setFont:[UIFont systemFontOfSize:12.0]];
    [label2 setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
    self.field1 = [[UITextField alloc] init];
    [_field1 setEnabled:NO];
    [_field1 setPlaceholder:@"YJOOF"];
    [_field1 setBorderStyle:UITextBorderStyleRoundedRect];
//    _field1.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
//    UIButton *rightviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightviewBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    field1.rightView = rightviewBtn;
    [_field1 setRightViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:_field1];
    [_field1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(100*ScreenHeight/(2.0*568.0));
        make.left.equalTo(self.view).offset(95*ScreenWidth/(2.0*320.0));
        make.right.equalTo(self.view).offset(-95*ScreenWidth/(2.0*320.0));
        make.height.equalTo(@(45*ScreenHeight/(2.0*568.0)));
    }];
    
    self.field2 = [[UITextField alloc] init];
    [_field2 setSecureTextEntry:YES];
    [_field2 setClearButtonMode:UITextFieldViewModeAlways];
    [_field2 setPlaceholder:@"请输入WIFI密码"];
    [_field2 setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_field2];
    [_field2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_field1.mas_bottom).offset(25*ScreenHeight/(2.0*568.0));
        make.left.equalTo(_field1);
        make.right.equalTo(_field1);
        make.height.equalTo(_field1);
    }];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"连接" forState:UIControlStateNormal];
    [_btn setBackgroundColor:[UIColor hexChangeFloat:@"0a88e7"]];
    [_btn.layer setCornerRadius:5.0];
    [self.view addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(67*ScreenWidth/(2.0*320.0));
        make.right.equalTo(self.view).offset(-67*ScreenWidth/(2.0*320.0));
        make.bottom.equalTo(self.view).offset(-207*ScreenHeight/(2.0*568.0));
    }];
    [_btn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    self.isConfirmState = NO;
    self.field2.delegate = self;
    self.field2.keyboardType = UIKeyboardTypeASCIICapable;
    self.condition = [[NSCondition alloc] init];
    self.esptouchDelegte = [[EspTouchDelegateImpl alloc] init];
    [self enableConfirmBtn];
    self.ssid = [[NSUserDefaults standardUserDefaults] objectForKey:@"ssid"];
    self.bssid = [[NSUserDefaults standardUserDefaults] objectForKey:@"bssid"];
    self.field1.text = self.ssid;
    // Do any additional setup after loading the view.
}
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)confirm:(UIButton *)sender {
    if (self.field2.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self tapConfirmForResults];
    }
}
- (void)tapConfirmForResults {
    if (self.isConfirmState) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud.label setText:@"正在连接"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"ESPViewController do the execute work...");
            //execute the task
            NSArray *esptouchResultArray = [self executeForResults];
            // show the result to the user in UI Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                [self enableConfirmBtn];
                ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
                //check whether the task is canceled and no results received
                if (!firstResult.isCancelled) {
                    NSMutableString *mutableStr = [[NSMutableString alloc] init];
                    NSUInteger count = 0;
                    // max results to be displayed, if it is more than maxDisplayCount,
                    // just show the count of redundant ones
                    const int maxDisplayCount = 5;
                    if ([firstResult isSuc])
                    {
                        
                        for (int i = 0; i < [esptouchResultArray count]; ++i)
                        {
                            ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                            [mutableStr appendString:[resultInArray description]];
                            [mutableStr appendString:@"\n"];
                            count++;
                            if (count >= maxDisplayCount)
                            {
                                break;
                            }
                        }
                        
                        if (count < [esptouchResultArray count])
                        {
                            [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                        }
                        [[[UIAlertView alloc]initWithTitle:@"连接结果" message:mutableStr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil]show];
                    }
                    else
                    {
                            [[[UIAlertView alloc]initWithTitle:@"连接结果" message:@"连接失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil]show];
                        
                        }
                    }
                });
            });
    }
    // do cancel
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self enableConfirmBtn];
        NSLog(@"ESPViewController do cancel action...");
        [self cancel];
    }
}
- (void)tapConfirmForResult {
    // do confirm
    if (self.isConfirmState)
    {
         MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud.label setText:@"正在连接"];
//        [self._spinner startAnimating];
        [self enableCancelBtn];
        NSLog(@"ESPViewController do confirm action...");
        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"ESPViewController do the execute work...");
            // execute the task
            ESPTouchResult *esptouchResult = [self executeForResult];
            // show the result to the user in UI Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [hud removeFromSuperViewOnHide];
//                [self._spinner stopAnimating];
                [self enableConfirmBtn];
                // when canceled by user, don't show the alert view again
                if (!esptouchResult.isCancelled)
                {
                    [[[UIAlertView alloc] initWithTitle:@"连接结果" message:[esptouchResult description] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
                }
            });
        });
    }
    // do cancel
    else
    {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self._spinner stopAnimating];
        [self enableConfirmBtn];
        NSLog(@"ESPViewController do cancel action...");
        [self cancel];
    }

}
- (ESPTouchResult *)executeForResult {
    [self.condition lock];
    NSString *apSsid = self.field1.text;
    NSString *apPwd = self.field2.text;
    NSString *apBssid = self.bssid;
//    BOOL isSsidHidden = [self._isSsidHiddenSwitch isOn];
    self.esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:NO];
    // set delegate
    [self.esptouchTask setEsptouchDelegate:self.esptouchDelegte];
    [self.condition unlock];
    ESPTouchResult * esptouchResult = [self.esptouchTask executeForResult];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResult);
    return esptouchResult;
}
- (NSArray *)executeForResults {
    [self.condition lock];
    NSString *apSsid = self.field1.text;
    NSString *apPwd = self.field2.text;
    NSString *apBssid = self.bssid;

    self.esptouchTask = [[ESPTouchTask alloc] initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:NO];
    // set delegate
    [self.esptouchTask setEsptouchDelegate:self.esptouchDelegte];
    [self.condition unlock];
    NSArray *esptouchResults = [self.esptouchTask executeForResults:1];
    NSLog(@"ESPViewController executeForResutl() result is:%@",esptouchResults);
    return esptouchResults;
}
- (void)enableConfirmBtn {
    self.isConfirmState = YES;
    [self.btn setTitle:@"确认" forState:UIControlStateNormal];
}
- (void)enableCancelBtn {
    self.isConfirmState = NO;
    [self.btn setTitle:@"取消" forState:UIControlStateNormal];
}
- (void)cancel {
    [self.condition lock];
    if (!self.esptouchTask ) {
        [self.esptouchTask interrupt];
    }
    [self.condition unlock];
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

 //
//  AppDelegate.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/24.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "KeyboardManager.h"
#import "JPUSHService.h"
#import "AFNetworking.h"
#import "BGTask.h"
#import "BGLogation.h"
#import "MBProgressHUD.h"
#import "NAVC.h"
#import "IndexVC.h"
#import "WifiVC.h"
#import "ESP_NetUtil.h"
#import "SystemConfiguration/CaptiveNetwork.h"

#define APP_KEY @"9ff9365f9af539abe9c68b41"
#define Version_IOS9 ([[UIDevice currentDevice].systemVersion doubleValue]>= 9.0)

#define UPLOADDELAYTIME1 @"http://192.168.5.10:8080/wuxin/ygapi/updateBespeak?"
#define UPLOADDELAYTIME @"http://www.yjoof.com/ygapi/updateBespeak?"

#define TEST1 @"http://192.168.5.10:8080/wuxin/ygapi/phoneclient?"
#define TEST @"http://www.yjoof.com/ygapi/phoneclient?"

@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate>

@property(assign,nonatomic) UIBackgroundTaskIdentifier bgtask;
@property(strong,nonatomic) BGTask *task;
@property(strong,nonatomic) BGLogation *bgLocation;
@property(nonatomic,strong) CLLocationManager *location;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = [[IndexVC alloc] init];
//    [self.window makeKeyAndVisible];

    
       //定位服务（目的是保证APP后台运行不被kill掉！）
    
//    _task = [BGTask shareBGTask];
//    UIAlertView *alert;
//    //判断定位权限
//    if([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusDenied)
//    {
//        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"应用不可以没有定位，需要在在设置/通用/后台应用刷新开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else if ([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusRestricted)
//    {
//        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不可以定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else
//    {
//        self.bgLocation = [[BGLogation alloc]init];
//        [self.bgLocation startLocation];
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(log) userInfo:nil repeats:YES];
//    }
    

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
            [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                              UIRemoteNotificationTypeSound |
                                                              UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:APP_KEY channel:nil apsForProduction:NO // 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
            advertisingIdentifier:nil];// 广告 不用设置为nil
    
    if (launchOptions) {
        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification) {
            NSLog(@"收到的推送消息是===== %@",remoteNotification);
            [self gotoHomeViewControllerWithRemoteNotification:remoteNotification];
        }
    }
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    return YES;
}
- (void)log{
    NSLog(@"执行");
}
- (void)startBgTask{
    [_task beginNewBackgroundTask];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"？？？？？？？？？？？？？%@",deviceToken);
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
////        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
//        
//    }];
//    [alert addAction:action];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
//
//    [vc presentViewController:alert animated:YES completion:nil];
    
    
    
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:notification.alertBody
                                                           delegate:self
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil];
            [alert show];
    
    
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"<><><><><>推送消息%@",userInfo);
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        //[[NSUserDefaults standardUserDefaults] setObject:@"active" forKey:@"notice"];
        [self devideState:userInfo];
    }
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        //[[NSUserDefaults standardUserDefaults] setObject:@"inactie" forKey:@"notice"];
        [self devideState:userInfo];
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        //[[NSUserDefaults standardUserDefaults] setObject:@"background" forKey:@"notice"];
        [self devideState:userInfo];
    }
}
- (void)devideState:(NSDictionary *)dict {
//*****  candelay == 0 代表可以延时 candelay == 1 代表不能延时
    if ([dict[@"type"] intValue]== 2 && [dict[@"candelay"] intValue] == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"next"];
        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bespeakid"] forKey:@"bookid"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                        message:@"距离您预约时段结束还有三分钟，暂无下一个使用者，是否延时？"
//                                                       delegate:self
//                                              cancelButtonTitle:@"不延时"
//                                              otherButtonTitles:@"延时",nil];
//        [alert show];
        
    }else if ([dict[@"type"] intValue] == 2 && [dict[@"candelay"] intValue] == 1){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"next"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                        message:@"距离您预约时段结束还有三分钟，有下一个使用者，请尽快关机并提交反馈报告！"
//                                                       delegate:self
//                                              cancelButtonTitle:@"好的"
//                                              otherButtonTitles:nil];
//        [alert show];
    }else if([dict[@"type"] intValue] == 1){
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"next"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                        message:@"距离您预约时段开始还有三分钟！"
//                                                       delegate:self
//                                              cancelButtonTitle:@"好的"
//                                              otherButtonTitles:nil];
//        [alert show];
    }

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"程序进入后台" object:nil];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier BGTask;
    BGTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (BGTask != UIBackgroundTaskInvalid)
            {
                BGTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (BGTask != UIBackgroundTaskInvalid)
            {
                BGTask = UIBackgroundTaskInvalid;
            }
        });
    });

    
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"App is active");
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"程序进入前台" object:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;//取消应用程序通知图标标记

    [JPUSHService resetBadge];
    
    NSDictionary *netInfo = [self fetchNetInfo];
    [[NSUserDefaults standardUserDefaults] setObject:[netInfo objectForKey:@"SSID"] forKey:@"ssid"];
    [[NSUserDefaults standardUserDefaults] setObject:[netInfo objectForKey:@"BSSID"] forKey:@"bssid"];

//    vc.ssid = [netInfo objectForKey:@"SSID"];
//    vc.bssid = [netInfo objectForKey:@"BSSID"];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}
- (void)gotoHomeViewControllerWithRemoteNotification:(NSDictionary *)notication {
    //将字段存入本地，因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面，
       //NSString * targetStr = [notication objectForKey:@"target"];
    //if ([targetStr isEqualToString:@"notice"]) {
    if ([notication[@"type"] intValue] == 2 && [notication[@"candelay"] intValue] == 0) {
        NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:notication[@"bespeakid"] forKey:@"bookid"];
        [pushJudge setObject:@"candelay0"forKey:@"push"];
        [pushJudge synchronize];
        NAVC *VC = [[NAVC alloc] init];
        //UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
        [self.window.rootViewController presentViewController:VC animated:YES completion:nil];

    }else if ([notication[@"type"] intValue] == 2 && [notication[@"candelay"] intValue] == 1){
//        NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//        [pushJudge setObject:@"candelay1"forKey:@"push"];
//        [pushJudge synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:notication[@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([notication[@"type"] intValue] == 1){
//        NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//        [pushJudge setObject:@"type1"forKey:@"push"];
//        [pushJudge synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:notication[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:notication[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }
}
- (NSString *)fetchSsid
{
    NSDictionary *ssidInfo = [self fetchNetInfo];
    
    return [ssidInfo objectForKey:@"SSID"];
}

- (NSString *)fetchBssid
{
    NSDictionary *bssidInfo = [self fetchNetInfo];
    
    return [bssidInfo objectForKey:@"BSSID"];
}

// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

@end

//
//  HomeVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//


#import "HomeVC.h"
#import "Masonry.h"
#import "UIColor+Extend.h"
#import "QRcodeViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
//#import <CoreLocation/CoreLocation.h>
//#import <MapKit/MapKit.h>
#import "MengTextField.h" //自定义输入框（光标后移了一段距离）
#import "MyBookRecordsVC.h"
#import "secondBookVC.h"
#import "ThirdVC.h"
#import "Header.h"

#define READURL1 @"http://192.168.5.10:8080/wuxin/ygapi/saveusages?"

#define READURL @"http://www.yjoof.com/ygapi/saveusages?"

#define UPLOADDELAYTIME1 @"http://192.168.5.10:8080/wuxin/ygapi/updatebespeak?"

#define UPLOADDELAYTIME @"http://www.yjoof.com/ygapi/updatebespeak?"

#define SAVELOGO @"http://www.yjoof.com/ygapi/savelogo?"

#define UPLOADIMAGE  @"http://www.yjoof.com/api/uploadImages"

#define CHECKBOOK @"http://www.yjoof.com/ygapi/checkBespeak?"

#define DOWNLOADAIMAGE  @"http://www.yjoof.com/"

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width

@interface HomeVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UILabel *TeacherName;
@property (strong, nonatomic) UITextField *deviceNumber;
@property (strong, nonatomic) UIButton *begin;
@property (strong, nonatomic) UIButton *book;
@property (strong, nonatomic) UIButton *iconButton;
@property (strong, nonatomic) UIButton *saomiao;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UILabel *littleLabel;//读秒显示
@property (nonatomic) NSInteger a;//读秒时长
//@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) UIWindow *alertWindow;
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) NSMutableArray *btnArr;
@property (nonatomic,copy) NSString *beginTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *seletedTime;
@property (nonatomic,strong) UILabel *timeL1;
@property (nonatomic,strong) UILabel *timeL2;
@property (nonatomic,strong) UILabel *timeRight1;
@property (nonatomic,strong) UITextField *timeInput;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setAlpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"我的预约" style:UIBarButtonItemStylePlain target:self action:@selector(MyBookRecords)]];
    if (kHeight==568 || kHeight == 480) {
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} forState:UIControlStateNormal];
        
    }else if (kHeight == 667){
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} forState:UIControlStateNormal];
        
    }else{
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} forState:UIControlStateNormal];
        
    }
    
    //self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
    //self.navigationItem.title = @"主页";
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, kWidth, 20)];
//    [statusView setBackgroundColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar addSubview:statusView];
    
    self.btnArr = [NSMutableArray arrayWithCapacity:4];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"next" options:NSKeyValueObservingOptionNew context:nil];
    UIImageView *backImagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [backImagView setUserInteractionEnabled:YES];
    [self.view addSubview:backImagView];
    [backImagView setAlpha:1.0];
    [backImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
//    self.iconButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang"]];
//    [self.iconButton setBackgroundColor:[UIColor blueColor]];
//    [self.iconButton setUserInteractionEnabled:YES];
//    [backImagView addSubview:_iconButton];
//    [_iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(backImagView).offset(93*kHeight/(2*736.0));
//        make.left.equalTo(backImagView).offset(300*kWidth/(2*414.0));
//        make.right.equalTo(backImagView).offset(-300*kWidth/(2*414.0));
//        make.width.equalTo(_iconButton.mas_height);
//
//    }];
//    [_iconButton.layer setCornerRadius:self.iconButton.bounds.size.width];
//    UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconButtonClick)];
//    [_iconButton addGestureRecognizer:recongnizer];
    
    
    
    
    
    self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.iconButton setContentMode:UIViewContentModeScaleAspectFill];
    NSString *iconAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"logoImage"];
    if ( iconAddress && [[[NSUserDefaults standardUserDefaults] objectForKey:@"uploadicon"] isEqual:iconAddress]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"icon"]) {
            UIImage *image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"icon"]];
            [self.iconButton setImage:image forState:UIControlStateNormal];
            
        }else{
            [self.iconButton setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
        }
    }else if (!iconAddress){
        [self.iconButton setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    }else if (iconAddress && ![[NSUserDefaults standardUserDefaults] objectForKey:@"uploadicon"]){
        [self.iconButton setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
        [self downLoadIcon];
        
    }else if (iconAddress && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"uploadicon"] isEqual:iconAddress]){
        [self.iconButton setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
        [self downLoadIcon];
    }
    [backImagView addSubview:self.iconButton];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImagView).offset(93*kHeight/(2*736.0));
        make.left.equalTo(backImagView).offset(300*kWidth/(2*414.0));
        make.right.equalTo(backImagView).offset(-300*kWidth/(2*414.0));
        make.width.equalTo(self.iconButton.mas_height);
    }];
    if (iconAddress && [[[NSUserDefaults standardUserDefaults] objectForKey:@"uploadicon"] isEqual:iconAddress] &&[[NSUserDefaults standardUserDefaults] objectForKey:@"icon"]) {
        [self.iconButton setNeedsLayout];
        [self.iconButton layoutIfNeeded];
        [self.iconButton.imageView.layer setCornerRadius:self.iconButton.bounds.size.width/2.0];
    }
    [self.iconButton addTarget:self action:@selector(iconButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.TeacherName = [[UILabel alloc] init];
    //[self.TeacherName setText:@"周虾米"];
    [self.TeacherName setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [self.TeacherName setTextColor:[UIColor colorWithRed:192/255.0 green:195/255.0 blue:195/255.0 alpha:1.0]];
    [self.TeacherName setTextAlignment:NSTextAlignmentCenter];
    [self.TeacherName setFont:[UIFont systemFontOfSize:17.0]];
    [backImagView addSubview:self.TeacherName];
    [self.TeacherName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconButton);
        make.top.equalTo(_iconButton.mas_bottom).offset(20);
    }];
    
    
//    self.deviceNumber = [[UITextField alloc] init];
    self.deviceNumber = [[MengTextField alloc] init];
    [self.deviceNumber setTextAlignment:NSTextAlignmentLeft];
    [self.deviceNumber setTintColor:[UIColor grayColor]];
    [self.deviceNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.deviceNumber setBorderStyle:UITextBorderStyleNone];
    [self.deviceNumber.layer setCornerRadius:2.0];
    [self.deviceNumber.layer setBorderWidth:1.0];
    [self.deviceNumber.layer setBorderColor:[UIColor hexChangeFloat:@"828587"].CGColor];
    
    if (kHeight == 480.0) {
        self.deviceNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请扫描二维码或手动输入设备编码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]
                                                                                                                              ,NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    }else if (kHeight == 568.0){
        self.deviceNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请扫描二维码或手动输入设备编码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]
                                                                                                                              ,NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    }else{
        self.deviceNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请扫描二维码或手动输入设备编码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]
                                                                                                                              ,NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    }
    [self.deviceNumber setTextColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0]];
    [self.deviceNumber setBackgroundColor:[UIColor clearColor]];
    [backImagView addSubview:self.deviceNumber];
    [self.deviceNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TeacherName.mas_bottom).offset(60*kHeight/736.0);
        make.left.equalTo(self.view).offset(45*kWidth/414.0);
        make.right.equalTo(self.view).offset(-45*kWidth/414.0);
        make.height.equalTo(@(51*kHeight/736.0));
    }];
    [self.view bringSubviewToFront:self.deviceNumber];
     
    self.saomiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saomiao setBackgroundImage:[UIImage imageNamed:@"二维码图标"] forState:UIControlStateNormal];
    [self.view addSubview:self.saomiao];
    [self.saomiao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImagView).offset(-49*kWidth/414.0);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
        make.centerY.equalTo(self.deviceNumber);
        make.top.equalTo(self.deviceNumber).offset(4);
        make.bottom.equalTo(self.deviceNumber).offset(-4);
        make.width.equalTo(_saomiao.mas_height);
    }];
    [self.view bringSubviewToFront:self.saomiao];
    [self.saomiao addTarget:self action:@selector(saoMiaoClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel *descLabel = [[UILabel alloc] init];
    [backImagView addSubview:descLabel];
//    [descLabel setText:@"直接输入设备编码或扫描二维码使用设备"];
    [descLabel setText:nil];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [descLabel setTextColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0]];
    [descLabel setFont:[UIFont systemFontOfSize:16.0]];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.deviceNumber);
        make.top.equalTo(self.deviceNumber.mas_bottom).offset(10);
        make.height.equalTo(@25);
    }];

    self.begin = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.begin.layer setBorderColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0].CGColor];
    [self.begin.layer setBorderWidth:1.0];
    [self.begin setTitle:@"开始" forState:UIControlStateNormal];
    [self.begin setTitleColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.begin setBackgroundColor:[UIColor clearColor]];
    [backImagView addSubview:_begin];
    [self.begin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImagView).offset(45*kWidth/414.0);
        make.right.equalTo(backImagView).offset(-45*kWidth/414.0);
        make.bottom.greaterThanOrEqualTo(backImagView).offset(-45);
    }];
    [self.begin addTarget:self action:@selector(beginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.begin addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    
    
    self.book = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.book.layer setBorderColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0].CGColor];
    [self.book.layer setBorderWidth:1.0];
    [self.book.layer setCornerRadius:16.0];
    [self.book setTitleColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.book setTitle:@"预约" forState:UIControlStateNormal];
    [self.book setBackgroundColor:[UIColor clearColor]];
    [backImagView addSubview:self.book];
    [self.book mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImagView).offset(45*kWidth/414.0);
        make.right.equalTo(backImagView).offset(-45*kWidth/414.0);
        //make.top.equalTo(descLabel.mas_bottom).offset(60*kHeight/736.0);
        make.bottom.greaterThanOrEqualTo(backImagView).offset(-45);
    }];
    [self.book addTarget:self action:@selector(bookClassTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.book addTarget:self action:@selector(bookClass:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.a = 1;
    self.deviceNumber.delegate = self;
    self.deviceNumber.text = self.deviceNum;
    
    
    [self.begin setHidden:YES];
    [self.begin.layer setBorderWidth:1.0];
    [self.begin.layer setBorderColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0].CGColor];
    [self.begin.titleLabel setTextColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0]];
    [self.begin.layer setCornerRadius:20.0f];
    //[self.navigationController setTitle:@"主页"];
    
//    self.isCodeSuccess = [[NSUserDefaults standardUserDefaults] objectForKey:@"isCodeSuccess"];
     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCodeSuccess"];
    
    self.isCodeSuccess = [[NSUserDefaults standardUserDefaults] boolForKey:@"isCodeSuccess"];
//    NSLog(@"<<<<<<<<<>>>>>>>>>>>>>>%@",[[NSUserDefaults standardUserDefaults] boolForKey:@"isCodeSuccess"]);
//    if (self.isCodeSuccess) {
//        [self lookOutBookInformation];
//    }
    
    // Do any additional setup after loading the view.
}
-(void)downLoadIcon{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *string = [DOWNLOADAIMAGE stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"logoImage"]];
    NSLog(@"%@",string);
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"image/png", nil]];
    [manager POST:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"????????????%@",responseObject);
        NSData *data = responseObject;
        UIImage *image = [UIImage imageWithData:data];
        [self.iconButton setImage:image forState:UIControlStateNormal];
        [self.iconButton.imageView.layer setCornerRadius:self.iconButton.bounds.size.width/2.0];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"logoImage"] forKey:@"uploadicon"];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"icon"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
    }];
}
-(void)MyBookRecords{
    MyBookRecordsVC *bookvc = [[MyBookRecordsVC alloc] init];
    bookvc.view.frame = [UIScreen mainScreen].bounds;
    [self.navigationController pushViewController:bookvc animated:YES];
}
-(void)bookClassTouchDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor colorWithRed:6/255.0 green:125/255.0 blue:194/255.0 alpha:1.0]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)bookClass:(UIButton *)sender {
    [sender setTitleColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor clearColor]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
    //UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"bookVC"];
    UIViewController *vc = [[secondBookVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)lookOutBookInformation {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSDictionary *parameters = @{@"yktid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"machinenum":self.deviceNumber.text,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    [manager POST:CHECKBOOK parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        if ([responseObject[@"usetype"] integerValue] == 3) {
            
            //注意：这里的参数machineid  到底是getroom 返回的id字段 还是设备编码？
            NSDictionary *parameter = @{@"yktid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"machinenum":self.deviceNumber.text,@"bespeakid":responseObject[@"bespeakid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            [manager POST:READURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"查询预约网络连接成功！");
                NSLog(@"%@",responseObject);
                NSLog(@"%@",responseObject[@"msg"]);
                if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
                if ([responseObject[@"result"] isEqual:@1]) {
                    //UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的预约" message:@"2016年05月24日 星期二 13:00\n\n信息学院A102\n\n预约设备使用，13:00~14:00" preferredStyle:UIAlertControllerStyleAlert];
                    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@", [self changeTimeInterval:[responseObject[@"starttime"] doubleValue]],[self changeTimeInterval:[responseObject[@"endtime"] doubleValue]],responseObject[@"roomname"]];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的 预约" message:string preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"bespeakid"] forKey:@"bookid"];
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"usagesid"] forKey:@"usagesid"];
                        [[NSUserDefaults standardUserDefaults] setObject:self.deviceNumber.text forKey:@"deviceNumber"];
                        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
                        [self presentViewController:vc animated:YES completion:nil];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:^{
                    }];
                }else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                NSLog(@"网络连接失败！");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:^{
                }];
            }];

        }else if ([responseObject[@"usetype"] integerValue] == 4){
            [self DIYAlert];
        }if ([responseObject[@"usetype"] integerValue] == 5) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"bespeakid"] forKey:@"bookid"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"usagesid"] forKey:@"usagesid"];
            [[NSUserDefaults standardUserDefaults] setObject:self.deviceNumber.text forKey:@"deviceNumber"];
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
            [self presentViewController:vc animated:YES completion:nil];
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
    
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    //注意：这里的参数machineid  到底是getroom 返回的id字段 还是设备编码？
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
//    NSDictionary *parameter = @{@"yktid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"machinenum":self.deviceNumber.text,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
//    [manager POST:READURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"查询预约网络连接成功！");
//        NSLog(@"%@",responseObject);
//        NSLog(@"%@",responseObject[@"msg"]);
//        if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            }];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//
//        if ([responseObject[@"result"] isEqual:@1]) {
//          
//            //UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的预约" message:@"2016年05月24日 星期二 13:00\n\n信息学院A102\n\n预约设备使用，13:00~14:00" preferredStyle:UIAlertControllerStyleAlert];
//            NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@", [self changeTimeInterval:[responseObject[@"starttime"] doubleValue]],[self changeTimeInterval:[responseObject[@"endtime"] doubleValue]],responseObject[@"roomname"]];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的 预约" message:string preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"bespeakid"] forKey:@"bookid"];
//                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"usagesid"] forKey:@"usagesid"];
//                [[NSUserDefaults standardUserDefaults] setObject:self.deviceNumber.text forKey:@"deviceNumber"];
//                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
//                [self presentViewController:vc animated:YES completion:nil];
//            }];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:^{
//            }];
//
//        }else {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        NSLog(@"网络连接失败！");
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:^{
//        }];
//    }];
}
-(void)saoMiaoClick {
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"isCodeSuccess"];
    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"coder"];
    [self.navigationController showViewController:navc sender:nil];
}
- (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    [formatter setDateFormat:@"HH:mm"];
    NSString *currentDate = [formatter stringFromDate:date];
    NSLog(@"%@",currentDate);
    return currentDate;
}
- (NSDate *)getCurrentDateAndTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.beginTime = [formatter stringFromDate:date];
    return date;
}
- (NSString *)changeTimeInterval:(NSTimeInterval)interval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH点mm分"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSLog(@"????<<<>>>>%@",date);
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
- (void)clickDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"00a0e9"]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)beginClick:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSDictionary *parameters = @{@"yktid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"machinenum":_deviceNumber.text,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    NSLog(@"??%@",parameters);
    [manager POST:CHECKBOOK parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"usetype"] integerValue] == 3) {
            NSDictionary *parameter = @{@"yktid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"machinenum":self.deviceNumber.text,@"bespeakid":responseObject[@"bespeakid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [manager POST:READURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"查询预约网络连接成功！");
                NSLog(@"%@",responseObject);
                NSLog(@"%@",responseObject[@"msg"]);
                if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                NSTimeInterval bookTotalTime = [responseObject[@"endtime"] doubleValue] - [responseObject[@"starttime"] doubleValue];
                
                [[NSUserDefaults standardUserDefaults] setInteger:[responseObject[@"endtime"] integerValue] forKey:@"endTime"];
                
                [[NSUserDefaults standardUserDefaults] setInteger:bookTotalTime forKey:@"AllTime"];
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"bespeakid"] forKey:@"bookid"];
                
                NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@", [self changeTimeInterval:[responseObject[@"starttime"] doubleValue]],[self changeTimeInterval:[responseObject[@"endtime"] doubleValue]],responseObject[@"roomname"]];
                if ([responseObject[@"result"] isEqual: @1]) {
                    if ([responseObject[@"used"] isEqual: @1]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"usagesid"] forKey:@"usagesid"];
                            [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentDate] forKey:@"beginTime"];
                            [[NSUserDefaults standardUserDefaults] setObject:self.deviceNumber.text forKey:@"deviceNumber"];
                            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
                            [self presentViewController:vc animated:YES completion:nil];
                        }];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:^{
                        }];
                    }else{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的预约" message:string preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"usagesid"] forKey:@"usagesid"];
                            [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentDate] forKey:@"beginTime"];
                            [[NSUserDefaults standardUserDefaults] setObject:self.deviceNumber.text forKey:@"deviceNumber"];
                            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
                            [self presentViewController:vc animated:YES completion:nil];
                        }];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:^{
                        }];
                    }
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:^{
                    }];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                NSLog(@"网络连接失败！");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:^{
                }];
                
            }];

        }else if ([responseObject[@"usetype"] integerValue] == 4){
            [self DIYAlert];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.deviceNumber setText:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
            }];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    }];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
//        //crash 原因是machineid  为空！
//    NSLog(@"====================%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"]);
//    NSLog(@">>>>>>>>>>>>>>>>>>>>>>%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]);
    //看这里
//    NSDictionary *parameter = @{@"yktid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"machinenum":self.deviceNumber.text,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [manager POST:READURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSLog(@"查询预约网络连接成功！");
//            NSLog(@"%@",responseObject);
//            NSLog(@"%@",responseObject[@"msg"]);
//            if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                }];
//                [alert addAction:action];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
//            NSTimeInterval bookTotalTime = [responseObject[@"endtime"] doubleValue] - [responseObject[@"starttime"] doubleValue];
//            
//            [[NSUserDefaults standardUserDefaults] setInteger:[responseObject[@"endtime"] integerValue] forKey:@"endTime"];
//            
//            [[NSUserDefaults standardUserDefaults] setInteger:bookTotalTime forKey:@"AllTime"];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"bespeakid"] forKey:@"bookid"];
//            
//            NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@", [self changeTimeInterval:[responseObject[@"starttime"] doubleValue]],[self changeTimeInterval:[responseObject[@"endtime"] doubleValue]],responseObject[@"roomname"]];
//            if ([responseObject[@"result"] isEqual: @1]) {
//                if ([responseObject[@"used"] isEqual: @1]) {
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        
//                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"usagesid"] forKey:@"usagesid"];
//                        [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentDate] forKey:@"beginTime"];
//                        [[NSUserDefaults standardUserDefaults] setObject:self.deviceNumber.text forKey:@"deviceNumber"];
//                        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
//                        [self presentViewController:vc animated:YES completion:nil];
//                    }];
//                    [alert addAction:action];
//                    [self presentViewController:alert animated:YES completion:^{
//                    }];
//                }else{
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的预约" message:string preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        
//                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"usagesid"] forKey:@"usagesid"];
//                        [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentDate] forKey:@"beginTime"];
//                        [[NSUserDefaults standardUserDefaults] setObject:self.deviceNumber.text forKey:@"deviceNumber"];
//                        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
//                        [self presentViewController:vc animated:YES completion:nil];
//                    }];
//                    [alert addAction:action];
//                    [self presentViewController:alert animated:YES completion:^{
//                    }];
//                }
//            }else{
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                }];
//                [alert addAction:action];
//                [self presentViewController:alert animated:YES completion:^{
//                }];
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//            NSLog(@"网络连接失败！");
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:^{
//            }];
//    
//        }];
}
- (void)iconButtonClick {
    [self handExchangeHeadPortrait];
}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
//    [self.iconButton setImage:image forState:UIControlStateNormal];
//    //[self.iconButton setBackgroundImage:[UIImage imageNamed:@"pic@3x"] forState:UIControlStateNormal];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
-(void)handExchangeHeadPortrait {
    
    
    UIActionSheet *myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [myActionSheet showInView:self.view];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self pickImage];
//    }];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self takePhotos];
//    }];
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [alert addAction:action1];
//    [alert addAction:action2];
//    [alert addAction:action3];
//  
//    [self presentViewController:alert animated:YES completion:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhotos];
            break;
        case 1:
            [self pickImage];
            break;
        default:
            break;
    }
}
-(void)pickImage {
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickVC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickVC.sourceType];
    pickVC.allowsEditing = YES;
    
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}
-(void)takePhotos {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else {
       

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"未检测到摄像头！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.iconButton setImage:image forState:UIControlStateNormal];
    NSData *imageData = UIImagePNGRepresentation(image);
//    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"icon"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:UPLOADIMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *string = [formatter stringFromDate:[NSDate date]];
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%zd",0] fileName:[NSString stringWithFormat:@"%@.png",string] mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"??>>>%@",responseObject);
        //把上传成功的图片的二进制数据保存到本地
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"icon"];
        //保存头像上传成功后返回的头像在服务器中的地址
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"image0"] forKey:@"uploadicon"];
        NSDictionary *parameters = @{@"logo":responseObject[@"image0"],@"acoutid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"]};
        //调用这个API是在头像图片上传成功后把高该头像图片和用户账号绑定起来 绑定成功以后登录服务器返回
        [manager POST:SAVELOGO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"网络连接成功！");
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络连接失败！");
            NSLog(@"%@",error);
            [self showOkayCancelAlert];
        }];
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

#pragma mark textFiledDelegate 

//用户手动输入的时候 ，开始按钮显示出来

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.begin setHidden:NO];
    [self.book setHidden:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.deviceNumber resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.deviceNumber.text.length == 0) {
        [self.begin setHidden:YES];
        [self.book setHidden:NO];
    }else {
      [self.book setHidden:YES];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.deviceNumber resignFirstResponder];
}
#pragma mark delegate
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //self.navigationItem.title = ![[NSUserDefaults standardUserDefaults] objectForKey:@"location"]?@"定位中":[[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.locationManager requestAlwaysAuthorization];
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
//        [_locationManager requestAlwaysAuthorization];
//    }
//
//     [self.locationManager startUpdatingLocation];
    
    
//    int a = _iconButton.frame.size.height - _iconButton.frame.size.width > 0?_iconButton.frame.size.width/2.0:_iconButton.frame.size.height/2.0;
//    [self.iconButton.layer setCornerRadius:a];
//    self.iconButton.clipsToBounds = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"push"] isEqualToString:@"candelay0"]) {
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
    }
    
    self.isCodeSuccess = [[NSUserDefaults standardUserDefaults] boolForKey:@"isCodeSuccess"];
    if (self.isCodeSuccess) {
        self.deviceNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceNum"];
        self.deviceNumber.text = self.deviceNum;
        [self lookOutBookInformation];
    }
    
    
    
    

}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //每次从home页面跳转的时候，都把该属性设置为NO，是为了保证只有从二维码扫描界面扫描回来该属性才会为YES，这样才能根据该属性来判断是否播放跳转动画
    
    [self setIsCodeSuccess:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"push"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location"];
}

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    
//    CLLocation *newLocation = locations[0];
//    CLLocationCoordinate2D oCoordinate = newLocation.coordinate;
//    NSLog(@"旧的经度：%f,旧的纬度:%f",oCoordinate.longitude,oCoordinate.latitude);
//    
//    
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        for (CLPlacemark *place in placemarks) {
//            NSDictionary *location = [place addressDictionary];
//            NSLog(@"%@",location);
//            self.navigationItem.title = [location objectForKey:@"Name"];
//        }
//    }];
//    
//    [self.locationManager stopUpdatingLocation];
//
//}
#pragma  marks OBSERVER

-(void)addObserver {
    [self.littleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    //这里有一个问题：就是压栈 和 模态 的区别 这里使用的是模态 因为使用压栈不能成功
//    if (object == self.littleLabel && [keyPath isEqualToString:@"text"]) {
//        if ([self.littleLabel.text isEqualToString:@"0"]) {
////          [_timer invalidate];
////          [self.littleLabel removeFromSuperview];
//            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerVC"];
////          UINavigationController *naVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
////          [naVC pushViewController:vc animated:YES];
//           // [self.navigationController pushViewController:vc animated:YES];
//            [self presentViewController:vc animated:YES completion:^{
//                [_timer invalidate];
//                [self.littleLabel removeFromSuperview];
//            }];
//        }
//    }
//}
-(void)autoJump {
//    CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat kHeiht = [UIScreen mainScreen].bounds.size.height;
    //self.littleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 100)/2, kHeiht - 180, 100, 100)];
    self.littleLabel = [[UILabel alloc] init];
    self.littleLabel.hidden = NO;
    self.littleLabel.backgroundColor = [UIColor clearColor];
    self.littleLabel.textColor = [UIColor blueColor];
    self.littleLabel.font = [UIFont boldSystemFontOfSize:66];
    [self.littleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.littleLabel];
    
//    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.littleLabel.alpha = 1.0;
//        self.littleLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
//        [self ThreeTwoOne];
//    } completion:^(BOOL finished) {
//        //[self.littleLabel removeFromSuperview];
//        
//    }];
    [self.littleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceNumber.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.left.equalTo(@100);
        make.height.equalTo(@100);
    }];
}

-(void)ThreeTwoOne{
    self.a  = self.a - 1;
    [self.littleLabel setText:[NSString stringWithFormat:@"%zd",self.a]];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
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
- (void)DIYDismiss {
    if (self.alertView && self.alertWindow) {
        [self.alertView removeFromSuperview];
        [self.alertWindow resignKeyWindow];
        self.alertWindow = nil;
    }
}
- (void)DIYAlert {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.alertWindow addSubview:_alertView];
    [_alertView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
    [_alertWindow makeKeyAndVisible];
    UIView *littleView = [[UIView alloc] init];
    [_alertView addSubview:littleView];
    [littleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_alertView).offset(20*ScreenWidth/320.0);
        make.right.equalTo(_alertView).offset(-20*ScreenWidth/320.0);
        make.center.equalTo(_alertView);
        make.height.equalTo(_alertView).multipliedBy(0.3);
    }];
    [littleView setBackgroundColor:[UIColor whiteColor]];
    [littleView.layer setCornerRadius:5];
    
    UILabel *titleL = [[UILabel alloc] init];
    [littleView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(littleView);
        make.top.equalTo(littleView).offset(15*ScreenHeight/568.0);
    }];
    [titleL setText:@"请设置上课时长"];
    [titleL setTextColor:[UIColor hexChangeFloat:@"00a0e9"]];
    if (ScreenHeight==568) {
        [titleL setFont:[UIFont systemFontOfSize:14]];
        
    }else if (ScreenHeight == 667){
        [titleL setFont:[UIFont systemFontOfSize:16]];
        
    }else if (ScreenHeight == 736){
        [titleL setFont:[UIFont systemFontOfSize:18]];
        
    }
//    [titleL setFont:[UIFont systemFontOfSize:14.0]];
    UIButton *btnleft1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnleft1 setTag:1];
    [btnleft1 setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
//    [btnleft1 setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [littleView addSubview:btnleft1];
    [btnleft1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset(20*ScreenHeight/568.0);
        make.centerX.equalTo(titleL).multipliedBy(0.5).offset(-10);
        make.height.equalTo(@(12*ScreenHeight/568.0));
        make.width.equalTo(@(12*ScreenWidth/320.0));
    }];
    [btnleft1 addTarget:self action:@selector(btnClickDown:) forControlEvents:UIControlEventTouchUpInside];
    _timeL1 = [[UILabel alloc] init];
    [_timeL1 setText:@"45分钟"];
    if (ScreenHeight==568) {
        [_timeL1 setFont:[UIFont systemFontOfSize:13.0]];
        
    }else if (ScreenHeight == 667){
        [_timeL1 setFont:[UIFont systemFontOfSize:15.0]];
        
    }else if (ScreenHeight == 736){
        [_timeL1 setFont:[UIFont systemFontOfSize:17.0]];
        
    }
//    [_timeL1 setFont:[UIFont systemFontOfSize:13.0]];
    [_timeL1 setTextColor:[UIColor hexChangeFloat:@"727171"]];
    [littleView addSubview:_timeL1];
    [_timeL1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnleft1.mas_right).offset(5);
        make.centerY.equalTo(btnleft1);
    }];
    
    UIButton *btnLeft2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft2 setTag:2];
//    [btnLeft2 setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [btnLeft2 setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [littleView addSubview:btnLeft2];
    [btnLeft2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnleft1.mas_bottom).offset(20*ScreenHeight/568.0);
        make.centerX.equalTo(btnleft1);
        make.height.equalTo(btnleft1);
        make.width.equalTo(btnleft1);
    }];
    [btnLeft2 addTarget:self action:@selector(btnClickDown:) forControlEvents:UIControlEventTouchUpInside];
    _timeL2 = [[UILabel alloc] init];
    [_timeL2 setTextColor:[UIColor hexChangeFloat:@"727171"]];
    [_timeL2 setText:@"100分钟"];
//    [_timeL2 setFont:[UIFont systemFontOfSize:13.0]];
    if (ScreenHeight==568) {
        [_timeL2 setFont:[UIFont systemFontOfSize:13.0]];
        
    }else if (ScreenHeight == 667){
        [_timeL2 setFont:[UIFont systemFontOfSize:15.0]];
        
    }else if (ScreenHeight == 736){
        [_timeL2 setFont:[UIFont systemFontOfSize:17.0]];
        
    }
    [littleView addSubview:_timeL2];
    [_timeL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnLeft2.mas_right).offset(5);
        make.centerY.equalTo(btnLeft2);
    }];
    
    UIButton *btnRight1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight1 setTag:3];
//    [btnRight1 setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [btnRight1 setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [littleView addSubview:btnRight1];
    [btnRight1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeL1.mas_right).offset(30*ScreenWidth/320.0);
        make.height.equalTo(btnleft1);
        make.width.equalTo(btnleft1);
        make.top.equalTo(btnleft1);
    }];
    [btnRight1 addTarget:self action:@selector(btnClickDown:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *timeRight1 = [[UILabel alloc] init];
    [timeRight1 setText:@"155分钟"];
    if (ScreenHeight==568) {
        [timeRight1 setFont:[UIFont systemFontOfSize:13.0]];
        
    }else if (ScreenHeight == 667){
        [timeRight1 setFont:[UIFont systemFontOfSize:15.0]];
        
    }else if (ScreenHeight == 736){
        [timeRight1 setFont:[UIFont systemFontOfSize:17.0]];
        
    }
//    [timeRight1 setFont:[UIFont systemFontOfSize:13.0]];
    [timeRight1 setTextColor:[UIColor hexChangeFloat:@"727171"]];
    [littleView addSubview:timeRight1];
    [timeRight1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnRight1.mas_right).offset(5);
        make.centerY.equalTo(btnRight1);
    }];
    UIButton *btnRight2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight2 setTag:4];
//    [btnRight2 setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [btnRight2 setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [littleView addSubview:btnRight2];
    [btnRight2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btnRight1);
        make.top.equalTo(btnRight1.mas_bottom).offset(20*ScreenHeight/568.0);
        make.height.equalTo(btnRight1);
        make.width.equalTo(btnRight1);
    }];
    [btnRight2 addTarget:self action:@selector(btnClickDown:) forControlEvents:UIControlEventTouchUpInside];
    
    _timeInput = [[UITextField alloc] init];
    if (ScreenHeight==568) {
        [_timeInput setFont:[UIFont systemFontOfSize:13.0]];
        
    }else if (ScreenHeight == 667){
        [_timeInput setFont:[UIFont systemFontOfSize:15.0]];
        
    }else if (ScreenHeight == 736){
        [_timeInput setFont:[UIFont systemFontOfSize:17.0]];
        
    }
    [_timeInput setTintColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    [_timeInput setTextAlignment:NSTextAlignmentCenter];
//    [timeInput setBackgroundColor:[UIColor redColor]];
    [littleView addSubview:_timeInput];
    [_timeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnRight2.mas_right).offset(5);
        make.centerY.equalTo(btnRight2);
        make.height.equalTo(timeRight1);
        make.width.equalTo(@(30*ScreenWidth/320.0));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    [littleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(btnRight2.mas_right).offset(5);
        make.top.equalTo(_timeInput.mas_bottom);
        make.width.equalTo(_timeInput);
    }];
    
    UILabel *timeL = [[UILabel alloc] init];
//    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"  (自定义)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0],NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"9fa0a0"]}];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"727171"]}];
    NSAttributedString *string;
    NSMutableAttributedString *str;
    if (ScreenHeight==568) {
        string = [[NSAttributedString alloc] initWithString:@"  (自定义)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0],NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"9fa0a0"]}];
        str = [[NSMutableAttributedString alloc] initWithString:@"分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"727171"]}];
        
    }else if (ScreenHeight == 667){
        string = [[NSAttributedString alloc] initWithString:@"  (自定义)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0],NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"9fa0a0"]}];
        str = [[NSMutableAttributedString alloc] initWithString:@"分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"727171"]}];
        
    }else if (ScreenHeight == 736){
        string = [[NSAttributedString alloc] initWithString:@"  (自定义)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"9fa0a0"]}];
        str = [[NSMutableAttributedString alloc] initWithString:@"分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"727171"]}];
        
    }
    [str appendAttributedString:string];
    [timeL setAttributedText:str];
//    [timeL setFont:[UIFont systemFontOfSize:12.0]];
    [timeL setTextColor:[UIColor hexChangeFloat:@"727171"]];
    [littleView addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeInput.mas_right);
        make.centerY.equalTo(btnRight2);
    }];
    
    UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [beginBtn.layer setCornerRadius:5];
    [beginBtn setBackgroundColor:[UIColor clearColor]];
    [beginBtn setTitle:@"开  始" forState:UIControlStateNormal];
    if (ScreenHeight==568) {
        [beginBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
    }else if (ScreenHeight == 667){
        [beginBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
    }else if (ScreenHeight == 736){
        [beginBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
    }
//    [beginBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [beginBtn setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    [beginBtn.layer setBorderColor:[UIColor hexChangeFloat:@"00a0e9"].CGColor];
    [beginBtn.layer setBorderWidth:0.5];
    [littleView addSubview:beginBtn];
    [beginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(littleView);
        make.top.equalTo(btnLeft2.mas_bottom).offset(25*ScreenHeight/568.0);
        make.height.equalTo(@(25*ScreenHeight/568.0));
        make.width.equalTo(@(70*ScreenWidth/320.0));
    }];
    [beginBtn addTarget:self action:@selector(alertStart:) forControlEvents:UIControlEventTouchUpInside];
    [beginBtn addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    [self.btnArr addObjectsFromArray:@[btnleft1,btnLeft2,btnRight1,btnRight2]];
}
- (void)btnClickDown:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    switch (sender.tag) {
        case 1:{
            sender.tag = sender.tag + 100;
            self.seletedTime = _timeL1.text;
            self.endTime = [formatter stringFromDate:[NSDate dateWithTimeInterval:45*60 sinceDate:[self getCurrentDateAndTime]]];
            [sender setBackgroundImage:[UIImage imageNamed:@"钩钩"] forState:UIControlStateNormal];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.btnArr];
            [arr removeObject:sender];
            for (UIButton *btn in arr) {
                if (btn.tag > 100) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
                    btn.tag = btn.tag - 100;
                }
            }
            break;
        }
        case 2:{
            sender.tag = sender.tag + 100;
            self.seletedTime = _timeL2.text;
             self.endTime = [formatter stringFromDate:[NSDate dateWithTimeInterval:45*60 sinceDate:[self getCurrentDateAndTime]]];
            [sender setBackgroundImage:[UIImage imageNamed:@"钩钩"] forState:UIControlStateNormal];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.btnArr];
            [arr removeObject:sender];
            for (UIButton *btn in arr) {
                if (btn.tag > 100) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
                    btn.tag = btn.tag - 100;
                }
            }
            break;
        }
        case 3:{
            sender.tag = sender.tag + 100;
            self.seletedTime = _timeRight1.text;
            self.endTime = [formatter stringFromDate:[NSDate dateWithTimeInterval:45*60 sinceDate:[self getCurrentDateAndTime]]];
            [sender setBackgroundImage:[UIImage imageNamed:@"钩钩"] forState:UIControlStateNormal];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.btnArr];
            [arr removeObject:sender];
            for (UIButton *btn in arr) {
                if (btn.tag > 100) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
                    btn.tag = btn.tag - 100;
                }
            }
            break;
        }
        case 4:{
            sender.tag = sender.tag + 100;
            if (self.timeInput.text.length == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先输入预约时长！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self DIYAlert];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:^{
                    [self DIYDismiss];
                }];
            }else {
                self.seletedTime = _timeInput.text;
                //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSInteger timeInterval = [self.seletedTime integerValue];
                self.endTime = [formatter stringFromDate:[NSDate dateWithTimeInterval:timeInterval*60 sinceDate:[self getCurrentDateAndTime]]];
                //            self.endTime = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:45*60 sinceDate:[self getCurrentDateAndTime]]];
                [sender setBackgroundImage:[UIImage imageNamed:@"钩钩"] forState:UIControlStateNormal];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.btnArr];
                [arr removeObject:sender];
                for (UIButton *btn in arr) {
                    if (btn.tag > 100) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
                        btn.tag = btn.tag - 100;
                    }
                }
            }
            break;
        }
        case 101:{
            sender.tag = sender.tag - 100;
            self.seletedTime = @"";
            self.endTime = nil;
            self.beginTime = nil;
            [sender setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
            break;
        }
        case 102:{
            sender.tag = sender.tag - 100;
            self.seletedTime = @"";
            self.endTime = nil;
            self.beginTime = nil;
            [sender setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
            break;
        }
            case 103:{
                sender.tag = sender.tag - 100;
                self.seletedTime = @"";
                self.endTime = nil;
                self.beginTime = nil;
                [sender setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
                break;
        }
        case 104:{
            sender.tag = sender.tag - 100;
            self.seletedTime = @"";
            self.endTime = nil;
            self.beginTime = nil;
            [sender setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}
- (void)alertStart:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self DIYDismiss];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSDictionary *parameters = @{@"yktid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"machinenum":self.deviceNumber.text,@"starttime":self.beginTime ,@"endtime":self.endTime,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    NSLog(@"<>%@",parameters);
    [manager POST:READURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"result"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:self.deviceNumber.text forKey:@"deviceNum"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"usagesid"] forKey:@"usagesid"];
            ThirdVC *vc = [[ThirdVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]){
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
                    }];
                }else{
                    //[self DIYAlert];
                }
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                [self DIYDismiss];
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
        [self DIYDismiss];
        [self showOkayCancelAlert];
    }];
}
//git分支学习测试
-(void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"next"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //跳转前本地化设备编码到Plist
    [[NSUserDefaults standardUserDefaults] setValue:self.deviceNumber.text forKey:@"deviceNumber"];
    
}


@end

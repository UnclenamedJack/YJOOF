//
//  QRcodeViewController.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "QRcodeViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import "saomiaoVC.h"
#import "AttachVC.h"
#import "Header.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "bindingOrHistroyBindViewController.h"
#import "searchModel.h"
#import "binddingModel.h"
#import "chapaiVC.h"
#import "bindingChaKongVC.h"
#import "chapaiModel.h"
#import "IndexVC.h"
#import "Masonry.h"
#import "DIYView.h"
#import "UIColor+Extend.h"

@interface QRcodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,MBProgressHUDDelegate>
@property(nonatomic,strong) AVCaptureDevice *device;
@property(nonatomic,strong) AVCaptureDeviceInput *input;
@property(nonatomic,strong) AVCaptureSession *session;
@property(nonatomic,strong) AVCaptureMetadataOutput *output;
@property(nonatomic,strong) UIView *preview;
@property(nonatomic,strong) UIImageView *inamationView;
@property(nonatomic,strong) UIImageView *kuang;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) BOOL LightIsON;
@property(nonatomic, strong) UIWindow *alertWindow;

@end

@implementation QRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_big"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor hexChangeFloat:@"ffffff"]];
    self.LightIsON = NO;
    self.navigationItem.title = @"扫描二维码";
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.view setUserInteractionEnabled:YES];
    
    
    UIButton *threePoint = [UIButton buttonWithType:UIButtonTypeCustom];
    [threePoint setImage:[UIImage imageNamed:@"diandiandian"] forState:UIControlStateNormal];
    [self.view  addSubview:threePoint];
    [threePoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64 + 30);
        make.right.equalTo(self.view).offset(-20);
    }];
    [threePoint addTarget:self action:@selector(threePointClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *flash = [UIButton buttonWithType:UIButtonTypeCustom];
    [flash setImage:[UIImage imageNamed:@"shanguangdeng"] forState:UIControlStateNormal];
    [self.view addSubview:flash];
    [flash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64+ 30);
        make.right.equalTo(threePoint.mas_left).offset(-10);
    }];
    [flash addTarget:self action:@selector(flashLight:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *image = [UIImage imageNamed:@"erweima"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 26, 26)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.width -80)];
    [imageView setImage:image];
    CGPoint point = self.view.center;
    point.y += -50;
    imageView.center = point;
    [self.view addSubview:imageView];
    imageView.clipsToBounds = YES;
    self.kuang = imageView;
    

    UIImageView *anamiview = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, 2.0)];
    anamiview.image = [UIImage imageNamed:@"saomiao"];
    [imageView addSubview:anamiview];
    self.inamationView = anamiview;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(changeInamation) userInfo:nil repeats:YES];
    
    [self innationQRCode];
    
}
- (void)threePointClick:(UIButton *)sender {
    self.alertWindow = [[UIWindow alloc] initWithFrame:self.view.bounds];
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow becomeFirstResponder];
    
    DIYView *alertView = [[DIYView alloc] initWithFrame:self.view.bounds];
    __weak DIYView *weakAlertView  = alertView;
    alertView.block = ^{
        [self dismissAlert:weakAlertView];
    };
    [alertView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    [self.alertWindow addSubview:alertView];
    
    
    /**
     下面的内容封装到了DIYView 中了
     
     - returns: DIYView
     */
    
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"duihuakuang"]];
//    [alertView addSubview:imgView];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(alertView).offset(-20);
//        make.top.equalTo(alertView).offset(64+30+30+10);
//        make.height.equalTo(@80);
//        make.width.equalTo(@120);
//    }];
//    
//    UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    inputBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    inputBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0) ;
//    inputBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
//    [inputBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    [inputBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [inputBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [inputBtn setTitle:@"输入MAC地址" forState:UIControlStateNormal];
//    [inputBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
//    [imgView addSubview:inputBtn];
//    [inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imgView).offset(5);
//        make.left.equalTo(imgView);
//        make.right.equalTo(imgView);
//    }];
//    
//    UIView *middleLine = [[UIView alloc] init];
//    [middleLine setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
//    [imgView addSubview:middleLine];
//    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(inputBtn.mas_bottom);
//        make.left.equalTo(imgView);
//        make.right.equalTo(imgView);
//        make.height.equalTo(@2);
//    }];
//    
//    UIButton *exceptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    exceptionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    exceptionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    exceptionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
//    [exceptionBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [exceptionBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    [exceptionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [exceptionBtn setImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
//    [exceptionBtn setTitle:@"异常反馈" forState:UIControlStateNormal];
//    [imgView addSubview:exceptionBtn];
//    [exceptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(inputBtn.mas_bottom).offset(2);
//        make.left.equalTo(inputBtn);
//        make.right.equalTo(inputBtn);
//        make.bottom.equalTo(imgView);
//        make.height.equalTo(inputBtn);
//    }];
}
- (void)dismissAlert:(DIYView *)view {
    [view removeFromSuperview];
    [self.alertWindow  resignKeyWindow];
    self.alertWindow = nil;
}

- (void)back:(UIBarButtonItem *)sender {
    if (self.navigationController.childViewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)changeInamation{
    [self.inamationView setFrame:CGRectOffset(self.inamationView.frame, 0, 2)];
//    self.inamationView.frame = CGRectOffset(self.inamationView.frame, 0, 2);
    if (self.inamationView.frame.origin.y >= self.kuang.frame.size.height) {
        self.inamationView.frame = CGRectOffset(self.inamationView.bounds, 0, -self.inamationView.frame.size.height);
    }
}
- (IBAction)closeBarButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
//    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)flashLight:(id)sender {
    if (!self.LightIsON) {
        if ([self.device hasTorch]&&[self.device hasFlash]) {
            if (self.device.torchMode == AVCaptureTorchModeOff) {
                [self.session beginConfiguration];
                [self.device lockForConfiguration:nil];
                [self.device setTorchMode:AVCaptureTorchModeOn];
                [self.device setFlashMode:AVCaptureFlashModeOn];
                [self.device unlockForConfiguration];
                [self.session commitConfiguration];
                self.LightIsON = YES;
            }
        }
        [self.session startRunning];
    }
    else{
        [self.session beginConfiguration];
        [self.device lockForConfiguration:nil];
        if (self.device.torchMode == AVCaptureTorchModeOn) {
            [self.device setTorchMode:AVCaptureTorchModeOff];
            [self.device setFlashMode:AVCaptureFlashModeOff];
        }
        [self.device unlockForConfiguration];
        [self.session commitConfiguration];
        [self.session startRunning];
        self.LightIsON = NO;
    }
    
}
-(void)innationQRCode {
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error ;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"获取设备失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    self.session = [[AVCaptureSession alloc] init];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("muQueue", NULL);
    [output setMetadataObjectsDelegate:self queue:queue];
    self.output = output;
    [self.session addOutput:self.output];
    [self.output setMetadataObjectTypes:self.output.availableMetadataObjectTypes];
//    [_output setRectOfInterest:CGRectMake(self.kuang.frame.origin.x + 5, self.kuang.frame.origin.y + 5, self.kuang.frame.size.width - 10, self.kuang.frame.size.height - 10)];
    AVCaptureVideoPreviewLayer *videoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [videoLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    [videoLayer setFrame:self.view.frame];

    [videoLayer setFrame:CGRectMake(0 , 0 , self.kuang.frame.size.width - 10, self.kuang.frame.size.height - 10)];
    
//    self.preview = [[UIView alloc] initWithFrame:self.view.bounds];
    self.preview = [[UIView alloc] initWithFrame:CGRectMake(self.kuang.frame.origin.x + 5, self.kuang.frame.origin.y + 5, self.kuang.frame.size.width - 10, self.kuang.frame.size.height - 10)];
    [self.view addSubview:self.preview];
    [self.preview.layer addSublayer:videoLayer];
    
    [self.view bringSubviewToFront:self.kuang];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self start];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self end];
}
- (void)start {
    [self.session startRunning];
    [self.timer fire];
}
- (void)end {
    [self.session stopRunning];
    [self.timer invalidate];
}
- (void)result:(NSString *)str {
    [self.session stopRunning];
    if ([str hasPrefix:@"http"]) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"resultVC"];
        [vc setValue:str forKey:@"result"];
        if (self.navigationController.viewControllers.count > 1) {
            return;
        }
        [self.navigationController pushViewController:vc animated:YES];
        //[self presentViewController:vc animated:YES completion:nil];
    }else{
//       UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
//        [vc setValue:str forKey:@"deviceNum"];
//        [vc setValue:@1 forKey:@"isCodeSuccess"];
        
//        if ([self.presentingViewController.childViewControllers.lastObject isMemberOfClass:[saomiaoVC class]]) {
        if ([self.navigationController.presentingViewController isMemberOfClass:[IndexVC class]] || [self.navigationController.childViewControllers.firstObject isMemberOfClass:[bindingOrHistroyBindViewController class]]){
#if DEBUG
            NSLog(@"<><><>绑定插座扫描");
#endif
            [self checkBindingOrNot:str];
            
//            AttachVC *vc = [[AttachVC alloc] init];
//            vc.mac = str;
//            [self presentViewController:vc animated:YES completion:nil];
                    }else{
#if DEBUG
            NSLog(@"<><><>app扫描");
#endif
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isCodeSuccess"];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"deviceNum"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
//        这里曾经有一bug  原因定位于  一个模态过来的视图 是dismiss 回去 还是 模态回去 ！
        //[self presentViewController:vc animated:YES completion:nil];
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];------
        
//        if (self.navigationController.viewControllers.count > 1) {
//            return;
//        }
        
     //   self.backValue(str);
        //[self.navigationController popViewControllerAnimated:YES];
//        [navc popViewControllerAnimated:YES];
        //[navc popToRootViewControllerAnimated:YES];
        
        
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

- (void)checkBindingOrNot:(NSString *)macDress {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/json",@"text/javascript", nil];
    NSDictionary *parameters = @{@"mac":macDress,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setDelegate:self];
    [HUD setRemoveFromSuperViewOnHide:YES];
    [manager POST:SAOMIAOCHAZUO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        
        if ([responseObject[@"result"] integerValue] == 1) {
            [HUD hideAnimated:YES];
            if (self.identifier == 0) {
                int type = [responseObject[@"obj"][@"machineinfo"][@"type"] intValue];
                if (type == 1) {
                    [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"obj"][@"machineinfo"][@"machineid"] forKey:@"machineid"];
                    if ([[responseObject[@"obj"] allKeys] containsObject:@"bdasset"] || [[responseObject[@"obj"] allKeys] containsObject:@"bdmachine"]) {
                        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                        vc.mac = macDress;
                        vc.type = ChaZuo;
                        vc.title = @"插座信息";
                        if ([[responseObject[@"obj"] allKeys] containsObject:@"bdasset"]) {
                            vc.WhatIsBinding = 1;// 当前绑定的是资产
                            vc.model = [searchModel modelWithDictionary:responseObject[@"obj"][@"bdasset"]];
                        }else if ([[responseObject[@"obj"] allKeys] containsObject:@"bdmachine"]){
                            vc.WhatIsBinding = 2;// 当前绑定的是插排或插座
                            NSArray *hubs = responseObject[@"obj"][@"bdmachine"][@"hubs"];
                            vc.model2 = [chapaiModel modelWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:responseObject[@"obj"][@"bdmachine"][@"mac"],@"mac",[NSString stringWithFormat:@"%zd孔智能插排",hubs.count],@"name",responseObject[@"obj"][@"bdmachine"][@"machineid"],@"machineid",responseObject[@"obj"][@"bdmachine"][@"type"],@"type", nil]];

                        }
                        
                        NSMutableArray *dataArr = [NSMutableArray array];
                        if ([[responseObject[@"obj"] allKeys] containsObject:@"hbdassetList"]) {
//                            [dataArr addObjectsFromArray:responseObject[@"obj"][@"hbdassetList"]];
                            for (NSDictionary *dict in responseObject[@"obj"][@"hbdassetList"]) {
                                searchModel *model = [searchModel modelWithDictionary:dict];
                                [dataArr addObject:model];
                            }
                        }
                        if ([[responseObject[@"obj"] allKeys] containsObject:@"hbdmachineList"]){
//                            [dataArr addObjectsFromArray:responseObject[@"obj"][@"hbdmachineList"]];
                            for (NSDictionary *dict in responseObject[@"obj"][@"hbdmachineList"]) {
                                NSDictionary *dictNew;
                                if ([dict[@"type"] integerValue] == 1) {
                                    dictNew = [NSDictionary dictionaryWithObjectsAndKeys:dict[@"mac"],@"mac",dict[@"machineid"],@"machineid",@"86型智能插座",@"name",dict[@"type"],@"type", nil];
                                }else{//[dict[@"type"] integerValue] == 2
                                    NSArray *hub = dict[@"hubs"];
                                    dictNew = [NSDictionary dictionaryWithObjectsAndKeys:dict[@"mac"],@"mac",dict[@"machineid"],@"machineid",[NSString stringWithFormat:@"%ld孔智能插座",hub.count],@"name",dict[@"type"],@"type", nil];
                                }
                                chapaiModel *model = [chapaiModel modelWithDictionary:dictNew];
                                [dataArr addObject:model];
                            }
                        }
                        vc.hbdArr = dataArr;
                         UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:navc animated:YES completion:nil];
                    }else if ([[responseObject[@"obj"] allKeys] containsObject:@"hbdassetList"] || [[responseObject[@"obj"] allKeys] containsObject:@"hbdmachineList"]){
                        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                        vc.mac = macDress;
                        vc.type = ChaZuo;
                        vc.title = @"插座信息";
                        vc.WhatIsBinding = 3;//当前没有任何绑定 但是 有历史绑定记录
                        NSMutableArray *dataArr = [NSMutableArray array];
                        if ([[responseObject[@"obj"] allKeys] containsObject:@"hbdassetList"]) {
//                            [dataArr addObjectsFromArray:responseObject[@"obj"][@"hbdassetList"]];
                            for (NSDictionary *dict in responseObject[@"obj"][@"hbdassetList"]) {
                                searchModel *model = [searchModel modelWithDictionary:dict];
                                [dataArr addObject:model];
                            }
                        }
                        if ([[responseObject[@"obj"] allKeys] containsObject:@"hbdmachineList"]){
//                            [dataArr addObjectsFromArray:responseObject[@"obj"][@"hbdmachineList"]];
                            for (NSDictionary *dict in responseObject[@"obj"][@"hbdmachineList"]) {
                                NSDictionary *dictNew;
                                if ([dict[@"type"] integerValue] == 1) {
                                    dictNew = [NSDictionary dictionaryWithObjectsAndKeys:dict[@"mac"],@"mac",dict[@"machineid"],@"machineid",@"86型智能插座",@"name",dict[@"type"],@"type", nil];
                                }else{//[dict[@"type"] integerValue] == 2
                                    NSArray *hub = dict[@"hubs"];
                                    dictNew = [NSDictionary dictionaryWithObjectsAndKeys:dict[@"mac"],@"mac",dict[@"machineid"],@"machineid",[NSString stringWithFormat:@"%ld孔智能插座",hub.count],@"name",dict[@"type"],@"type", nil];
                                }
                                chapaiModel *model = [chapaiModel modelWithDictionary:dictNew];
                                [dataArr addObject:model];
                            }
                            
//                            for (NSDictionary *dict in responseObject[@"obj"][@"hbdmachineList"]) {
//                                chapaiModel *model = [chapaiModel modelWithDictionary:dict];
//                                [dataArr addObject:model];
//                            }
                        }
                        vc.hbdArr = dataArr;
                        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:navc animated:YES completion:nil];
                    }else{
                        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                        vc.WhatIsBinding = 0;//当前没有绑定 也 没有任何历史绑定记录
                        vc.mac = macDress;
                        vc.type = ChaZuo;
                        vc.title = @"插座信息";
                        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:navc animated:YES completion:nil];
//                        AttachVC *vc = [[AttachVC alloc] init];
//                        vc.mac = macDress;
//                        [self presentViewController:vc animated:YES completion:nil];
                    }
                }else if (type == 2){
//                    [self binding:responseObject[@"obj"][@"machineinfo"][@"machineid"] andMac:macDress];
                
                    
                    
                    
                    
                    bindingChaKongVC *vc = [[bindingChaKongVC alloc] init];
                    vc.mac = macDress;
                    vc.hubs = responseObject[@"obj"][@"machineinfo"][@"hubs"];
//                    NSMutableArray *dataArr = [NSMutableArray array];
//                    if (responseObject[@"obj"][@"bdassetid"]) {
//                        [dataArr addObjectsFromArray:responseObject[@"obj"][@"bdassetid"]];
//                     }
//                    if(responseObject[@"obj"][@"bdmachine"]){
//                         [dataArr addObjectsFromArray:responseObject[@"obj"][@"bdmachineid"]];
//                     }
//                    vc.bindingDataArr = dataArr;
                    
                    
                    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:navc animated:YES completion:nil];
                
                }
               
            }else if (self.identifier == 1){
//                chapaiVC *vc = [[chapaiVC alloc] init];
//                vc.mac2 = macDress;
//                vc.mac1 = self.secondMac;
//                vc.hubs = responseObject[@"obj"][@"machineinfo"][@"hubs"];
//                vc.machineid = responseObject[@"obj"][@"machineinfo"][@"machineid"];
//                [self presentViewController:vc animated:YES completion:nil];
                
                
//                bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
//                UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
//                [self presentViewController:navc animated:YES completion:nil];
                [self binding:responseObject[@"obj"][@"machineinfo"][@"machineid"] andMac:macDress];
            }
        }else{
            [HUD setMode:MBProgressHUDModeCustomView];
            [HUD hideAnimated:YES afterDelay:2.0];
            [HUD.label setText:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
#endif
        [HUD setMode:MBProgressHUDModeCustomView];
        [HUD hideAnimated:YES afterDelay:2.0];
        [HUD.label setText:@"网络连接失败！"];
    }];

}
- (void)binding:(NSNumber *)machineid andMac:(NSString *)mac {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdmachineid":machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud.label setText:@"正在扫描"];
    [manager POST:CHAZUOBANGDING parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        if ([responseObject[@"result"] intValue] == 1) {
            [hud setMode:MBProgressHUDModeCustomView];
            [hud.label setText:@"扫描成功"];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gougou"]];
            [hud hideAnimated:YES];
            bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
            NSArray *hubs = responseObject[@"obj"][@"machineinfo"][@"hubs"];
            vc.model2 = [chapaiModel modelWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:mac,@"mac",[NSString stringWithFormat:@"%zd孔智能插排",hubs.count],@"name",machineid,@"machineid", nil]];
            vc.WhatIsBinding = 2;
            vc.type = ChaZuo;
            UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navc animated:YES completion:nil];
        }else{
            [hud setMode:MBProgressHUDModeCustomView];
            [hud.label setText:responseObject[@"msg"]];
            [hud hideAnimated:YES afterDelay:1.5];
            
            bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
            vc.WhatIsBinding = 0;
            UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navc animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
#endif
        [hud setMode:MBProgressHUDModeCustomView];
        [hud.label setText:@"网络连接失败！"];
        [hud hideAnimated:YES afterDelay:1.5];
        
//        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
//        vc.WhatIsBinding = 0;
//        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:navc animated:YES completion:nil];
    }];
    
}

#pragma MBProgressHUDDelegate
//- (void)hudWasHidden:(MBProgressHUD *)hud {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
#pragma AVCapture
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    id object = metadataObjects.firstObject;
    if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)object;
        
        [self performSelectorOnMainThread:@selector(result:) withObject:obj.stringValue waitUntilDone:NO];
    }
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

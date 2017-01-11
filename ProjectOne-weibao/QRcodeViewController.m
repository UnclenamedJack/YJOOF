//
//  QRcodeViewController.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "QRcodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "saomiaoVC.h"
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

@end

@implementation QRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.LightIsON = NO;
    //self.navigationController.title = @"二维码";
    [self innationQRCode];
    UIImage *image = [UIImage imageNamed:@"kuang"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 26, 26)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.width -80)];
    [imageView setImage:image];
    CGPoint point = self.view.center;
    point.y += -50;
    imageView.center = point;
    [self.view addSubview:imageView];
    imageView.clipsToBounds = YES;
    self.kuang = imageView;
    
//    UIImageView *anamiview = [[UIImageView alloc] initWithFrame:imageView.bounds];
    UIImageView *anamiview = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, 2.0)];
    anamiview.image = [UIImage imageNamed:@"sao"];
    [imageView addSubview:anamiview];
    self.inamationView = anamiview;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(changeInamation) userInfo:nil repeats:YES];
    
}
-(void)changeInamation{
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
    
    AVCaptureVideoPreviewLayer *videoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [videoLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoLayer setFrame:self.view.frame];
    
    self.preview = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.preview];
    [self.preview.layer addSublayer:videoLayer];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self start];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self end];
}
-(void)start {
    [self.session startRunning];
    [self.timer fire];
}
-(void)end {
    [self.session stopRunning];
    [self.timer invalidate];
}
-(void)result:(NSString *)str {
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
        if ([self.presentingViewController.childViewControllers.lastObject isMemberOfClass:[saomiaoVC class]]) {
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
                    if ([[responseObject[@"obj"] allKeys] containsObject:@"bdasset"]) {
                        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                        //                vc.num = responseObject[@"obj"][@"bdasset"][@"num"];
                        //                vc.name = responseObject[@"obj"][@"bdasset"][@"name"];
                        //                vc.departName = responseObject[@"obj"][@"bdasset"][@"deptname"];
                        //                vc.address = responseObject[@"obj"][@"bdasset"][@"address"];
                        vc.mac = macDress;
                        vc.WhatIsBinding = 1;
                        vc.model = [searchModel modelWithDictionary:responseObject[@"obj"][@"bdasset"]];
                         UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:navc animated:YES completion:nil];
                    }else if ([[responseObject[@"obj"] allKeys] containsObject:@"bdmachine"]){
                        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
                        vc.mac = macDress;
                        vc.WhatIsBinding = 2;
                        vc.model1 = [binddingModel modelWithDictionary:responseObject[@"obj"][@"bdmachine"]];
                        [self presentViewController:navc animated:YES completion:nil];
                    }else if ([[responseObject[@"obj"] allKeys] containsObject:@"hbdasset"]){
                        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                        vc.mac = macDress;
                        [self presentViewController:vc animated:YES completion:nil];
                    }else if ([[responseObject[@"obj"] allKeys] containsObject:@"hbdmachineid"]){
                        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                        vc.mac = macDress;
                        [self presentViewController:vc animated:YES completion:nil];
                    }else{
                        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                        vc.WhatIsBinding = 0;
                        vc.mac = macDress;
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
                [self binding:[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"] andMac:macDress];
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
    [manager POST:CHAZUOBANGDING parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        if ([responseObject[@"result"] intValue] == 1) {
            [hud hideAnimated:YES];
            bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
            NSArray *hubs = responseObject[@"obj"][@"machineinfo"][@"hubs"];
            vc.model2 =[chapaiModel modelWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:mac,@"mac",[NSString stringWithFormat:@"%zd孔智能插排",hubs.count],@"name", nil]];
            vc.WhatIsBinding = 2;
            UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navc animated:YES completion:nil];
//            AttachSuccessVC *vc = [[AttachSuccessVC alloc] init];
//            [self presentViewController:vc animated:YES completion:nil];
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
        
        bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
        vc.WhatIsBinding = 0;
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navc animated:YES completion:nil];
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

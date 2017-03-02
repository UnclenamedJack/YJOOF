//
//  QRCodeVC.m
//  ProjectOne-weibao
//
//  Created by jack on 17/2/27.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "QRCodeVC.h"
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

@interface QRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate >
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

@implementation QRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_big"] style:UIBarButtonItemStylePlain target:self action:@selector(closeBarButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"亮光"] style:UIBarButtonItemStylePlain target:self action:@selector(flashLight:)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor hexChangeFloat:@"ffffff"]];
    self.LightIsON = NO;
    self.navigationItem.title = @"扫描二维码";
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.view setUserInteractionEnabled:YES];
    
    
    
//    UIButton *flash = [UIButton buttonWithType:UIButtonTypeCustom];
//    [flash setImage:[UIImage imageNamed:@"shanguangdeng"] forState:UIControlStateNormal];
//    [self.view addSubview:flash];
//    [flash mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(64+ 30);
//        make.right.equalTo(threePoint.mas_left).offset(-10);
//    }];
//    [flash addTarget:self action:@selector(flashLight:) forControlEvents:UIControlEventTouchUpInside];
    
    
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

    // Do any additional setup after loading the view.
}
- (void)changeInamation{
    [self.inamationView setFrame:CGRectOffset(self.inamationView.frame, 0, 2)];
    //    self.inamationView.frame = CGRectOffset(self.inamationView.frame, 0, 2);
    if (self.inamationView.frame.origin.y >= self.kuang.frame.size.height) {
        self.inamationView.frame = CGRectOffset(self.inamationView.bounds, 0, -self.inamationView.frame.size.height);
    }
}
- (void)closeBarButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
    //    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)flashLight:(id)sender {
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
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isCodeSuccess"];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"deviceNum"];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

//        if ([self.navigationController.presentingViewController isMemberOfClass:[IndexVC class]] || [self.navigationController.childViewControllers.firstObject isMemberOfClass:[bindingOrHistroyBindViewController class]]){
//#if DEBUG
//            NSLog(@"<><><>绑定插座扫描");
//#endif
////            [self checkBindingOrNot:str];
//            
//            //            AttachVC *vc = [[AttachVC alloc] init];
//            //            vc.mac = str;
//            //            [self presentViewController:vc animated:YES completion:nil];
//        }else{
//#if DEBUG
//            NSLog(@"<><><>app扫描");
//#endif
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isCodeSuccess"];
//            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"deviceNum"];
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        }
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

#pragma AVCapture
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    id object = metadataObjects.firstObject;
    if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)object;
        
        [self performSelectorOnMainThread:@selector(result:) withObject:obj.stringValue waitUntilDone:NO];
    }
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

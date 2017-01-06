//
//  saomiaoVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "saomiaoVC.h"
#import "Masonry.h"
#import "QRcodeViewController.h"
#import "AttachVC.h"
#import "IndexVC.h"

@interface saomiaoVC ()

@end

@implementation saomiaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-30);
        make.height.equalTo(@100);
        make.width.equalTo(btn.mas_height);
    }];
    [btn addTarget:self action:@selector(saomiao:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lable = [[UILabel alloc] init];
    [lable setText:@"扫描（插座/资产）二维码"];
    [lable setFont:[UIFont systemFontOfSize:13.0]];
    [self.view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(btn.mas_bottom).offset(15);
    }];
    // Do any additional setup after loading the view.
}
- (void)saomiao:(UIButton *)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    QRcodeViewController *vc = [board instantiateViewControllerWithIdentifier:@"QRcode"];
    NSLog(@"<>%@",self.navigationController.viewControllers);
    if ([self.identifier isEqualToString:@"IndexVC"]) {
        vc.identifier = 0;
    }else if ([self.identifier isEqualToString:@"bindingVC"]){
        vc.identifier = 1;
        vc.secondMac = self.mac;
    }else{
        
    }
    
//    if ([self.presentingViewController isMemberOfClass:[IndexVC class]]) {
//        vc.identifier = 0;
//    }else if ([self.presentingViewController isMemberOfClass:[AttachVC class]]){
//        vc.identifier = 1;
//        vc.secondMac = self.mac;
//    }
    [self presentViewController:vc animated:YES completion:nil];
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

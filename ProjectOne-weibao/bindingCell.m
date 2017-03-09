//
//  bindingCell.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "bindingCell.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "searchModel.h"
#import "binddingModel.h"
#import "chapaiModel.h"
#import "Header.h"
#import "UIColor+Extend.h"
#import "UIButton+btnAction.h"

@interface bindingCell ()
@property(nonatomic,strong)UIWindow *DIYWindow;
@property(nonatomic,strong)UIView *backView;
@end

@implementation bindingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.contentView setBackgroundColor:[UIColor clearColor]];
//        self.label1 = [[UILabel alloc] init];
//        [_label1 setTextAlignment:NSTextAlignmentCenter];
////        [_label1 setText:@"label1"];
//        [_label1 setNumberOfLines:2];
//        [self.contentView addSubview:_label1];
//        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(5);
//            make.centerY.equalTo(self.contentView);
//        }];
//        
//        self.label2 = [[UILabel alloc] init];
//        [_label2 setTextAlignment:NSTextAlignmentCenter];
////        [_label2 setText:@"label2"];
//        [_label2 setNumberOfLines:2];
//        [self.contentView addSubview:_label2];
//        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.width.equalTo(_label1);
//            make.left.equalTo(_label1.mas_right).offset(10);
//        }];
//        
//        self.label3 = [[UILabel alloc] init];
//        [_label3 setTextAlignment:NSTextAlignmentCenter];
////        [_label3 setText:@"label3"];
//        [_label3 setNumberOfLines:2];
//        [self.contentView addSubview:_label3];
//        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.width.equalTo(_label2);
//            make.left.equalTo(_label2.mas_right).offset(10);
//        }];
//        
//        self.label4 = [[UILabel alloc] init];
//        [_label4 setTextAlignment:NSTextAlignmentCenter];
////        [_label4 setText:@"label4"];
//        [_label4 setNumberOfLines:2];
//        [self.contentView addSubview:_label4];
//        [_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.width.equalTo(_label3);
//            make.left.equalTo(_label3.mas_right).offset(10);
//        }];
//        
//        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btn.layer setBorderColor:[UIColor blackColor].CGColor];
//        [_btn.layer setBorderWidth:1.0];
//        [_btn.layer setCornerRadius:3.0];
//        [_btn setTag:0];
//        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_btn setTitle:@"解绑" forState:UIControlStateNormal];
//        [_btn.layer setCornerRadius:3.0];
//        [self.contentView addSubview:_btn];
//        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.width.equalTo(_label4);
//            make.left.equalTo(_label4.mas_right).offset(10);
//            make.right.equalTo(self.contentView).offset(-5);
//        }];
//        [_btn addTarget:self action:@selector(cancelBinding:) forControlEvents:UIControlEventTouchUpInside];
        
        self.label1 = [[UILabel alloc] init];
//        [_label1 setText:@"label1"];
        if(ScreenHeight == 480.0){
            [_label1 setFont:[UIFont systemFontOfSize:11.0]];
        }else if (ScreenHeight==568) {
            [_label1 setFont:[UIFont systemFontOfSize:12.0]];
        }else if (ScreenHeight == 667){
            [_label1 setFont:[UIFont systemFontOfSize:13.0]];
        }else{
            [_label1 setFont:[UIFont systemFontOfSize:14.0]];
        }
        [self.label1 setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_label1];
        
        self.label2 = [[UILabel alloc] init];
//        [_label2 setText:@"label2"];
        [self.label2 setTextAlignment:NSTextAlignmentLeft];
        if(ScreenHeight == 480.0){
            [_label2 setFont:[UIFont systemFontOfSize:9.0]];
        }else if (ScreenHeight==568) {
            [_label2 setFont:[UIFont systemFontOfSize:10.0]];
        }else if (ScreenHeight == 667){
            [_label2 setFont:[UIFont systemFontOfSize:11.0]];
        }else{
            [_label2 setFont:[UIFont systemFontOfSize:12.0]];
        }
//        [_label2 setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:_label2];
        
        self.label3 = [[UILabel alloc] init];
//        [_label3 setText:@"label3"];
        if(ScreenHeight == 480.0){
            [_label3 setFont:[UIFont systemFontOfSize:10.0]];
        }else if (ScreenHeight==568) {
            [_label3 setFont:[UIFont systemFontOfSize:12.0]];
        }else if (ScreenHeight == 667){
            [_label3 setFont:[UIFont systemFontOfSize:13.0]];
        }else{
            [_label3 setFont:[UIFont systemFontOfSize:14.0]];
        }
        [self.label3 setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_label3];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"解绑" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor hexChangeFloat:@"0a88e7"] forState:UIControlStateNormal];
        [_btn.layer setBorderColor:[UIColor hexChangeFloat:@"0a88e7"].CGColor];
        [_btn.layer setBorderWidth:1.0];
        [_btn.layer setCornerRadius:5.0];
        [self.contentView addSubview:_btn];
        [_btn addTarget:self action:@selector(cancelBinding:) forControlEvents:UIControlEventTouchUpInside];
        [_btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15*ScreenWidth/414.0);
            make.top.equalTo(self.contentView).offset(5*ScreenHeight/736.0);
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
        
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label1.mas_bottom);
            make.left.equalTo(_label1);
            make.bottom.lessThanOrEqualTo(self.contentView);
        }];
        
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15*ScreenWidth/414.0);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@(90*ScreenWidth/414.0));
        }];
        
        
        
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(_label1);
            make.right.lessThanOrEqualTo(_btn.mas_left).offset(-25*ScreenWidth/414.0);
            make.center.equalTo(self.contentView);
        }];
        
        
        
    }
    return self;
}
- (void)touchDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"0a88e7"]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"ffffff"] forState:UIControlStateNormal];
}
- (void)DIYDismiss {
    [self.DIYWindow resignKeyWindow];
    [self.backView removeFromSuperview];
    self.DIYWindow = nil;
}
- (UIView *)DIYAlert {
    self.DIYWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_DIYWindow makeKeyAndVisible];
    [_DIYWindow setWindowLevel:UIWindowLevelAlert];
    
    self.backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_backView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    [_DIYWindow addSubview:_backView];
    
    UIView *DIYView = [[UIView alloc] init];
    [DIYView setBackgroundColor:[UIColor whiteColor]];
    [DIYView.layer setCornerRadius:10.0];
    [_backView addSubview:DIYView];
    [DIYView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_backView);
        make.left.equalTo(_backView).offset(40*ScreenWidth/414.0);
        make.right.equalTo(_backView).offset(-40*ScreenWidth/414.0);
        make.height.equalTo(@200);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    if(ScreenHeight == 480.0){
        [titleL setFont:[UIFont systemFontOfSize:17.0]];
    }else if (ScreenHeight==568) {
        [titleL setFont:[UIFont systemFontOfSize:18.0]];
    }else if (ScreenHeight == 667){
        [titleL setFont:[UIFont systemFontOfSize:19.0]];
    }else{
        [titleL setFont:[UIFont systemFontOfSize:20.0]];
    }
    [titleL setText:@"现在解除绑定？"];
    [titleL setTextColor:[UIColor hexChangeFloat:@"00a8e7"]];
    [DIYView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(DIYView);
        make.top.equalTo(DIYView).offset(30*ScreenHeight/736.0);
    }];
    
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setTitleColor:[UIColor hexChangeFloat:@"00a8e7"] forState:UIControlStateNormal];
//    [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [leftBtn.layer setBorderColor:[UIColor hexChangeFloat:@"00a8e7"].CGColor];
//    [leftBtn.layer setBorderWidth:1.0];
//    [leftBtn.layer setCornerRadius:3.0];
//    [DIYView addSubview:leftBtn];
//    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(DIYView).offset(30);
//        make.bottom.equalTo(DIYView).offset(-30);
//        make.width.equalTo(@(70*ScreenWidth/520.0));
//    }];
//    [leftBtn addTarget:self action:@selector(yesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setTitleColor:[UIColor hexChangeFloat:@"00a8e7"] forState:UIControlStateNormal];
//    [rightBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [rightBtn.layer setBorderColor:[UIColor hexChangeFloat:@"00a8e7"].CGColor];
//    [rightBtn.layer setBorderWidth:1.0];
//    [rightBtn.layer setCornerRadius:3.0];
//    [DIYView addSubview:rightBtn];
//    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(DIYView).offset(-30);
//        make.bottom.equalTo(DIYView).offset(-30);
//        make.width.equalTo(@(70*ScreenWidth/520.0));
//    }];
//    [rightBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [DIYView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [DIYView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [DIYView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [DIYView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];

    
    return DIYView;
}
- (void)yesBtnClick:(UIButton *)sedner {
    [self DIYDismiss];
    
}
- (void)cancelClick:(UIButton *)sender {
    [self DIYDismiss];
    return;
}
- (void)getData {
    
}
- (void)cancelBinding:(UIButton *)sender {
    
    if (sender.tag == 0) {
        UIView *diyView = [self DIYAlert];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitleColor:[UIColor hexChangeFloat:@"00a8e7"] forState:UIControlStateNormal];
        [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
        [leftBtn.layer setBorderColor:[UIColor hexChangeFloat:@"00a8e7"].CGColor];
        [leftBtn.layer setBorderWidth:1.0];
        [leftBtn.layer setCornerRadius:3.0];
        [diyView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(diyView).offset(30);
            make.bottom.equalTo(diyView).offset(-30);
            make.width.equalTo(@(70*ScreenWidth/414.0));
        }];
//        [leftBtn addTarget:self action:@selector(yesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn addAction:^(UIButton *btn) {
            [self DIYDismiss];
            NSString *url;
            NSDictionary *parameters;
            NSString *HUDStr;
            id model;
            if (self.hubid) {
                if (self.model) {
                    parameters = @{@"hubid":self.hubid,@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                    model = self.model;
                }else if (self.model1){
                    parameters = @{@"hubid":self.hubid,@"bdmachineid":_model1.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                    model = self.model1;
                }else if (self.model2){
                    parameters = @{@"hubid":self.hubid,@"bdmachineid":_model2.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                    model = self.model2;
                }else{
                    return;
                }
                
                if (sender.tag == 0) {
                    url = JIECHUCHAPAICHAKONGBANDDING;
                    HUDStr = @"正在解绑";
                    //        parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                }else{
                    url = CHAPAICHAKONGBANDDING;
                    HUDStr = @"正在绑定";
                    //        parameters =  @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                }
                
            }else{
                if (self.model) {
                    parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                    model = self.model;
                }else if (self.model1){
                    parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdmachineid":_model1.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                    model = self.model1;
                }else if (self.model2){
                    parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdmachineid":_model2.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                    model = self.model2;
                }else {
                    return;
                }
                
                if (sender.tag == 0) {
                    url = JIECHUBANGDING;
                    HUDStr = @"正在解绑";
                    //        parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                }else{
                    url = CHAZUOBANGDING;
                    HUDStr = @"正在绑定";
                    //        parameters =  @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
                }
                
            }
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //    NSDictionary *parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            hud.bezelView.color = [UIColor colorWithRed:113/255.0 green:112/255.0 blue:113/255.0 alpha:1.0];
            [hud.label setTextColor:[UIColor whiteColor]];
            [hud.label setText:HUDStr];
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
                NSLog(@"网路连接成功！");
                NSLog(@"%@",responseObject);
#endif
                if ([responseObject[@"result"] intValue] == 1) {
                    [hud hideAnimated:YES];
                    if (self.cancelBlock) {
                        self.cancelBlock(sender,model);
                    }
                }else{
                    [hud setMode:MBProgressHUDModeCustomView];
                    hud.bezelView.color = [UIColor colorWithRed:113/255.0 green:112/255.0 blue:113/255.0 alpha:1.0];
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dacha"]];
                    [hud.label setTextColor:[UIColor whiteColor]];
                    [hud.label setText:responseObject[@"msg"]];
                    [hud hideAnimated:YES afterDelay:1.5];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
                NSLog(@"网络连接失败！");
                NSLog(@"%@",error);
#endif
                [hud setMode:MBProgressHUDModeCustomView];
                hud.bezelView.color = [UIColor colorWithRed:113/255.0 green:112/255.0 blue:113/255.0 alpha:1.0];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dacha"]];
                [hud.label setTextColor:[UIColor whiteColor]];
                [hud.label setText:@"网络不好"];
                [hud hideAnimated:YES afterDelay:1.5];
            }];

        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:[UIColor hexChangeFloat:@"00a8e7"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"返回" forState:UIControlStateNormal];
        [rightBtn.layer setBorderColor:[UIColor hexChangeFloat:@"00a8e7"].CGColor];
        [rightBtn.layer setBorderWidth:1.0];
        [rightBtn.layer setCornerRadius:3.0];
        [diyView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(diyView).offset(-30);
            make.bottom.equalTo(diyView).offset(-30);
            make.width.equalTo(@(70*ScreenWidth/414.0));
        }];
        [rightBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];

        return;
    }
    
    NSString *url;
    NSDictionary *parameters;
    NSString *HUDStr;
    id model;
    if (self.hubid) {
        if (self.model) {
            parameters = @{@"hubid":self.hubid,@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            model = self.model;
        }else if (self.model1){
            parameters = @{@"hubid":self.hubid,@"bdmachineid":_model1.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            model = self.model1;
        }else if (self.model2){
            parameters = @{@"hubid":self.hubid,@"bdmachineid":_model2.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            model = self.model2;
        }else{
            return;
        }
        
        if (sender.tag == 0) {
            url = JIECHUCHAPAICHAKONGBANDDING;
            HUDStr = @"正在解绑";
            //        parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else{
            url = CHAPAICHAKONGBANDDING;
            HUDStr = @"正在绑定";
            //        parameters =  @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }
        
    }else{
        if (self.model) {
            parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            model = self.model;
        }else if (self.model1){
            parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdmachineid":_model1.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            model = self.model1;
        }else if (self.model2){
            parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdmachineid":_model2.machineid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
            model = self.model2;
        }else {
            return;
        }
        
        if (sender.tag == 0) {
            url = JIECHUBANGDING;
            HUDStr = @"正在解绑";
            //        parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else{
            url = CHAZUOBANGDING;
            HUDStr = @"正在绑定";
            //        parameters =  @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }
        
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    NSDictionary *parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.bezelView.color = [UIColor colorWithRed:113/255.0 green:112/255.0 blue:113/255.0 alpha:1.0];
    [hud.label setTextColor:[UIColor whiteColor]];
    [hud.label setText:HUDStr];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        if ([responseObject[@"result"] intValue] == 1) {
            [hud hideAnimated:YES];
            if (self.cancelBlock) {
                self.cancelBlock(sender,model);
            }
        }else{
            [hud setMode:MBProgressHUDModeCustomView];
            hud.bezelView.color = [UIColor colorWithRed:113/255.0 green:112/255.0 blue:113/255.0 alpha:1.0];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dacha"]];
            [hud.label setTextColor:[UIColor whiteColor]];
            [hud.label setText:responseObject[@"msg"]];
            [hud hideAnimated:YES afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
#endif
        [hud setMode:MBProgressHUDModeCustomView];
        hud.bezelView.color = [UIColor colorWithRed:113/255.0 green:112/255.0 blue:113/255.0 alpha:1.0];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dacha"]];
        [hud.label setTextColor:[UIColor whiteColor]];
        [hud.label setText:@"网络不好"];
        [hud hideAnimated:YES afterDelay:1.5];
    }];

    
}

- (void)setModel:(searchModel *)modle {
    if (_model != modle) {
        _model = modle;
        _label1.text = modle.num;
        _label2.text = modle.device;
        _label3.text = modle.room;
//        _label4.text = modle.college;
    }
}
- (void)setModel1:(binddingModel *)model1 {
    if (_model1 != model1) {
        _model1 = model1;
        _label1.text = model1.num;
        _label2.text = model1.device;
        _label3.text = model1.room;
//        _label4.text = model1.room;
    }
}
- (void)setModel2:(chapaiModel *)model2 {
    if (_model2 != model2) {
        _model2 = model2;
        _label1.text = [NSString stringWithFormat:@"MAC:%@",model2.macDress];
        _label2.text = model2.name;
        [_label3 setHidden:YES];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

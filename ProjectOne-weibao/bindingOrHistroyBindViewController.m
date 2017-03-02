//
//  bindingOrHistroyBindViewController.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "bindingOrHistroyBindViewController.h"
#import "AFNetworking.h"
#import "Header.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "bindingCell.h"
//#import "AttachVC.h"
#import "searchVC.h"
#import "IndexVC.h"
#import "saomiaoVC.h"
#import "chapaiModel.h"
#import "searchModel.h"
#import "binddingModel.h"
#import "QRcodeViewController.h"
#import "UIColor+Extend.h"

@interface bindingOrHistroyBindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *noBinding;
@property(nonatomic, strong)UIImageView *topView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *historyData;
@property(nonatomic, strong)NSArray *hadBindingData;
@end

@implementation bindingOrHistroyBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"插座信息";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_big"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定" style:UIBarButtonItemStylePlain target:self action:@selector(binding:)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor hexChangeFloat:@"ffffff"]];
    [self.view setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]];
    
    
    if (self.type == ChaZuo ) {
        self.topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chazuo"]];
    }else if (self.type == ChaPaiChaKong){
        self.topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chapai"]];
    }else{
        return;
    }
    
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.2);
    }];
    
    UILabel *macDress = [[UILabel alloc] init];
    if (_mac) {
        [macDress setText:[NSString stringWithFormat:@"MAC:%@",_mac]];
    }else{
        [macDress setText:@"MAC:5c:cf:7f:0a:11:d3:"];
    }
    [macDress setTextColor:[UIColor whiteColor]];
    [macDress setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_topView addSubview:macDress];
    [macDress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView);
        make.centerY.equalTo(_topView).offset(-15);
        make.left.equalTo(_topView).offset(25);
    }];
    
    UILabel *macName = [[UILabel alloc] init];
    if(self.name){
        [macName setText:_name];
    }else{
        [macName setText:@"86型智能插座"];
    }
    [macName setTextColor:[UIColor whiteColor]];
    [macName setFont:[UIFont boldSystemFontOfSize:13.0]];
    [_topView addSubview:macName];
    [macName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView);
        make.top.equalTo(macDress.mas_bottom).offset(8);
        make.left.equalTo(macDress);
    }];
    
//     [self creatCellOrNot];
    
    if (self.WhatIsBinding == 0) {
        self.noBinding = [[UILabel alloc] init];
        [_noBinding setTextColor:[UIColor colorWithRed:202/255.0 green:203/255.0 blue:204/255.0 alpha:1.0]];
        [_noBinding setText:@"暂无绑定"];
        [_noBinding setFont:[UIFont boldSystemFontOfSize:25.0]];
        [self.view addSubview:_noBinding];
        [_noBinding mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).offset(10);
            make.centerY.equalTo(self.view).offset(30);
        }];
         UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jintanhao"]];
        [self.view addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_noBinding);
            make.right.equalTo(_noBinding.mas_left).offset(-5);
            make.height.equalTo(_noBinding);
            make.height.equalTo(img.mas_width);
        }];
    }else{
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
//        [tableView setSectionHeaderHeight:40];
//        [tableView setSectionFooterHeight:0];
        [tableView setSectionHeaderHeight:0];
        [tableView setSectionFooterHeight:0];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom).offset(10);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        self.tableView = tableView;
        NSMutableArray *arr = [NSMutableArray array];
        if (self.model) {
            [arr addObject:self.model];
            self.hadBindingData = arr;
        }else if(self.model1){
            [arr addObject:self.model1];
            self.hadBindingData = arr;
        }else if(self.model2){
            [arr addObject:self.model2];
            self.hadBindingData = arr;
        }
        
        if (self.hbdArr){
            self.historyData = self.hbdArr;
        }

    }
    
    
//    if(self.WhatIsBinding){
//        self.label = [[UILabel alloc] init];
//        if (_WhatIsBinding == 1) {
//            [_label setText:@"已绑定资产"];
//        }else if (_WhatIsBinding == 2){
//            [_label setText:@"已绑定插排"];
//        }
//        [self.view addSubview:_label];
//        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_topView.mas_bottom);
//            make.left.equalTo(self.view).offset(5);
//        }];
//        bindingCell *cell = [[bindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        if (self.model) {
//            cell.model = self.model;
//        }else if (self.model1){
//            cell.model1 = self.model1;
//        }
//        [self.view addSubview:cell];
//        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_label.mas_bottom).offset(5);
//            make.left.equalTo(self.view).offset(5);
//            make.right.equalTo(self.view).offset(-5);
//            make.height.equalTo(@40);
//        }];
//        
////        UIButton *bindingNew = [UIButton buttonWithType:UIButtonTypeCustom];
////        [bindingNew setTitle:@"绑定新资产" forState:UIControlStateNormal];
////        [bindingNew setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [bindingNew.layer setCornerRadius:3.0];
////        [bindingNew.layer setBorderColor:[UIColor blackColor].CGColor];
////        [bindingNew.layer setBorderWidth:1.0];
////        [self.view addSubview:bindingNew];
////        [bindingNew mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.centerX.equalTo(self.view);
////            make.bottom.equalTo(self.view).offset(-50);
////            make.width.equalTo(self.view).multipliedBy(0.35);
////        }];
////        [bindingNew setEnabled:NO];
////        [bindingNew addTarget:self action:@selector(bindNewDevice:) forControlEvents:UIControlEventTouchUpInside];
//        __weak typeof(bindingCell) *weakcell = cell;
//        cell.cancelBlock = ^(UIButton *sender){
//            if (sender.tag == 0) {
//                if (_WhatIsBinding == 1) {
//                    _label.text = @"历史绑定资产";
//                }else if (_WhatIsBinding == 2){
//                    _label.text = @"历史绑定插排";
//                }
//                self.WhatIsBinding = 0;
////                [bindingNew setEnabled:YES];
//                [weakcell.btn setTitle:@"绑定" forState:UIControlStateNormal];
//                sender.tag = 1;
//            }else{
//                if (_WhatIsBinding == 1) {
//                    _label.text = @"已绑定资产";
//                }else if (_WhatIsBinding == 2){
//                    _label.text = @"已绑定插排";
//                }
//                self.WhatIsBinding = 1;
////                [bindingNew setEnabled:NO];
//                [weakcell.btn setTitle:@"解绑" forState:UIControlStateNormal];
//                sender.tag = 0;
//            }
//        };
//    }else{
//        self.noBinding = [[UILabel alloc] init];
//        [_noBinding setText:@"暂无绑定"];
//        [_noBinding setFont:[UIFont boldSystemFontOfSize:25.0]];
//        [self.view addSubview:_noBinding];
//        [_noBinding mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.centerY.equalTo(self.view).offset(30);
//        }];
//    }
   
   
    
    // Do any additional setup after loading the view.
}
- (void)creatCellOrNot {
    if(self.WhatIsBinding){
        self.label = [[UILabel alloc] init];
        if (_WhatIsBinding == 1) {
            [_label setText:@"已绑定资产"];
        }else if (_WhatIsBinding == 2){
            [_label setText:@"已绑定插排"];
        }
        [self.view addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom);
            make.left.equalTo(self.view).offset(5);
        }];
        bindingCell *cell = [[bindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (self.model) {
            cell.model = self.model;
        }else if (self.model1){
            cell.model1 = self.model1;
        }
        [self.view addSubview:cell];
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label.mas_bottom).offset(5);
            make.left.equalTo(self.view).offset(5);
            make.right.equalTo(self.view).offset(-5);
            make.height.equalTo(@40);
        }];
        
        __weak typeof(bindingCell) *weakcell = cell;
        cell.cancelBlock = ^(UIButton *sender,id model){
            if (sender.tag == 0) {
                if (_WhatIsBinding == 1) {
                    _label.text = @"历史绑定资产";
                    self.WhatIsBinding = -1;
                }else if (_WhatIsBinding == 2){
                    _label.text = @"历史绑定插排";
                    self.WhatIsBinding = -2;
                }
                
                weakcell.model = nil;
                weakcell.textLabel.text = @"暂无绑定数据";
                [weakcell.btn setHidden:YES];
//                [weakcell.btn setTitle:@"绑定" forState:UIControlStateNormal];
                NSMutableArray *mutArr = [NSMutableArray array];
                [mutArr addObject:self.model];
                self.historyData = mutArr;
                [self.tableView reloadData];
                sender.tag = 1;
            }else{
                if (_WhatIsBinding == -1) {
                    _label.text = @"已绑定资产";
                    self.WhatIsBinding = 1;

                }else if (_WhatIsBinding == -2){
                    _label.text = @"已绑定插排";
                    self.WhatIsBinding = 2;
                }
                //                [bindingNew setEnabled:NO];
                
                [weakcell.btn setTitle:@"解绑" forState:UIControlStateNormal];
                sender.tag = 0;
            }
        };
    }else{
        self.noBinding = [[UILabel alloc] init];
        [_noBinding setText:@"暂无绑定"];
        [_noBinding setFont:[UIFont boldSystemFontOfSize:25.0]];
        [self.view addSubview:_noBinding];
        [_noBinding mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(30);
        }];
    }
}
- (void)back:(UIBarButtonItem *)sender {
    if (self.type == ChaZuo) {
        IndexVC *vc = [[IndexVC alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (self.type == ChaPaiChaKong){
        if (self.relaodCollectonBlock) {
            NSMutableArray *hbdArr = [NSMutableArray array];
                for (id model in self.historyData) {
                    if ([model isKindOfClass:[searchModel class]]) {
                        NSDictionary *hbdDict = @{@"address":[model valueForKey:@"room"],@"assetid":[model valueForKey:@"assetid"],@"deptname":[model valueForKey:@"college"],@"name":[model valueForKey:@"device"],@"num":[model valueForKey:@"num"]};
                        [hbdArr addObject:hbdDict];
                    }else if ([model isKindOfClass:[binddingModel class]]){
                        NSDictionary *hbdDict = @{@"address":[model valueForKey:@"room"],@"assetid":[model valueForKey:@"assetid"],@"deptname":[model valueForKey:@"college"],@"name":[model valueForKey:@"device"],@"num":[model valueForKey:@"num"]};
                        [hbdArr addObject:hbdDict];
                    }else{//chapaimodel
                        
                    }
                }
            
            NSDictionary *dict;
            if (self.hadBindingData.count == 0) {
                if (hbdArr.count == 0) {
                      dict = @{@"hubid":self.hubs[@"hubid"],@"mac":self.hubs[@"mac"],@"num":self.hubs[@"num"]};
                }else{
                     dict = @{@"hbdassetList":hbdArr,@"hubid":self.hubs[@"hubid"],@"mac":self.hubs[@"mac"],@"num":self.hubs[@"num"]};
                }
              
            }else{
                NSDictionary *bdDict;
                id model = self.hadBindingData[0];
                if ([model isKindOfClass:[searchModel class]]){
                    bdDict = @{@"address":[model valueForKey:@"room"],@"assetid":[model valueForKey:@"assetid"],@"deptname":[model valueForKey:@"college"],@"name":[model valueForKey:@"device"],@"num":[model valueForKey:@"num"]};
                }else if ([model isKindOfClass:[binddingModel class]]){
                    bdDict = @{@"address":[model valueForKey:@"room"],@"assetid":[model valueForKey:@"assetid"],@"deptname":[model valueForKey:@"college"],@"name":[model valueForKey:@"device"],@"num":[model valueForKey:@"num"]};
                }else{
                    bdDict = @{@"注意":@"注意"};
                }
                if (hbdArr.count == 0) {
                    dict = @{@"bdasset":bdDict,@"hubid":self.hubs[@"hubid"],@"mac":self.hubs[@"mac"],@"num":self.hubs[@"num"]};

                }else{
                    dict = @{@"bdasset":bdDict,@"hbdassetList":hbdArr,@"hubid":self.hubs[@"hubid"],@"mac":self.hubs[@"mac"],@"num":self.hubs[@"num"]};
                }
            }
            self.relaodCollectonBlock(dict,self.row);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        return;
    }
    
}
- (void)binding:(UIBarButtonItem *)sender {
    if (self.hadBindingData.count > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.bezelView.color = [UIColor blackColor];
        [hud setMode:MBProgressHUDModeCustomView];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jintanhao-1"]];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud.label setText:@"请先解绑"];
        [hud.label setTextColor:[UIColor whiteColor]];
        [hud hideAnimated:YES afterDelay:1.5];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"绑定插排" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            saomiaoVC *vc = [[saomiaoVC alloc] init];
//            vc.identifier = @"bindingVC";
//            vc.mac = self.mac;
//            [self.navigationController pushViewController:vc animated:YES];
            
            QRcodeViewController *vc = [[QRcodeViewController alloc] init];
            vc.identifier = 1;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"绑定资产" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            searchVC *vc = [[searchVC alloc] init];
            vc.block = ^(NSString *num,searchModel *model){
                self.WhatIsBinding = 1;
                self.model = model;
//                [self creatCellOrNot];
                if (_noBinding) {
                    [_noBinding removeFromSuperview];
                }
                if (self.tableView) {
                    NSMutableArray *mutArr = [NSMutableArray array];
                    [mutArr addObject:model];
                    self.hadBindingData = mutArr;
                    [self.tableView reloadData];
                }else{
                    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
                    [tableView setDelegate:self];
                    [tableView setDataSource:self];
                    [tableView setSectionHeaderHeight:0];
                    [tableView setSectionFooterHeight:0];
//                    [tableView setSectionHeaderHeight:40];
//                    [tableView setSectionFooterHeight:0];
                    [self.view addSubview:tableView];
                    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(_topView.mas_bottom).offset(10);
                        make.left.equalTo(self.view);
                        make.right.equalTo(self.view);
                        make.bottom.equalTo(self.view);
                    }];
                    self.tableView = tableView;
                }
                NSMutableArray *arr = [NSMutableArray array];
                if (self.model) {
                    [arr addObject:self.model];
                    self.hadBindingData = arr;
                }else if (self.model1){
                    [arr addObject:self.model1];
                    self.hadBindingData = arr;
                }
            };
            if (self.hubs) {
                vc.hubid = self.hubs[@"hubid"];
            }
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            [backItem setTitle:@""];
            self.navigationItem.backBarButtonItem = backItem;
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark --------------------UITableViewDelegate AND UITableViewDatasource---------------------- 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if (section == 0) {
            return 1;
        }else{
            return self.historyData.count;
        }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *view ;
//    if (section == 0) {
//        view = [[UIView alloc] init];
//        UILabel *label = [[UILabel alloc] init];
//        [view setBackgroundColor:[UIColor redColor]];
//        [view addSubview:label];
//        [label setText:@"已绑定的资产"];
//        [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(view);
//            //        make.top.equalTo(view);
//            //        make.bottom.equalTo(view);
//            make.center.equalTo(view);
//        }];
//    }else if(section == 1){
//        view = [[UIView alloc] init];
//        UILabel *label = [[UILabel alloc] init];
//        [view addSubview:label];
//        [label setText:@"历史绑定"];
//        [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(view);
//            //        make.top.equalTo(view);
//            //        make.bottom.equalTo(view);
//            make.center.equalTo(view);
//        }];
//    }
//
    UIView *view ;
    switch (_WhatIsBinding) {
        case 1:
            if (section == 0) {
                view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view addSubview:label];
                [label setText:@"已绑定的资产"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }else if(section == 1){
                view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view addSubview:label];
                [label setText:@"历史绑定"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }
            break;
        case 2:
            if (section == 0) {
                view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view addSubview:label];
                [label setText:@"已绑定的插排"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }else if(section == 1){
                UIView *view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view addSubview:label];
                [label setText:@"历史绑定"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }
            break;
        case 3:
            if (section == 1) {
                view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view addSubview:label];
                [label setText:@"历史绑定"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }else{
                return nil;
            }
            break;
        case -4:
            if (section == 0) {
                view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view setBackgroundColor:[UIColor orangeColor]];
                [view addSubview:label];
                [label setText:@"已绑定的插座"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }else if(section == 1){
                UIView *view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view addSubview:label];
                [label setText:@"历史绑定"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }
            break;
        case -1:
            if (section == 1) {
                view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view addSubview:label];
                [label setText:@"历史绑定"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }else{
                return nil;
            }
            break;
        case -2:
            if (section == 1) {
                view = [[UIView alloc] init];
                UILabel *label = [[UILabel alloc] init];
                [view addSubview:label];
                [label setText:@"历史绑定"];
                [label setTextColor:[UIColor hexChangeFloat:@"0a88e7"]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    //        make.top.equalTo(view);
                    //        make.bottom.equalTo(view);
                    make.center.equalTo(view);
                }];
            }else{
                return nil;
            }
            break;
        default:
            return nil;
            break;
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    }else{
//        return 20;
//    }
//    if (self.WhatIsBinding == 1 || self.WhatIsBinding == 2) {
//        return 40;
//    }else{
//        if (section == 0) {
//            return 0.0;
//        }else{
//            return 40;
//        }
//    }
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"bindingCell";
    bindingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[bindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    if(self.hubs){
        cell.hubid = self.hubs[@"hubid"];
    }
    
    __weak typeof(bindingCell) *weakcell = cell;
    cell.cancelBlock = ^(UIButton *sender,id model){
        if (sender.tag == 0) {
            if (_WhatIsBinding == 1) {
//                _label.text = @"历史绑定资产";
                self.WhatIsBinding = -1;
            }else if (_WhatIsBinding == 2){
//                _label.text = @"历史绑定插排";
                self.WhatIsBinding = -2;
            }else{
                return ;
            }
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:self.hadBindingData];
            [arr removeObject:model];
            self.hadBindingData = arr;

            
//            weakcell.model = nil;
//            weakcell.textLabel.text = @"暂无绑定数据";
//            [weakcell.btn setHidden:YES];
            
//            [weakcell.btn setTitle:@"绑定" forState:UIControlStateNormal];
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:self.historyData];
            [mutArr addObject:model];
            self.historyData = mutArr;
            
//            NSMutableArray *arr = [NSMutableArray array];
//            [arr addObjectsFromArray:self.hadBindingData];
//            [arr removeObject:weakcell.model];
//            self.hadBindingData = arr;
//            _WhatIsBinding = 3;
            [self.tableView reloadData];
            sender.tag = 1;
        }else{
//            if (_WhatIsBinding == -1) {
//                _label.text = @"已绑定资产";
//                self.WhatIsBinding = 1;
//                
//            }else if (_WhatIsBinding == -2){
//                _label.text = @"已绑定插排";
//                self.WhatIsBinding = 2;
//            }else{
//                if (weakcell.model2) {
//                    _WhatIsBinding = 2;
//                }else{//cell.model1
//                    _WhatIsBinding = 1;
//                }
//            }
            
            
            if (weakcell.model2) {
                if ([weakcell.model2.type isEqual:@1]) {
                    _WhatIsBinding = -4;
                }else if ([weakcell.model2.type isEqual:@2]){
                    _WhatIsBinding = 2;
                }else{
                    return;
                }
            }else{//cell.model1
                _WhatIsBinding = 1;
            }

            NSMutableArray *mutArr = [NSMutableArray array];
            [mutArr addObject:model];
            self.hadBindingData  = mutArr;
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.historyData];
            [arr removeObject:model];
            self.historyData = arr;
            [self.tableView reloadData];

            [weakcell.btn setTitle:@"解绑" forState:UIControlStateNormal];
            sender.tag = 0;
        }
    };
    if (indexPath.section == 0) {
        if (self.hadBindingData.count == 0) {
            UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [labelBtn setImage:[UIImage imageNamed:@"jintanhao"] forState:UIControlStateNormal];
            [labelBtn setTitle:@"暂无绑定" forState:UIControlStateNormal];
            [labelBtn setTitleColor:[UIColor hexChangeFloat:@"888888"] forState:UIControlStateNormal];
            [cell.contentView addSubview:labelBtn];
            [labelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
            }];
            [weakcell.btn setHidden:YES];
        }else{
            if ([self.hadBindingData[indexPath.row] isKindOfClass:[searchModel class]]) {
                cell.model = self.hadBindingData[indexPath.row];
            }else if ([self.hadBindingData[indexPath.row] isKindOfClass:[binddingModel class]]){
                cell.model1 = self.hadBindingData[indexPath.row];
            }else{
                cell.model2 = self.hadBindingData[indexPath.row];
            }
        }
    }else{
        if ([self.historyData[indexPath.row] isKindOfClass:[searchModel class]]) {
            cell.model = self.historyData[indexPath.row];
        }else if ([self.historyData[indexPath.row] isKindOfClass:[binddingModel class]]){
            cell.model1 = self.historyData[indexPath.row];
        }else{
            cell.model2 = self.historyData[indexPath.row];
        }
//        cell.model = self.historyData[indexPath.row];
        [cell.btn setBackgroundColor:[UIColor hexChangeFloat:@"0a88e7"]];
        [cell.btn setTitleColor:[UIColor hexChangeFloat:@"ffffff"] forState:UIControlStateNormal];
        [cell.btn setTitle:@"绑定" forState:UIControlStateNormal];
        [cell.btn setTag:1];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

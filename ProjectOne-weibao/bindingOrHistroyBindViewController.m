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

@interface bindingOrHistroyBindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *noBinding;
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *historyData;
@property(nonatomic, strong)NSArray *hadBindingData;
@end

@implementation bindingOrHistroyBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"插座信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定" style:UIBarButtonItemStylePlain target:self action:@selector(binding:)];
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    
    self.topView = [[UIView alloc] init];
    [_topView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.25);
    }];
    
    UILabel *macDress = [[UILabel alloc] init];
    if (_mac) {
        [macDress setText:_mac];
    }else{
        [macDress setText:@"MAC:5c:cf:7f:0a:11:d3:"];
    }
    [macDress setFont:[UIFont boldSystemFontOfSize:16.0]];
    [_topView addSubview:macDress];
    [macDress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView);
        make.centerY.equalTo(_topView).offset(-15);
    }];
    
    UILabel *macName = [[UILabel alloc] init];
    if(self.name){
        [macName setText:_name];
    }else{
        [macName setText:@"86型智能插座"];
    }
    [macName setFont:[UIFont boldSystemFontOfSize:16.0]];
    [_topView addSubview:macName];
    [macName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView);
        make.top.equalTo(macDress.mas_bottom).offset(8);
    }];
    
//     [self creatCellOrNot];
    
    if (self.WhatIsBinding == 0) {
        self.noBinding = [[UILabel alloc] init];
        [_noBinding setText:@"暂无绑定"];
        [_noBinding setFont:[UIFont boldSystemFontOfSize:25.0]];
        [self.view addSubview:_noBinding];
        [_noBinding mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(30);
        }];
    }else{
        UITableView *tableView = [[UITableView alloc] init];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
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
        }else if (self.model1){
            [arr addObject:self.model1];
            self.hadBindingData = arr;
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
//- (void)bindNewDevice:(UIButton *)sender {
//    AttachVC *vc = [[AttachVC alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
//}
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
        
        //        UIButton *bindingNew = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [bindingNew setTitle:@"绑定新资产" forState:UIControlStateNormal];
        //        [bindingNew setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [bindingNew.layer setCornerRadius:3.0];
        //        [bindingNew.layer setBorderColor:[UIColor blackColor].CGColor];
        //        [bindingNew.layer setBorderWidth:1.0];
        //        [self.view addSubview:bindingNew];
        //        [bindingNew mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerX.equalTo(self.view);
        //            make.bottom.equalTo(self.view).offset(-50);
        //            make.width.equalTo(self.view).multipliedBy(0.35);
        //        }];
        //        [bindingNew setEnabled:NO];
        //        [bindingNew addTarget:self action:@selector(bindNewDevice:) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(bindingCell) *weakcell = cell;
        cell.cancelBlock = ^(UIButton *sender){
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
    IndexVC *vc = [[IndexVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)binding:(UIBarButtonItem *)sender {
    if (self.WhatIsBinding > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeCustomView];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud.label setText:@"请先进行解绑！"];
        [hud hideAnimated:YES afterDelay:1.5];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"绑定插排" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                [self dismissViewControllerAnimated:YES completion:^{
//                }];
//            }];
            saomiaoVC *vc = [[saomiaoVC alloc] init];
            vc.identifier = @"bindingVC";
            vc.mac = self.mac;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"绑定资产" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            searchVC *vc = [[searchVC alloc] init];
            vc.block = ^(NSString *num,searchModel *model){
//                [_noBinding removeFromSuperview];
//                _label = [[UILabel alloc] init];
//                _label.text = @"已绑定资产";
//                [self.view addSubview:_label];
//                [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(_topView.mas_bottom);
//                    make.left.equalTo(self.view).offset(5);
//                }];
//                bindingCell *cell = [[bindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//                [self.view addSubview:cell];
//                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(_label.mas_bottom).offset(5);
//                    make.left.equalTo(self.view).offset(5);
//                    make.right.equalTo(self.view).offset(-5);
//                    make.height.equalTo(@40);
//                }];
//                cell.model = model;
//                self.WhatIsBinding = 1;
                
                self.WhatIsBinding = 1;
                self.model = model;
//                [self creatCellOrNot];
                if (_noBinding) {
                    [_noBinding removeFromSuperview];
                }
                
                UITableView *tableView = [[UITableView alloc] init];
                [tableView setDelegate:self];
                [tableView setDataSource:self];
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
                }else if (self.model1){
                    [arr addObject:self.model1];
                    self.hadBindingData = arr;
                }
            };
            if (self.hubs) {
                vc.hubid = self.hubs[@"id"];
            }
            [self presentViewController:vc animated:YES completion:nil];
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
    }else if (section == 1){
        return self.historyData.count;
    }else{
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    if (section == 0) {
        [view addSubview:label];
        [label setText:@"已绑定的资产"];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            //        make.top.equalTo(view);
            //        make.bottom.equalTo(view);
            make.center.equalTo(view);
        }];
    }else{
        [view addSubview:label];
        [label setText:@"历史绑定"];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            //        make.top.equalTo(view);
            //        make.bottom.equalTo(view);
            make.center.equalTo(view);
        }];
    }
        return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"bindingCell";
    bindingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[bindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    if(self.hubs){
        cell.hubid = self.hubs[@"id"];
    }
    
    __weak typeof(bindingCell) *weakcell = cell;
    cell.cancelBlock = ^(UIButton *sender){
        if (sender.tag == 0) {
            if (_WhatIsBinding == 1) {
                _label.text = @"历史绑定资产";
                self.WhatIsBinding = -1;
            }else if (_WhatIsBinding == 2){
                _label.text = @"历史绑定插排";
                self.WhatIsBinding = -2;
            }
            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:self.hadBindingData];
            [arr removeObject:weakcell.model];
            self.hadBindingData = arr;

            
//            weakcell.model = nil;
//            weakcell.textLabel.text = @"暂无绑定数据";
//            [weakcell.btn setHidden:YES];
            
            //                [weakcell.btn setTitle:@"绑定" forState:UIControlStateNormal];
            NSMutableArray *mutArr = [NSMutableArray array];
            [mutArr addObject:self.model];
            self.historyData = mutArr;
            
//            NSMutableArray *arr = [NSMutableArray array];
//            [arr addObjectsFromArray:self.hadBindingData];
//            [arr removeObject:weakcell.model];
//            self.hadBindingData = arr;

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
            
            NSMutableArray *mutArr = [NSMutableArray array];
            [mutArr addObject:weakcell.model];
            self.hadBindingData  = mutArr;
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.historyData];
            [arr removeObject:weakcell.model];
            self.historyData = arr;
            [self.tableView reloadData];

            [weakcell.btn setTitle:@"解绑" forState:UIControlStateNormal];
            sender.tag = 0;
        }
    };
    if (indexPath.section == 0) {
        if (self.hadBindingData.count == 0) {
            weakcell.textLabel.text = @"暂无绑定数据";
            [weakcell.btn setHidden:YES];
        }else{
            cell.model = self.hadBindingData[indexPath.row];
        }
    }else{
        cell.model = self.historyData[indexPath.row];
        [cell.btn setTitle:@"绑定" forState:UIControlStateNormal];
        [cell.btn setTag:1];
    }
    
    return cell;
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

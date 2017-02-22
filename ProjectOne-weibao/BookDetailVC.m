
//
//  BookDetailVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/10/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "BookDetailVC.h"
#import "Masonry.h"
#import "Header.h"
#import "ClassRoomVC.h"
#import "AFNetworking.h"
#import "UIColor+Extend.h"
#import "MBProgressHUD.h"



@interface BookDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,strong)NSArray *datas2;
@end

@implementation BookDetailVC

-(NSArray *)datas {
    if (!_datas) {
//        
//        NSString *str1 = [NSString stringWithFormat:@"预约教室：%@",@"信息学院A201"];
//        NSString *str2 = [NSString stringWithFormat:@"预约日期：%@",@"2016-10-19"];
//        NSString *str3 = [NSString stringWithFormat:@"预约时间：%@",@"12:00~12:45"];
//        NSString *str4 = [NSString stringWithFormat:@"预约课时：%@",@"共1节"];
//        _datas = [NSArray arrayWithObjects:str1,str2,str3,str4, nil];
        _datas = self.data;
    }
    return _datas;
}
-(NSArray *)datas2{
    if (!_datas2) {
//        NSString *str1 = [NSString stringWithFormat:@"申请预约时间：%@",@"2016-10-19 10:00"];
//        NSString *str2 = [NSString stringWithFormat:@"审核时间：%@",@"2016-10-19 10:05"];
//        _datas2 = [NSArray arrayWithObjects:str1,str2, nil];
        _datas2 = self.data2;
    }
    return _datas2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    
    [self.navigationItem setTitle:@"预约详情"];
    if (kHeight == 480.0) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    }else if (kHeight == 568.0){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    }else if (kHeight == 667.0){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0]}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:22.0]}];
    }
    
    UIView *view = [[UIView alloc] init];
    [view.layer setCornerRadius:10];
    [view setBackgroundColor:[UIColor  whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(30*ScreenHeight/568.0);
        make.left.equalTo(self.view).offset(30*ScreenWidth/320.0);
        make.right.equalTo(self.view).offset(-30*ScreenWidth/320.0);
        make.height.equalTo(@(80*ScreenHeight/568.0));
    }];
    
    
    UIImageView *statusView = [[UIImageView alloc] init];
    
    [view addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        if (ScreenHeight==568) {
            make.left.equalTo(view).offset(80*ScreenWidth/320.0);
            
        }else if (ScreenHeight == 667){
            make.left.equalTo(view).offset(85*ScreenWidth/320.0);
            
        }else if(ScreenHeight == 736){
            make.left.equalTo(view).offset(90*ScreenWidth/320.0);
            
        }
        
        make.height.equalTo(statusView.mas_width);
        make.height.equalTo(@(20*ScreenHeight/568.0));
    }];
    
    UILabel *statusL = [[UILabel alloc] init];
    //[statusL setText:@"通过审核"];
    [statusL setTextColor:[UIColor colorWithRed:69/255.0 green:172/255.0 blue:232/255.0 alpha:1.0]];
    [view addSubview:statusL];
    [statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusView.mas_right).offset(5*ScreenWidth/320.0);
        make.centerY.equalTo(statusView);
        make.right.equalTo(statusView).offset(90*ScreenWidth/320.0);
    }];
    switch (self.state) {
        case -1:
            [statusView setImage:[UIImage imageNamed:@"no  pass"]];
            [statusL setTextColor:[UIColor redColor]];
            [statusL setText:@"未通过审核"];
            break;
        case 0:
            [statusView setImage:[UIImage imageNamed:@"wait"]];
            [statusL setTextColor:[UIColor colorWithRed:255/255.0 green:186/255.0 blue:90/255.0 alpha:1.0]];
            [statusL setText:@"等待审核"];
            break;
        case 1:
            [statusView setImage:[UIImage imageNamed:@"Pass"]];
            [statusL setTextColor:[UIColor colorWithRed:0/255.0 green:119/255.0 blue:176/255.0 alpha:1.0]];
            [statusL setText:@"通过审核"];
            break;
        case -2:
            [statusView setImage:[UIImage imageNamed:@"back"]];
            [statusL setTextColor:[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0]];
            [statusL setText:@"预约已取消"];
            break;
        default:
            break;
    }
    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140,ScreenWidth,188) style:UITableViewStyleGrouped];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140*ScreenHeight/568.0,ScreenWidth,(self.data2.count+4)*30*ScreenHeight/568.0+8) style:UITableViewStyleGrouped];

    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setAllowsSelection:YES];
    [tableView setScrollEnabled:NO];
    [tableView setRowHeight:30*ScreenHeight/568.0];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view.mas_bottom).offset(30);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.height.equalTo(@180);
//    }];
    if (self.state != -2) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"取消预约" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor colorWithRed:239/255.0 green:249/255.0 blue:253/255.0 alpha:1.0]];
        [btn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:227/255.0 alpha:1.0]];
        [btn.layer setCornerRadius:15.0];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo(tableView.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(20*ScreenWidth/320.0);
            make.right.equalTo(self.view).offset(-20*ScreenWidth/320.0);
            make.bottom.equalTo(self.view).offset(-30*ScreenHeight/568.0);
        }];
        [btn addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(cancleBook:) forControlEvents:UIControlEventTouchUpInside];
    }
    // Do any additional setup after loading the view.
}
-(void)clickDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"0094e9"]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)cancleBook:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:227/255.0 alpha:1.0]];
    [sender setTitleColor:[UIColor colorWithRed:239/255.0 green:249/255.0 blue:253/255.0 alpha:1.0] forState:UIControlStateNormal];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSDictionary *parameters = @{@"acoutid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"ids":[NSString stringWithFormat:@"%@",self.bookId],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:CANCLEBOOKINFO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if ([responseObject[@"result"] isEqual:@1]) {
            __weak BookDetailVC *weakSelf = self;
            if (self.block) {
                self.block(responseObject[@"msg"]);
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma marks ---UITableViewDelegate and UITableViewDatasource---
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else{
        return self.data2.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.datas[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:93/255.0 green:93/255.0 blue:93/255.0 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    }else{
        cell.textLabel.text = self.datas2[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12.0]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
        ClassRoomVC *vc = [[ClassRoomVC alloc] init];
        vc.roomDress = [cell.textLabel.text substringFromIndex:5] ;
        vc.capacity = self.classRoomCapacity;
        vc.assets = self.deviceArr;
        UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] init];
        [returnItem setTitle:@""];
        self.navigationItem.backBarButtonItem = returnItem;
        [self.navigationController pushViewController:vc animated:YES];
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

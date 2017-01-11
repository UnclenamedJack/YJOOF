//
//  searchVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "searchVC.h"
#import "Masonry.h"
#import "Header.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "searchCell.h"
#import "searchModel.h"

@interface searchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITextField *field;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *datas;
@property(nonatomic, strong)NSArray *dataModelArr;
@end

@implementation searchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.field = [[UITextField alloc] init];
    [_field becomeFirstResponder];
    [_field setDelegate:self];
    [_field setBorderStyle:UITextBorderStyleLine];
    [_field setPlaceholder:@"请输入资产编码"];
    [_field setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"erweima@3x"]]];
    [_field setLeftViewMode:UITextFieldViewModeAlways];
    _field.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:_field];
    [_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(15);
        make.height.equalTo(@30);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookOutForInformation:) name:UITextFieldTextDidChangeNotification object:_field];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_field.mas_right);
        make.right.equalTo(self.view).offset(-3);
        make.centerY.equalTo(_field);
    }];
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, ScreenWidth, ScreenHeight-50) style:UITableViewStylePlain];
    [_tableView setHidden:YES];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    

    // Do any additional setup after loading the view.
}
#pragma mark ----------------------UITableViewDelegate And UITableViewDataSource-------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"searchCell";
    searchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[searchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.label1.text = self.datas[indexPath.row][@"num"];
//    cell.label2.text = self.datas[indexPath.row][@"name"];
//    cell.label3.text = self.datas[indexPath.row][@"deptname"];
//    cell.label4.text = self.datas[indexPath.row][@"address"];
    cell.model = [searchModel modelWithDictionary:self.datas[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self bind:self.dataModelArr[indexPath.row] andIndexPath:indexPath withCompleteBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (void)cancleClick:(UIButton *)sender {
    [_field resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)bind:(searchModel *)model andIndexPath:(NSIndexPath *)indexPath withCompleteBlock:(void(^)()) completeBlock{
    NSString *url;
    NSDictionary *parameters;
    if (self.hubid) {
        if (model) {
            parameters = @{@"hubid":self.hubid,@"bdassetid":[NSNumber numberWithDouble:model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else {
            return;
        }
         url = CHAPAICHAKONGBANDDING;
        
    }else{
        if (model) {
            parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        }else {
            return;
        }
        url = CHAZUOBANGDING;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    NSDictionary *parameters = @{@"machineid":[[NSUserDefaults standardUserDefaults] objectForKey:@"machineid"],@"bdassetid":[NSNumber numberWithDouble:_model.assetid],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud.label setText:@"正在绑定"];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"网路连接成功！");
        NSLog(@"%@",responseObject);
#endif
        if ([responseObject[@"result"] intValue] == 1) {
            [hud hideAnimated:YES];
            
            if (self.block) {
                self.block(self.datas[indexPath.row][@"num"],self.dataModelArr[indexPath.row]);
            }
            if(completeBlock){
                completeBlock();
            }
        }else{
            [hud setMode:MBProgressHUDModeCustomView];
            [hud.label setText:responseObject[@"msg"]];
            [hud hideAnimated:YES afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
        NSLog(@"网络连接失败！");
        NSLog(@"%@",error);
#endif
        [hud setMode:MBProgressHUDModeCustomView];
        [hud.label setText:@"网络连接失败！"];
        [hud hideAnimated:YES afterDelay:1.5];
    }];

}
- (void)lookOutForInformation:(NSNotification *)sender {
    
    UITextField *field = (UITextField *)sender.object;
    if (field.text.length < 4) {
        return;
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json", nil];
        NSDictionary *parameters = @{@"num":field.text,@"acoutid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"]};
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager POST:MOHUCHAXUN parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
            NSLog(@"网路连接成功！");
            NSLog(@"%@",responseObject);
#endif
            
            if ([responseObject[@"result"] integerValue] == 1) {
                [hud setHidden:YES];
                self.datas = responseObject[@"obj"];
                NSMutableArray *arry = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"obj"]) {
                    searchModel *model = [searchModel modelWithDictionary:dict];
                    [arry addObject:model];
                }
                self.dataModelArr = arry;
                
                [self.tableView setHidden:NO];
                [self.tableView reloadData];
            }else{
                [hud setMode:MBProgressHUDModeCustomView];
                [hud setRemoveFromSuperViewOnHide:YES];
                [hud hideAnimated:YES afterDelay:2.0];
                [hud.label setText:responseObject[@"msg"]];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
            NSLog(@"网络连接失败！");
            NSLog(@"%@",error);
#endif
            [hud setMode:MBProgressHUDModeCustomView];
            [hud setRemoveFromSuperViewOnHide:YES];
            [hud hideAnimated:YES afterDelay:2.0];
            [hud.label setText:@"网络连接失败！"];
        }];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_field resignFirstResponder];
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

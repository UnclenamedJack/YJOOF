//
//  roomVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/11/8.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "roomVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ThreeCell.h"
#import "ClassRoomVC.h"
#import "Header.h"
#import "Masonry.h"
#import "UIColor+Extend.h"
#import "Header.h"

#define UPLOADDELAYTIME1 @"http://192.168.5.10:8080/wuxin/ygapi/updatebespeak?"
#define UPLOADDELAYTIME @"http://www.yjoof.com/ygapi/updatebespeak?"
#define ROOMURL @"http://www.yjoof.com/ygapi/getrooms?"
#define BOOKURL @"http://www.yjoof.com/ygapi/savebespeak?"

@interface roomVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIWindow *alertWindow;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSNumber *roomid;
@property(nonatomic,strong)NSString *classRoomName;
@property(nonatomic,assign)BOOL hasSelecetd;

@property(nonatomic,strong)NSMutableArray *selectedCellIndex;
@end

@implementation roomVC

- (NSArray *)datas {
    if (!_datas) {
        _datas = [NSArray array];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询可用教室";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"next" options:NSKeyValueObservingOptionNew context:nil];
    
    self.selectedCellIndex = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-140) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ThreeCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    
    
    UIButton *bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookBtn setBackgroundColor:[UIColor clearColor]];
    [bookBtn setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    [bookBtn.layer setBorderColor:[UIColor hexChangeFloat:@"00a0e9"].CGColor];
    [bookBtn.layer setBorderWidth:1.0];
    [bookBtn.layer setCornerRadius:18];
    [bookBtn setTitle:@"预约" forState:UIControlStateNormal];
    [self.view addSubview:bookBtn];
    [bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    [bookBtn addTarget:self action:@selector(bookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bookBtn addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view.
}
- (void)clickDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"00a0e9"]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
     MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud.label setText:@"正在加载"];
     NSDictionary *parameters = @{@"starttime":[NSString stringWithFormat:@"%@ %@",_date,_beginTime],@"endtime":[NSString stringWithFormat:@"%@ %@",_date,_endTime],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    [manager POST:ROOMURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.datas = responseObject[@"obj"];
        [self.tableView reloadData];
         if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
                }];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
    if (self.selectedCellIndex && [self.selectedCellIndex containsObject:indexPath]) {
        [cell.iconBTN setBackgroundImage:[UIImage imageNamed:@"选择方块"] forState:UIControlStateNormal];
        cell.iconBTN.tag = 1;
    }else{
        [cell.iconBTN setBackgroundImage:[UIImage imageNamed:@"选项方块"] forState:UIControlStateNormal];
        cell.iconBTN.tag = 0;
    }
//  [cell.iconBTN setBackgroundImage:[UIImage imageNamed:@"选项方块"] forState:UIControlStateNormal];
//    [cell.nameBTN setTitle:@"青山湾校区创业路逸夫楼B栋303B" forState:UIControlStateNormal];
    [cell.nameBTN setTitle:self.datas[indexPath.row][@"name"] forState:UIControlStateNormal];
    [cell.nameBTN setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
//    [cell.nameBTN addTarget:self action:@selector(jumpToRoomVC:) forControlEvents:UIControlEventTouchUpInside];
    __weak roomVC *weakself = self;
    cell.block = ^{
        ClassRoomVC *vc = [[ClassRoomVC alloc] init];
        vc.roomDress = _datas[indexPath.row][@"name"];
        vc.capacity = _datas[indexPath.row][@"capacity"];
        vc.assets = _datas[indexPath.row][@"assets"];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    cell.block2 = ^{
        weakself.roomid = weakself.datas[indexPath.row][@"id"];
        weakself.classRoomName = weakself.datas[indexPath.row][@"name"];
        weakself.hasSelecetd = YES;
        
        [weakself.selectedCellIndex removeAllObjects];
        [weakself.selectedCellIndex addObject:indexPath];
        [_tableView reloadData];
    };
    cell.block3 = ^{
        [weakself.selectedCellIndex removeObject:indexPath];
    };
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
////    ThreeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIBarButtonItem *returnIterm = [[UIBarButtonItem alloc] init];
//    [returnIterm setTitle:@""];
//    self.navigationItem.backBarButtonItem = returnIterm;
//    ClassRoomVC *vc = [[ClassRoomVC alloc] init];
//    vc.roomDress = _datas[indexPath.row][@"name"];
//    vc.capacity = _datas[indexPath.row][@"capacity"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}
- (void)bookBtnClick:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    
    if (!_hasSelecetd) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择教室！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_alertWindow setWindowLevel:UIWindowLevelAlert];
        [_alertWindow makeKeyAndVisible];
        
        self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        [_alertWindow addSubview:_bgView];
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        
        UIView *alertView = [[UIView alloc] init];
        [alertView.layer setCornerRadius:10];
        [_bgView addSubview:alertView];
        [alertView setBackgroundColor:[UIColor whiteColor]];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bgView).multipliedBy(4/5.0);
            make.left.equalTo(_bgView).offset(20*ScreenWidth/480.0);
            make.right.equalTo(_bgView).offset(-20*ScreenWidth/480.0);
            make.height.equalTo(_bgView).multipliedBy(1/3.0);
        }];
        
        UILabel *titleL = [[UILabel alloc] init];
        [titleL setText:@"预约详情"];
        if (ScreenHeight==568) {
            [titleL setFont:[UIFont systemFontOfSize:14.0]];
            
        }else if (ScreenHeight == 667){
            [titleL setFont:[UIFont systemFontOfSize:16.0]];
            
        }else{
            [titleL setFont:[UIFont systemFontOfSize:18.0]];
            
        }
//        [titleL setFont:[UIFont systemFontOfSize:14.0]];
        [titleL setTextColor:[UIColor hexChangeFloat:@"00a0e9"]];
        [alertView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.top.equalTo(alertView).offset(15*ScreenHeight/568.0);
        }];
        
        UILabel *bookDateL = [[UILabel alloc] init];
        if (ScreenHeight==568) {
            [bookDateL setFont:[UIFont systemFontOfSize:12.0]];
            
        }else if (ScreenHeight == 667){
            [bookDateL setFont:[UIFont systemFontOfSize:14.0]];
            
        }else{
            [bookDateL setFont:[UIFont systemFontOfSize:16.0]];
            
        }
//        [bookDateL setFont:[UIFont systemFontOfSize:12.0]];
        [bookDateL setTextColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    //    [bookDateL setText:@"预约日期：2016年11月2日"];
        [bookDateL setText:[NSString stringWithFormat:@"预约日期：%@",_date]];
        [alertView addSubview:bookDateL];

        [bookDateL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(alertView).offset(20*ScreenWidth/480.0);
            //make.right.equalTo(alertView).offset(-15);
            make.top.equalTo(titleL.mas_bottom).offset(20*ScreenHeight/568.0);
        }];
        
        UILabel *bookTimeL = [[UILabel alloc] init];
        if (ScreenHeight==568) {
            [bookTimeL setFont:[UIFont systemFontOfSize:12.0]];
            
        }else if (ScreenHeight == 667){
            [bookTimeL setFont:[UIFont systemFontOfSize:14.0]];
            
        }else{
            [bookTimeL setFont:[UIFont systemFontOfSize:16.0]];
            
        }
//        [bookTimeL setFont:[UIFont systemFontOfSize:12.0]];
        [bookTimeL setTextColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    //    [bookTimeL setText:@"预约时段：08：00~12：00"];
        [bookTimeL setText:[NSString stringWithFormat:@"预约时段：%@~%@",_beginTime,_endTime]];
        [alertView addSubview:bookTimeL];
        [bookTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bookDateL);
            make.top.equalTo(bookDateL.mas_bottom).offset(5*ScreenHeight/568.0);
        }];
        
        UILabel *useCauseL = [[UILabel alloc] init];
        if (ScreenHeight==568) {
            [useCauseL setFont:[UIFont systemFontOfSize:12.0]];
            
        }else if (ScreenHeight == 667){
            [useCauseL setFont:[UIFont systemFontOfSize:14.0]];
            
        }else{
            [useCauseL setFont:[UIFont systemFontOfSize:16.0]];
            
        }
//        [useCauseL setFont:[UIFont systemFontOfSize:12.0]];
        [useCauseL setTextColor:[UIColor hexChangeFloat:@"9fa0a0"]];
        [alertView addSubview:useCauseL];
        [useCauseL setLineBreakMode:NSLineBreakByTruncatingTail];
//        [useCauseL setNumberOfLines:3];
        [useCauseL setText:[NSString stringWithFormat:@"使用原因：%@",_useCause]];
        [useCauseL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bookTimeL);
            make.top.equalTo(bookTimeL.mas_bottom).offset(5*ScreenHeight/568.0);
            make.right.lessThanOrEqualTo(alertView).offset(-5);
        }];
        
        UILabel *booKClassRoomL = [[UILabel alloc] init];
        if (ScreenHeight==568) {
            [booKClassRoomL setFont:[UIFont systemFontOfSize:12.0]];
            
        }else if (ScreenHeight == 667){
            [booKClassRoomL setFont:[UIFont systemFontOfSize:14.0]];
            
        }else{
            [booKClassRoomL setFont:[UIFont systemFontOfSize:16.0]];
            
        }

//        [booKClassRoomL setFont:[UIFont systemFontOfSize:12]];
        [booKClassRoomL setTextColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    //    [booKClassRoomL setText:@"预约教室：青山湾小区创业路逸夫楼B栋303B"];
        [booKClassRoomL setText:[NSString stringWithFormat:@"预约教室：%@",_classRoomName]];
        [alertView addSubview:booKClassRoomL];
        [booKClassRoomL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(useCauseL);
            make.top.equalTo(useCauseL.mas_bottom).offset(5*ScreenHeight/568.0);
            make.right.lessThanOrEqualTo(alertView).offset(-5);
        }];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (ScreenHeight==568) {
            [backBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            
        }else if (ScreenHeight == 667){
            [backBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            
        }else{
            [backBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
            
        }
//        [backBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
        [backBtn.layer setBorderWidth:0.5];
        [backBtn.layer setBorderColor:[UIColor hexChangeFloat:@"00a0e9"].CGColor];
        [backBtn.layer setCornerRadius:5];
        [alertView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView).multipliedBy(0.5);
            make.top.equalTo(booKClassRoomL.mas_bottom).offset(20*ScreenHeight/568.0);
            make.width.equalTo(alertView).multipliedBy(0.23);
        }];
        [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [backBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [yesBtn setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
//        [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        if (ScreenHeight==568) {
            [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            
        }else if (ScreenHeight == 667){
            [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            
        }else{
            [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
            
        }

        [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
        [yesBtn.layer setBorderColor:[UIColor hexChangeFloat:@"00a0e9"].CGColor];
        [yesBtn.layer setBorderWidth:0.5];
        [yesBtn.layer setCornerRadius:5];
        [alertView addSubview:yesBtn];
        [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backBtn);
            make.centerX.equalTo(alertView).multipliedBy(1.5);
            make.width.equalTo(backBtn);
            make.height.equalTo(backBtn);
        }];
        [yesBtn addTarget:self action:@selector(yesClick:) forControlEvents:UIControlEventTouchUpInside];
        [yesBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    }
}
- (void)dismiss {
    if (_bgView && _alertWindow) {
        [_bgView removeFromSuperview];
        [self.alertWindow resignKeyWindow];
        _alertWindow = nil;
    }
}
- (void)yesClick:(UIButton *)sender {
    [_bgView removeFromSuperview];
    [_alertWindow resignKeyWindow];
    _alertWindow = nil;
    
    
    NSNumber *yktid = [[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text.html",@"application/json", nil];
    NSDictionary *parameters = @{@"starttime":[NSString stringWithFormat:@"%@ %@",_dateForApi,_beginTime],@"endtime":[NSString stringWithFormat:@"%@ %@",_dateForApi,_endTime],@"classname":_useCause,@"roomid":_roomid,@"yktid":yktid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:BOOKURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络连接成功！");
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([responseObject[@"result"] integerValue] == 1) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if (responseObject[@"msg"] && [responseObject[@"msg"] isEqualToString:@"请重新登录！"]){
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];
            }
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络失败！");
        NSLog(@"%@",error);
        [self showOkayCancelAlert];
    }];
}
- (void)touchDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"00a0e9"]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"next"];
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

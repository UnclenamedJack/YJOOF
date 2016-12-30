//
//  MyBookRecordsVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/10/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "MyBookRecordsVC.h"
#import "BookCell.h"
#import "ClassRoomVC.h"
#import "Header.h"
#import "BookDetailVC.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIColor+Extend.h"
#import "MJRefresh.h"

@interface MyBookRecordsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)UIView *deleteView;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)NSMutableArray *indexPathArr;
@property(nonatomic,strong)NSMutableArray *selectedInterms;
@property(nonatomic,strong)UIButton *downLeftBtn;
@property(nonatomic,strong)UIButton *downRightBtn;
@end

@implementation MyBookRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约记录";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editCell:)]];
    if (ScreenHeight==568 || ScreenHeight ==480) {
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} forState:UIControlStateNormal];
        
    }else if (ScreenHeight == 667){
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} forState:UIControlStateNormal];
        
    }else{
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} forState:UIControlStateNormal];
    }
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
    //请求数据
    [self downDatas];
    
    
    self.selectedInterms = [NSMutableArray array];
    self.datas = [NSMutableArray array];
    self.indexPathArr = [NSMutableArray array];
    self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tabView];
    [_tabView setSeparatorInset:UIEdgeInsetsZero];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.allowsSelection = NO;
    [_tabView setRowHeight:120];
    
    _tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downDatas];
    }];
    // Do any additional setup after loading the view.
}
//编辑
-(void)editCell:(UIBarButtonItem *)sender{
    if ([sender.title isEqualToString:@"编辑"]) {
        [sender setTitle:@"全选"];
        /**
         *  发送通知 把cell中得控件的颜色变灰、button点击失效.
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCellStatusColor" object:nil userInfo:nil];
        
        
        if (!self.deleteView) {
            self.deleteView = [[UIView alloc] init];
            [_deleteView setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:_deleteView];
            [self.view bringSubviewToFront:_deleteView];
            
            
            [UIView animateWithDuration:1.0 animations:^{
                [self.tabView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-40)];
                [_deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view);
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                    make.height.equalTo(@40);
                }];
            }];
            
            self.downLeftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [_downLeftBtn setEnabled:NO];
            [_downLeftBtn.layer setBorderWidth:1.0];
            [_downLeftBtn.layer setBorderColor:[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0].CGColor];
            [_downLeftBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [_downLeftBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
//            [_downLeftBtn setTitleColor:[UIColor colorWithRed:25/255.0 green:158/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_downLeftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_deleteView addSubview:_downLeftBtn];
            [_downLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_deleteView);
                make.top.equalTo(_deleteView);
                make.bottom.equalTo(_deleteView);
                make.width.equalTo(_deleteView).multipliedBy(0.5);
                
            }];
            [_downLeftBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            
            self.downRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [_downRightBtn setEnabled:NO];
            [_downRightBtn.layer setBorderColor:[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0].CGColor];
            [_downRightBtn.layer setBorderWidth:1.0];
            [_downRightBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [_downRightBtn setTitle:@"取消" forState:UIControlStateNormal];
            [_deleteView addSubview:_downRightBtn];
            [_downRightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_downRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_deleteView);
                make.top.equalTo(_deleteView);
                make.bottom.equalTo(_deleteView);
                make.left.equalTo(_downLeftBtn.mas_right).offset(0);
            }];
            [_downRightBtn addTarget:self action:@selector(cancleEditingState:) forControlEvents:UIControlEventTouchUpInside];

        }
        [self.deleteView setHidden:NO];
        //    NSIndexPath *singleIndex = [NSIndexPath indexPathForRow:0 inSection:self.tabView.visibleCells.count];
        //    [self.indexPathArr addObject:singleIndex];
        //    for (NSIndexPath *index in self.indexPathArr) {
        //        NSLog(@"-----%zd-----",self.indexPathArr.count);
        //        NSLog(@"%@",self.indexPathArr);
        //        BookCell *cell = [self.tabView cellForRowAtIndexPath:index];
        //        [cell.status setTextColor:[UIColor grayColor]];
        //        [cell.cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //    }
        //    for (BookCell *cell in self.tabView.visibleCells) {
        //        [cell.status setTextColor:[UIColor grayColor]];
        //        [cell.cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //        [cell.cancleBtn.layer setBorderColor:[UIColor grayColor].CGColor];
        //    }
        [self.tabView setEditing:YES animated:YES];
    }else if ([sender.title isEqualToString:@"全选"]){
        sender.title = @"取消全选";
        [self.downRightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.downLeftBtn setTitleColor:[UIColor colorWithRed:25/255.0 green:158/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.downLeftBtn setEnabled:YES];
        [self.downRightBtn setEnabled:YES];
        for (int i=0; i<self.datas.count; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.tabView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        for (NSDictionary *dict in self.datas) {
            if (![self.selectedInterms containsObject:dict]) {
                [self.selectedInterms addObject:dict];
            }
        }
        //避免重复添加
//        [self.selectedInterms addObjectsFromArray:self.datas];
        [_downLeftBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.selectedInterms.count] forState:UIControlStateNormal];
        
    }else{
        sender.title = @"全选";
        //[self.downRightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.downLeftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.downLeftBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        [self.downLeftBtn setEnabled:NO];
        for (int i=0; i<self.datas.count; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.tabView deselectRowAtIndexPath:indexpath animated:YES];
        }
        [self.selectedInterms removeAllObjects];
    }
}

#pragma mark ----UITableViewDelegate && UITableViewDataSource----
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }else{
        return 1;
    }
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.datas.count;
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
         cell = [[BookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //把下面的代码移动到这里 原理是 新创建的cell才需要设置以下代码，从复用池中复用的cell则不用设置 从而解决了 点击取消预约按钮改变状态、隐藏取消预约按钮后上下滚动转态又变回来的bug
        //上面no
    }
//    cell不能设置样式为none 因为设置为none之后就无法出现选中后的对勾.
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.classRoom.text = self.datas[indexPath.section][@"roomname"];
    cell.date.text = [NSString stringWithFormat:@"预约日期：%@",[self dateFromTimeInterval:[self.datas[indexPath.section][@"starttime"] doubleValue]]];
    
    cell.time.text = [self timeFromTimeInterval:[self.datas[indexPath.section][@"starttime"] doubleValue] andInterval2:[self.datas[indexPath.section][@"endtime"] doubleValue]];
    cell.classCount.text = [NSString stringWithFormat:@"预约课时：%@",self.datas[indexPath.section][@"classname"]];
    [self changeColorByState:[self.datas[indexPath.section][@"state"] integerValue] cell:cell];
    cell.ids = [self.datas[indexPath.section][@"bespeakid"] integerValue];
    
    __weak MyBookRecordsVC *weakSelf = self;
    __weak BookCell *weakcell = cell;
    //block的精髓
    cell.block1 = ^(NSString *str){
//        [weakSelf.datas removeObjectAtIndex:indexPath.section];
//        [tableView reloadData];
        [weakcell.status setText:@"预约已取消"];
        [weakcell.status setTextColor:[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0]];
        
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:weakSelf.datas[indexPath.section]];
        [mutDict setValue:@"-2" forKey:@"state"];
        [weakSelf.datas replaceObjectAtIndex:indexPath.section withObject:mutDict];
        [tableView reloadData];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (weakSelf.datas.count == 0){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
        [alert addAction:action];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        
    };
    cell.block = ^{
        
        NSMutableArray *arry = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"预约教室：%@",weakcell.classRoom.text],weakcell.date.text,weakcell.time.text,weakcell.classCount.text, nil];
        /**
         *  注意：这里的问题是判断是否存在审核时间
         */
        NSMutableArray *arry2 = [NSMutableArray array];
        [arry2 addObject:[weakSelf produceBookInfoTime:[weakSelf.datas[indexPath.section][@"createtime"] doubleValue]]];
        if ([weakSelf.datas[indexPath.section][@"state"] isEqual:@(-2)] && ![weakSelf.datas[indexPath.section][@"canceltime"] isKindOfClass:[NSNull class]]) {
            
            [arry2 addObject:[weakSelf produceBookInfoTime:[weakSelf.datas[indexPath.section][@"canceltime"] doubleValue] byState:[weakSelf.datas[indexPath.section][@"state"] integerValue]]];
        }else if ([[weakSelf.datas[indexPath.section] allKeys] containsObject:@"checktime"] ){
            [arry2 addObject:[weakSelf produceBookInfoTime:[weakSelf.datas[indexPath.section][@"checktime"] doubleValue] byState:[weakSelf.datas[indexPath.section][@"state"] integerValue]]];
        }
        
//        NSMutableArray *arry2 = [NSMutableArray arrayWithObjects:[weakSelf produceBookInfoTime:[weakSelf.datas[indexPath.section][@"creattime"] doubleValue]],, nil];
        BookDetailVC *vc = [[BookDetailVC alloc] init];
        vc.state = [weakSelf.datas[indexPath.section][@"state"] integerValue];
        vc.data = arry;
        vc.bookId = weakSelf.datas[indexPath.section][@"bespeakid"];
        vc.data2 = arry2;
        vc.classRoomCapacity = weakSelf.datas[indexPath.section][@"capacity"];
        vc.deviceArr = weakSelf.datas[indexPath.section][@"assetList"];
        
        UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] init];
        [returnItem setTitle:@""];
        self.navigationItem.backBarButtonItem = returnItem;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    
    cell.block2 = ^(NSString *str){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
//    原来是想通过button的tag来保存indexPath.section,以备需要的地方取到.
//    cell.cancleBtn.tag = indexPath.section;
//    [cell.cancleBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [cell setEditing:NO animated:YES];
//    if (cell.editing) {
//        [cell.status setTextColor:[UIColor grayColor]];
//        
//    }
//    [self.indexPathArr addObject:indexPath];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        //删除服务器中的数据
        BookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell deleteOneSectionOnServer];
        //删除本地列表中得数据
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~%@",self.datas);
        [self.datas removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedInterms addObject:self.datas[indexPath.section]];
    [self.downLeftBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.selectedInterms.count] forState:UIControlStateNormal];
    [self.downLeftBtn setEnabled:YES];
    [self.downLeftBtn setTitleColor:[UIColor colorWithRed:25/255.0 green:158/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.downRightBtn setEnabled:YES];
    [self.downRightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedInterms removeObject:self.datas[indexPath.section]];
    if (self.selectedInterms.count == 0) {
        [self.downRightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.downLeftBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        [self.downRightBtn setEnabled:NO];
        [self.downLeftBtn setEnabled:NO];
        [self.downLeftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        [self.downRightBtn setEnabled:YES];
        [self.downLeftBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.selectedInterms.count] forState:UIControlStateNormal];
    }
    if (self.selectedInterms.count != self.datas.count) {
        [self.navigationItem.rightBarButtonItem setTitle:@"全选"];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [self downDatas];
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
//    NSDictionary *parameters = @{@"acoutid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [manager POST:BOOKDETAILINFO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"%@",responseObject);
//        NSLog(@"%@",responseObject[@"msg"]);
//        if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            }];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//
//        /**
//         *  注意这两种写法的区别（提示：深拷贝VS浅拷贝）
//         */
//        if (self.datas) {
//            [self.datas removeAllObjects];
//        }
//        [self.datas addObjectsFromArray:responseObject[@"obj"]];//可行
////        self.datas = [responseObject[@"obj"] mutableCopy];//可行
////        self.datas = (NSMutableArray *)responseObject[@"obj"];//不可行
////        self.datas = [responseObject[@"obj"] copy];//不可行
//        if (self.datas.count == 0) {
//            __weak MyBookRecordsVC *weakSelf = self;
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//        [self.tabView reloadData];
//    
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
}
- (void)downDatas {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSDictionary *parameters = @{@"acoutid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:BOOKDETAILINFO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [_tabView.mj_header endRefreshing];
        /**
         *  注意这两种写法的区别（提示：深拷贝VS浅拷贝）
         */
        if (self.datas) {
            [self.datas removeAllObjects];
        }
        [self.datas addObjectsFromArray:responseObject[@"obj"]];//可行
        //        self.datas = [responseObject[@"obj"] mutableCopy];//可行
        //        self.datas = (NSMutableArray *)responseObject[@"obj"];//不可行
        //        self.datas = [responseObject[@"obj"] copy];//不可行
        if (self.datas.count == 0) {
            __weak MyBookRecordsVC *weakSelf = self;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [self.tabView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}
-(NSString *)dateFromTimeInterval:(double)interval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}
-(NSString *)timeFromTimeInterval:(double)interval1 andInterval2:(double)interval2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:interval1/1000];
    NSString *str1 = [formatter stringFromDate:date1];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:interval2/1000];
    NSString *str2 = [formatter stringFromDate:date2];
    
    NSString *str = [[NSString stringWithFormat:@"预约时间：%@",str1] stringByAppendingString:@"~"];
    return [str stringByAppendingString:str2];
}
- (NSString *)produceBookInfoTime:(double)timeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    return [NSString stringWithFormat:@"申请预约时间：%@",[formatter stringFromDate:date]];
}
- (NSString *)produceBookInfoTime:(double)timeInterval byState:(NSInteger)state {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSString *str;
    switch (state) {
        case -2:
            str = [NSString stringWithFormat:@"取消预约时间：%@",[formatter stringFromDate:date]];
            break;
        case -1:
            str = [NSString stringWithFormat:@"审核时间：%@",[formatter stringFromDate:date]];
            break;
        case 0:
            break;
        case 1:
            str = [NSString stringWithFormat:@"审核时间：%@",[formatter stringFromDate:date]];
            break;
        default:
            break;
    };
    return str;
}
-(void)changeColorByState:(NSInteger)nub cell:(BookCell *)cell {
    [cell.cancleBtn setTitleColor:[UIColor colorWithRed:28/255.0 green:181/255.0 blue:235/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cell.cancleBtn.layer setBorderColor:[UIColor colorWithRed:28/255.0 green:181/255.0 blue:235/255.0 alpha:1.0].CGColor];
    [cell.cancleBtn setEnabled:YES];
    switch (nub) {
        case -1:
            [cell.status setText:@"未通过"];
            [cell.status setTextColor:[UIColor redColor]];
            [cell.cancleBtn setHidden:NO];
            [cell.cancleBtn setEnabled:YES];
            break;
        case 0:
            [cell.status setText:@"等待审核"];
            [cell.status setTextColor:[UIColor colorWithRed:255/255.0 green:186/255.0 blue:90/255.0 alpha:1.0]];
            [cell.cancleBtn setHidden:NO];
            [cell.cancleBtn setEnabled:YES];
            break;
        case 1:
            [cell.status setText:@"通过"];
            [cell.status setTextColor:[UIColor colorWithRed:28/255.0 green:181/255.0 blue:235/255.0 alpha:1.0]];
            [cell.cancleBtn setHidden:NO];
            [cell.cancleBtn setEnabled:YES];
            break;
        case -2:
            [cell.status setText:@"预约已取消"];
            [cell.status setTextColor:[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0]];
            [cell.cancleBtn setHidden:YES];
            [cell.cancleBtn setEnabled:NO];
            break;
        default:
            break;
    }
}
-(void)cancleEditingState:(UIButton *)sender {
    [self.tabView setEditing:NO animated:YES];
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    [self.downLeftBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteView setHidden:YES];
    [self.tabView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.selectedInterms removeAllObjects];
    [self.tabView reloadData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCellStateColorBack" object:nil userInfo:nil];
    
}

-(void)delete:(UIButton *)sender {
//    for (NSIndexPath *indexpath in self.selectedInterms) {
//        [self.datas removeObjectAtIndex:indexpath.section];
//        [self.tabView deleteSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationBottom];
//       
//    }
    
    /**
     *  以下是对的
     */
    if (self.selectedInterms.count == 0) {
        sender.enabled = NO;
    }
    [self deleteMultipleBookInfoOnserver:self.selectedInterms];
    [self.datas removeObjectsInArray:self.selectedInterms];
    [self.selectedInterms removeAllObjects];

     [self.tabView reloadData];
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    [self.downLeftBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.tabView setEditing:NO animated:YES];
    if (self.selectedInterms.count == 0) {
        [self.deleteView setHidden:YES];
    }
    [self.tabView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    
}

-(void)deleteMultipleBookInfoOnserver:(NSArray *)idArr{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSString *firstStr =  [NSString stringWithFormat:@"%@",idArr.firstObject[@"bespeakid"]];
    for (int i=1; i<idArr.count; i++) {
        firstStr = [firstStr stringByAppendingFormat:@"|%@",idArr[i][@"bespeakid"]];
    }
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!%@",firstStr);
    NSDictionary *parameters = @{@"acoutid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"ids":firstStr,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:DELETBOOKINFO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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

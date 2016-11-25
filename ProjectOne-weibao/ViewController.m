//
//  ViewController.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/24.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "SmallScrollView.h"
#import "Masonry.h"
#import "UIColor+Extend.h"
#import "BtnView.h"
#import "ClassRoomVC.h"
#import "AFNetworking.h"
#include "AFHTTPSessionManager.h"
#import "NSDate+TimeCategory.h"
#import "CustomCell.h"
#import "MBProgressHUD.h"
#import "ThreeCell.h"
#import "forthCell.h"


#import <objc/runtime.h>

#define BOOKURL1 @"http://192.168.5.10:8080/wuxin/ygapi/savebespeak?"
#define ROOMURL1 @"http://192.168.5.10:8080/wuxin/ygapi/getrooms?"


#define BOOKURL @"http://www.yjoof.com/ygapi/savebespeak?"
#define ROOMURL @"http://www.yjoof.com/ygapi/getrooms?"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *btnArr;
@property(nonatomic,strong) UIScrollView *topScr;
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,strong) NSArray *datas;
@property(nonatomic,strong) AFHTTPSessionManager *netManager;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *beginTimeL;
@property(nonatomic,strong) UILabel *stopTimeL;
@property(nonatomic,strong) UILabel *dressLabel;
@property(nonatomic,strong) NSString *titleStr;
@property(nonatomic,strong) NSMutableArray *arr;
@property(nonatomic,strong) UILabel *totalClass;
@property(nonatomic,strong) NSArray *classView;
@property(nonatomic,strong) UIView *buttonView;
@property(nonatomic,strong) NSMutableArray *index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"预约教室"];
    if (kHeight == 480.0) {
         [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    }else if (kHeight == 568.0){
         [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    }else if (kHeight == 667.0){
         [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0]}];
    }else{
         [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:22.0]}];
    }
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
   
    self.netManager = [AFHTTPSessionManager manager];
    self.index = [NSMutableArray array];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"dressLabelText" options:NSKeyValueObservingOptionNew context:nil];
    
    
//    
//    unsigned int count;
//    objc_property_t *propertyList = class_copyPropertyList([ThreeCell class],&count);
//    for (int i=0; i<count; i++) {
//        const char *propertyName = property_getName(propertyList[i]);
//        NSLog(@"property ----> %@",[NSString stringWithUTF8String:propertyName]);
//    }
//    
//    
//    Method *methodList = class_copyMethodList([ThreeCell class], &count);
//    for (int i=0; i<count; i++) {
//        Method method = methodList[i];
//        NSLog(@"method -----> %@",NSStringFromSelector(method_getName(method)));
//    }
    
    
//    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 20)];
//    [statusView setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:statusView];
//    
//    
//    UINavigationBar *naviBar = [[UINavigationBar alloc] init];
//    [naviBar setTranslucent:NO];
//    UINavigationItem *naItem = [[UINavigationItem alloc] initWithTitle:@"预约教室"];
//    [naviBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [naviBar setBarTintColor:[UIColor blackColor]];
//    [naviBar pushNavigationItem:naItem animated:YES];
//    
//    [self.view addSubview:naviBar];
//    
//    [naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(20);
//        make.left.equalTo(self.view);
//        make.height.equalTo(@44);
//        make.width.equalTo(self.view);
//    }];

    
//    NSString *firstDate = [self getCurrentDate];
    self.btnArr = [self otherTitle];
    //self.btnArr = @[@"6月14日",@"6月15日",@"6月16日",@"6月17日",@"6月18日",@"6月19日",@"6月20日",@"6月21日"];
    [self createTopScrollView];
    [self createAndAddBookView];
    
//    [self.beginTimeL addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
//    [self.stopTimeL addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)createAndAddBookView {
    UIView *bookView = [[UIView alloc] init];
    [self.view addSubview:bookView];
    [bookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topScr.mas_bottom).offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(140*kHeight/736.0));
    }];
    
    UILabel *beginL = [[UILabel alloc] init];
    [beginL setText:@"起"];
    [beginL setTextAlignment:NSTextAlignmentCenter];
    [beginL setTextColor:[UIColor hexChangeFloat:@"189c05"]];
    if (kHeight == 480.0) {
        [beginL setFont:[UIFont systemFontOfSize:25.0]];
    }else if (kHeight == 568.0){
        [beginL setFont:[UIFont systemFontOfSize:27.0]];
    }else{
        [beginL setFont:[UIFont systemFontOfSize:30.0]];
    }
    [bookView addSubview:beginL];
    [beginL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookView).offset(22*kWidth/414.0);
        make.top.equalTo(bookView).offset(10*kHeight/736.0);
        make.width.equalTo(@(35*kWidth/414.0));
    }];
    
    UIImageView *direction = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiantou@2x"]];
    [bookView addSubview:direction];
    [direction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bookView).offset(40*kHeight/736.0);
        make.left.equalTo(beginL.mas_right).offset(9*kWidth/414.0);
        make.width.equalTo(@(228*kWidth/414.0));
        make.height.equalTo(@(5*kHeight/736.0));
    }];
    
    
    self.totalClass = [[UILabel alloc] init];
    [_totalClass setTextAlignment:NSTextAlignmentCenter];
    //[_totalClass setText:@"共三节课"];
    [_totalClass setText:@"请选择时段"];
    if (kHeight == 480.0) {
        [_totalClass.layer setCornerRadius:5.0];
    }else if (kHeight == 568.0){
        [_totalClass.layer setCornerRadius:6.0];
    }else if(kHeight == 667.0){
        [_totalClass.layer setCornerRadius:7.0];
    }else{
        [_totalClass.layer setCornerRadius:7.0];
    }
    [_totalClass.layer setMasksToBounds:YES];
    //[totalClass setClipsToBounds:YES];
    [_totalClass setFont:[UIFont systemFontOfSize:12.0]];
    [_totalClass setBackgroundColor:[UIColor hexChangeFloat:@"bcbcbc"]];
    [_totalClass setTextColor:[UIColor whiteColor]];
    [bookView addSubview:_totalClass];
    [_totalClass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(direction.mas_top).offset(-8*kHeight/736.0);
//        make.height.equalTo(@(18*kHeight/736.0));
//        make.width.equalTo(@(74*kWidth/414.0));
        make.centerX.equalTo(direction);
    }];
    
    self.dressLabel = [[UILabel alloc] init];
    [_dressLabel setTextAlignment:NSTextAlignmentCenter];
    [_dressLabel setFont:[UIFont systemFontOfSize:12.0]];
    //[_dressLabel setText:@"青山湾校区创业路逸夫楼B栋302A"];
    [_dressLabel setText:@"请选择教室"];
    [_dressLabel setNumberOfLines:0];
    [_dressLabel setTextColor:[UIColor hexChangeFloat:@"6d6d6d"]];
    [bookView addSubview:_dressLabel];
    [_dressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(direction);
        make.top.equalTo(direction.mas_bottom).offset(12*kHeight/736.0);
        make.left.equalTo(direction).offset(-9*kWidth/414.0);
        make.right.equalTo(direction).offset(9*kWidth/414.0);
    }];
    
    UILabel *stopL = [[UILabel alloc] init];
    [stopL setText:@"止"];
    [stopL setTextAlignment:NSTextAlignmentCenter];
    [stopL setTextColor:[UIColor hexChangeFloat:@"ff6d00"]];
    if (kHeight == 480.0) {
        [stopL setFont:[UIFont systemFontOfSize:25.0]];
    }else if (kHeight == 568.0){
        [stopL setFont:[UIFont systemFontOfSize:27.0]];
    }else{
        [stopL setFont:[UIFont systemFontOfSize:30.0]];
    }
    [bookView addSubview:stopL];
    [stopL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(direction.mas_right).offset(9*kWidth/414.0);
        make.top.equalTo(beginL);
        make.bottom.equalTo(beginL);
        make.width.equalTo(beginL);
        make.right.lessThanOrEqualTo(bookView).offset(-110*kWidth/414.0);
    }];
    
    self.beginTimeL = [[UILabel alloc] init];
    [_beginTimeL setTextAlignment:NSTextAlignmentCenter];
    [_beginTimeL setTextColor:[UIColor hexChangeFloat:@"bcbcbc"]];
    [_beginTimeL setText:@"09:00"];
    
    [_beginTimeL setFont:[UIFont systemFontOfSize:11.0]];
    [bookView addSubview:_beginTimeL];
    [_beginTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(beginL);
        make.top.equalTo(beginL.mas_bottom).offset(15*kHeight/(736.0 *2.0));
        make.centerX.equalTo(beginL);
    }];
    
    [self.beginTimeL addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    
    self.stopTimeL = [[UILabel alloc] init];
    [_stopTimeL setText:@"12:00"];
    [_stopTimeL setFont:[UIFont systemFontOfSize:11.0]];
    [_stopTimeL setTextAlignment:NSTextAlignmentCenter];
    [_stopTimeL setTextColor:[UIColor hexChangeFloat:@"bcbcbc"]];
    [bookView addSubview:_stopTimeL];
    [_stopTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stopL.mas_bottom).offset(15*kHeight/(736.0 *2.0));
        make.centerX.equalTo(stopL);
    }];
    [self.stopTimeL addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    [introduceLabel setTextColor:[UIColor hexChangeFloat:@"bcbcbc"]];
    //[introduceLabel setText:@"请先选择时段，再选择与时段对应的空闲教室,已经被预约过的教室不会显示！"];
    if (kHeight == 480 ) {
        [introduceLabel setNumberOfLines:1];
        [introduceLabel setText:@"请先选择时段，再选择与时段对应的空闲教室！"];

    }else{
        [introduceLabel setNumberOfLines:0];
        [introduceLabel setText:@"请先选择时段，再选择与时段对应的空闲教室,已经被预约过的教室不会显示！"];

    }
    [introduceLabel setFont:[UIFont systemFontOfSize:12.0]];
    [bookView addSubview:introduceLabel];
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookView).offset(22);
        if (kHeight == 480 || kHeight == 568) {
            make.bottom.equalTo(bookView).offset(-1);
            make.right.lessThanOrEqualTo(bookView).offset(0);
        }else {
            make.bottom.equalTo(bookView).offset(-14);
            make.right.equalTo(stopL).offset(0);
        }
        
        
    }];
    
    UIButton *bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookBtn setTitle:@"预约" forState:UIControlStateNormal];
    [bookBtn.layer setBorderColor:[UIColor hexChangeFloat:@"0094e9"].CGColor];
    [bookBtn.layer setBorderWidth:1.0];
    if (kHeight == 480.0) {
        [bookBtn.layer setCornerRadius:10.0];
    }else if (kHeight == 568.0){
        [bookBtn.layer setCornerRadius:12.0];
    }else{
        [bookBtn.layer setCornerRadius:16.0];
    }
    [bookBtn setBackgroundColor:[UIColor clearColor]];
    [bookBtn setTitleColor:[UIColor hexChangeFloat:@"0094e9"] forState:UIControlStateNormal];
    [bookView addSubview:bookBtn];
    [bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.greaterThanOrEqualTo(bookView).offset(-22*kWidth/414.0);
        make.centerY.equalTo(bookView);
        make.height.equalTo(@(70*kHeight/(736.0 *2.0)));
        make.width.equalTo(@(168*kWidth/(414.0 *2.0)));
        make.left.equalTo(stopL.mas_right).offset(5);
    }];

    [bookBtn addTarget:self action:@selector(upLoadBookInformation) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor hexChangeFloat:@"dcdcdc"]];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(bookView);
        make.right.equalTo(bookView);
        make.top.equalTo(bookView.mas_bottom);
    }];
    
    
    self.buttonView = [[UIView alloc] init];
    [self.view addSubview:_buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.equalTo(bookView);
        make.right.equalTo(bookView);
        make.height.equalTo(@(300*kHeight/736.0));
    }];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    BtnView *b1 = [[BtnView alloc] init];
    [arr addObject:b1];
    [b1 setTag:1];
    [b1.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b1.gestureRecongnizer setNumberOfTapsRequired:1];
    [b1.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b1.className setText:@"第一节"];
    [b1.classTime setText:@"08:00-08:45"];
    [_buttonView addSubview:b1];
    [b1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonView).offset(14.0*kHeight/736.0);
        make.left.equalTo(_buttonView).offset(22.0*kWidth/414.0);
    }];
    
    BtnView *b2 = [[BtnView alloc] init];
    [arr addObject:b2];
    [b2 setTag:2];
    [b2.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b2.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b2.gestureRecongnizer setNumberOfTapsRequired:1];
    [b2.className setText:@"第二节"];
    [b2.classTime setText:@"08:55-09:40"];
    [_buttonView addSubview:b2];
    [b2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b1);
        make.left.equalTo(b1.mas_right).offset(10.0*kWidth/414.0);
        make.width.equalTo(b1);
        make.height.equalTo(b1);
    }];
    
    BtnView *b3 = [[BtnView alloc] init];
    [arr addObject:b3];
    [b3 setTag:3];
    [b3.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b3.gestureRecongnizer setNumberOfTapsRequired:1];
    [b3.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b3.className setText:@"第三节"];
    [b3.classTime setText:@"10:00-10:45"];
    [_buttonView addSubview:b3];
    [b3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b2);
        make.height.equalTo(b2);
        make.width.equalTo(b2);
        make.left.equalTo(b2.mas_right).offset(10.0*kWidth/414.0);
    }];
    
    BtnView *b4 = [[BtnView alloc] init];
    [arr addObject:b4];
    [b4 setTag:4];
    [b4.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b4.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b4.gestureRecongnizer setNumberOfTapsRequired:1];
    [b4.className setText:@"第四节"];
    [b4.classTime setText:@"10:55-11:40"];
    [_buttonView addSubview:b4];
    [b4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b3);
        make.height.equalTo(b3);
        make.width.equalTo(b3);
        make.left.equalTo(b3.mas_right).offset(10.0*kWidth/414.0);
        make.right.equalTo(_buttonView).offset(-22.0*kWidth/414.0);
    }];
    
    BtnView *b5 = [[BtnView alloc] init];
    [arr addObject:b5];
    [b5 setTag:5];
    [b5.gestureRecongnizer setNumberOfTapsRequired:1];
    [b5.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b5.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b5.className setText:@"第五节"];
    [b5.classTime setText:@"13:00-13:45"];
    [_buttonView addSubview:b5];
    [b5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(b1);
        make.top.equalTo(b1.mas_bottom).offset(10.0*kWidth/414.0);
        make.height.equalTo(b1);
        make.width.equalTo(b1);
    }];
    
    BtnView *b6 = [[BtnView alloc] init];
    [arr addObject:b6];
    [b6 setTag:6];
    [b6.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b6.gestureRecongnizer setNumberOfTapsRequired:1];
    [b6.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b6.className setText:@"第六节"];
    [b6.classTime setText:@"13:55-14:40"];
    [_buttonView addSubview:b6];
    [b6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b5);
        make.left.equalTo(b5.mas_right).offset(10*kWidth/414.0);
        make.height.equalTo(b5);
        make.width.equalTo(b5);
    }];
    
    BtnView *b7 = [[BtnView alloc] init];
    [arr addObject:b7];
    [b7 setTag:7];
    [b7.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b7.gestureRecongnizer setNumberOfTapsRequired:1];
    [b7.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b7.className setText:@"第七节"];
    [b7.classTime setText:@"14:50-15:35"];
    [_buttonView addSubview:b7];
    [b7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b6);
        make.left.equalTo(b6.mas_right).offset(10*kWidth/414.0);
        make.height.equalTo(b6);
        make.width.equalTo(b6);
    }];

    BtnView *b8 = [[BtnView alloc] init];
    [arr addObject:b8];
    [b8 setTag:8];
    [b8.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b8.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b8.gestureRecongnizer setNumberOfTapsRequired:1];
    [b8.className setText:@"第八节"];
    [b8.classTime setText:@"15:45-16:30"];
    [_buttonView addSubview:b8];
    [b8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b7);
        make.left.equalTo(b7.mas_right).offset(10*kWidth/414.0);
        make.height.equalTo(b7);
        make.width.equalTo(b7);
        make.right.equalTo(_buttonView).offset(-22.0*kWidth/414.0);
    }];
    
    BtnView *b9 = [[BtnView alloc] init];
    [arr addObject:b9];
    [b9 setTag:9];
    [b9.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b9.gestureRecongnizer setNumberOfTapsRequired:1];
    [b9.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b9.className setText:@"第九节"];
    [b9.classTime setText:@"17:00-18:45"];
    [_buttonView addSubview:b9];
    [b9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b5.mas_bottom).offset(10*kWidth/414.0);
        make.left.equalTo(b5);
        make.height.equalTo(b5);
        make.width.equalTo(b5);
        make.bottom.equalTo(_buttonView).offset(-16*kHeight/736.0);
    }];
    
    BtnView *b10 = [[BtnView alloc] init];
    [arr addObject:b10];
    [b10 setTag:10];
    [b10.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b10.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b10.gestureRecongnizer setNumberOfTapsRequired:1];
    [b10.className setText:@"第十节"];
    [b10.classTime setText:@"18:55-19:40"];
    [_buttonView addSubview:b10];
    [b10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b9);
        make.left.equalTo(b9.mas_right).offset(10*kWidth/414.0);
        make.height.equalTo(b9);
        make.width.equalTo(b9);
    }];
    
    BtnView *b11 = [[BtnView alloc] init];
    [arr addObject:b11];
    [b11 setTag:11];
    [b11.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b11.gestureRecongnizer setNumberOfTapsRequired:1];
    [b11.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b11.className setText:@"第十一节"];
    [b11.classTime setText:@"19:50-20:35"];
    [_buttonView addSubview:b11];
    [b11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b10);
        make.left.equalTo(b10.mas_right).offset(10*kWidth/414.0);
        make.height.equalTo(b10);
        make.width.equalTo(b10);
    }];

    BtnView *b12 = [[BtnView alloc] init];
    [arr addObject:b12];
    self.classView = arr;
    [b12 setTag:12];
    [b12.gestureRecongnizer addTarget:self action:@selector(tapEvent:)];
    [b12.gestureRecongnizer setNumberOfTapsRequired:1];
    [b12.gestureRecongnizer setNumberOfTouchesRequired:1];
    [b12.classTime setText:@"20:45-21:30"];
    [b12.className setText:@"第十二节"];
    [_buttonView addSubview:b12];
    [b12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b11);
        make.left.equalTo(b11.mas_right).offset(10*kWidth/414.0);
        make.right.equalTo(_buttonView.mas_right).offset(-22*kWidth/414.0);
        make.height.equalTo(b11);
        make.width.equalTo(b11);
    }];
    
    
    
    self.tableView = [[UITableView alloc] init];
    [_tableView setScrollEnabled:YES];
    _tableView.allowsMultipleSelection = NO;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonView.mas_bottom).offset(0);
        make.left.equalTo(bookView);
        make.right.equalTo(bookView);
        make.bottom.equalTo(self.view);
    }];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    if (kHeight == 480.0) {
        [_tableView setRowHeight:30.0];
    }else if (kHeight == 568.0){
        [_tableView setRowHeight:40.0];
    }else if(kHeight == 667.0){
        [_tableView setRowHeight:42.0];
    }else{
        [_tableView setRowHeight:50.0];
    }
    [_tableView setBackgroundColor:[UIColor hexChangeFloat:@"f0f0f0"]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setSectionHeaderHeight:40.0];
    //设置成透视图的尝试
    //[tableView setTableHeaderView:[self headerView]];
}
-(NSString *)moreCompareOneDate:(NSString *)date1 withAnotherDate:(NSString *)date2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *lastDate = [formatter dateFromString:date1];
    NSDate *nextDate = [formatter dateFromString:date2];
    NSComparisonResult result = [lastDate compare:nextDate];

    if (result == NSOrderedAscending) {
        return date1;
    }else if (result == NSOrderedDescending){
        return date2;
    }else{
        return date1;
    }
}
-(NSString *)lessCompareOneDate:(NSString *)date1 withAnotherDate:(NSString *)date2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *lastDate = [formatter dateFromString:date1];
    NSDate *nextDate = [formatter dateFromString:date2];
    NSComparisonResult result = [lastDate compare:nextDate];
    
    if (result == NSOrderedAscending) {
        return date2;
    }else if (result == NSOrderedDescending){
        return date1;
    }else{
        return date1;
    }

}
-(void)tapEvent:(UITapGestureRecognizer *)sender {
    BtnView *view = (BtnView *)sender.view;
    NSString *str = [self getCurrentHour];
    NSString *resultStr = [self moreCompareOneDate:str withAnotherDate:[view.classTime.text substringFromIndex:6]];
    if (self.currentIndex == 0) {
        if (![resultStr isEqualToString:str]) {
            //[sender setEnabled:NO];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该时段是过去时，请重新选择时段！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [sender setEnabled:YES];
            if ([sender.view.backgroundColor isEqual:[UIColor hexChangeFloat:@"fafafa"]] ) {
                if (!self.arr) {
                    self.arr = [NSMutableArray array];
                }
                if (_arr.count == 0) {
                    [_arr addObject:@(sender.view.tag)];
                    [sender.view setBackgroundColor:[UIColor hexChangeFloat:@"0094e9"]];
                    BtnView *view = (BtnView *)sender.view;
                    [view.className setTextColor:[UIColor whiteColor]];
                    [view.classTime setTextColor:[UIColor colorWithRed:216/255.0 green:237/255.0 blue:248/255.0 alpha:1.0]];
                    self.beginTimeL.text =  [view.classTime.text substringToIndex:5];
                    self.stopTimeL.text = [view.classTime.text substringFromIndex:6];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //[self selectTimeAndRoom];
                    
                }else {
                    for (NSNumber *num in _arr) {
                        if ([num  isEqual: @(sender.view.tag -1)] || [num isEqual:@(sender.view.tag + 1)]) {
                            [_arr addObject:@(sender.view.tag)];
                            [sender.view setBackgroundColor:[UIColor hexChangeFloat:@"0094e9"]];
                            BtnView *view = (BtnView *)sender.view;
                            [view.className setTextColor:[UIColor whiteColor]];
                            [view.classTime setTextColor:[UIColor colorWithRed:216/255.0 green:237/255.0 blue:248/255.0 alpha:1.0]];
                            NSString *startDate = [view.classTime.text substringToIndex:5];
                            NSString *endDate = [view.classTime.text substringFromIndex:6];
                            
                            self.beginTimeL.text = [self moreCompareOneDate:startDate withAnotherDate:self.beginTimeL.text];
                            self.stopTimeL.text = [self lessCompareOneDate:endDate withAnotherDate:self.stopTimeL.text];
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                    self.beginTimeL.text =  [view.classTime.text substringToIndex:5];
                            //                    self.stopTimeL.text = [view.classTime.text substringFromIndex:6];
                            
                            //[self selectTimeAndRoom];
                            break;
                        }else{
                            //遍历这个数组，如果遍历到数组中得最后一个元素都没有符合上述条件那就执行弹窗提醒方法
                            if ([num isEqual:self.arr.lastObject]) {
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您选择的时段不连续，请分别预约！" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                [alert addAction:action];
                                [self presentViewController:alert animated:YES completion:nil];
                            }
                        }
                        
                    }
                    
                }
                
            }else if ([sender.view.backgroundColor isEqual:[UIColor hexChangeFloat:@"0094e9"]] ){
                if (self.arr.count <= 2) {
                    [self.arr removeObject:@(sender.view.tag)];
                    [sender.view setBackgroundColor:[UIColor hexChangeFloat:@"fafafa"]];
                    BtnView *view = (BtnView *)sender.view;
                    [view.className setTextColor:[UIColor blackColor]];
                    [view.classTime setTextColor:[UIColor hexChangeFloat:@"c5c5c5"]];
                    if (self.arr.count == 1) {
                        int a = [self.arr[0] intValue];
                        BtnView *view2 = self.classView[a - 1];
                        self.beginTimeL.text = [view2.classTime.text substringToIndex:5];
                        self.stopTimeL.text = [view2.classTime.text substringFromIndex:6];
                    }else {
                        self.datas = nil;
                        [self.tableView reloadData];
                        [self.dressLabel setText:@"请选择教室"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"roomid"];
                    }
                    //            NSString *startDate = [view.classTime.text substringToIndex:5];
                    //            NSString *endDate = [view.classTime.text substringFromIndex:6];
                    //            self.stopTimeL.text = [self lessCompareOneDate:endDate withAnotherDate:self.stopTimeL.text];
                    //            self.beginTimeL.text = [self moreCompareOneDate:startDate withAnotherDate:self.beginTimeL.text];
                    
                }else if (self.arr.count >= 3 ){
                    
                    if ([_arr containsObject:@(sender.view.tag + 1) ] && [_arr containsObject:@(sender.view.tag - 1)]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请保持预约时间段的连续！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:nil];
                    }else {
                        [self.arr removeObject:@(sender.view.tag)];
                        [sender.view setBackgroundColor:[UIColor hexChangeFloat:@"fafafa"]];
                        BtnView *view = (BtnView *)sender.view;
                        [view.className setTextColor:[UIColor blackColor]];
                        [view.classTime setTextColor:[UIColor hexChangeFloat:@"c5c5c5"]];
                        NSMutableArray *moreArr = [NSMutableArray array];
                        NSMutableArray *lessArr = [NSMutableArray array];
                        for (NSNumber *num in self.arr) {
                            NSComparisonResult result = [num compare:@(sender.view.tag)];
                            if (result == NSOrderedAscending) {
                                [moreArr addObject:num];
                            }else{
                                [lessArr addObject:num];
                            }
                        }
                        if ([moreArr isEqual:_arr]) {
                            BtnView *view = self.classView[sender.view.tag -2];
                            self.stopTimeL.text = [view.classTime.text substringFromIndex:6];
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        }else if ([lessArr isEqual:_arr]){
                            BtnView *view = self.classView[sender.view.tag];
                            self.beginTimeL.text = [view.classTime.text substringToIndex:5];
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            NSLog(@"*************%@",self.beginTimeL.text);
                        }
                    }
                }
            }
            if (self.arr.count == 0) {
                [self.totalClass setText:[NSString stringWithFormat:@"请选择时段"]];
                [self.totalClass setBackgroundColor:[UIColor hexChangeFloat:@"bcbcbc"]];
            }else{
                [self.totalClass setText:[NSString stringWithFormat:@"共%zd节课",self.arr.count]];
                [self.totalClass setBackgroundColor:[UIColor hexChangeFloat:@"0094e9"]];
            }
        }
    }else{
        [sender setEnabled:YES];
        if ([sender.view.backgroundColor isEqual:[UIColor hexChangeFloat:@"fafafa"]] ) {
            if (!self.arr) {
                self.arr = [NSMutableArray array];
            }
            if (_arr.count == 0) {
                [_arr addObject:@(sender.view.tag)];
                [sender.view setBackgroundColor:[UIColor hexChangeFloat:@"0094e9"]];
                BtnView *view = (BtnView *)sender.view;
                [view.className setTextColor:[UIColor whiteColor]];
                [view.classTime setTextColor:[UIColor colorWithRed:216/255.0 green:237/255.0 blue:248/255.0 alpha:1.0]];
                self.beginTimeL.text =  [view.classTime.text substringToIndex:5];
                self.stopTimeL.text = [view.classTime.text substringFromIndex:6];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //[self selectTimeAndRoom];
                
            }else {
                for (NSNumber *num in _arr) {
                    if ([num  isEqual: @(sender.view.tag -1)] || [num isEqual:@(sender.view.tag + 1)]) {
                        [_arr addObject:@(sender.view.tag)];
                        [sender.view setBackgroundColor:[UIColor hexChangeFloat:@"0094e9"]];
                        BtnView *view = (BtnView *)sender.view;
                        [view.className setTextColor:[UIColor whiteColor]];
                        [view.classTime setTextColor:[UIColor colorWithRed:216/255.0 green:237/255.0 blue:248/255.0 alpha:1.0]];
                        NSString *startDate = [view.classTime.text substringToIndex:5];
                        NSString *endDate = [view.classTime.text substringFromIndex:6];
                        
                        self.beginTimeL.text = [self moreCompareOneDate:startDate withAnotherDate:self.beginTimeL.text];
                        self.stopTimeL.text = [self lessCompareOneDate:endDate withAnotherDate:self.stopTimeL.text];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        //                    self.beginTimeL.text =  [view.classTime.text substringToIndex:5];
                        //                    self.stopTimeL.text = [view.classTime.text substringFromIndex:6];
                        
                        //[self selectTimeAndRoom];
                        break;
                    }else{
                        //遍历这个数组，如果遍历到数组中得最后一个元素都没有符合上述条件那就执行弹窗提醒方法
                        if ([num isEqual:self.arr.lastObject]) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您选择的时段不连续，请分别预约！" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                            [alert addAction:action];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    }
                    
                }
                
            }
            
        }else if ([sender.view.backgroundColor isEqual:[UIColor hexChangeFloat:@"0094e9"]] ){
            if (self.arr.count <= 2) {
                [self.arr removeObject:@(sender.view.tag)];
                [sender.view setBackgroundColor:[UIColor hexChangeFloat:@"fafafa"]];
                BtnView *view = (BtnView *)sender.view;
                [view.className setTextColor:[UIColor blackColor]];
                [view.classTime setTextColor:[UIColor hexChangeFloat:@"c5c5c5"]];
                if (self.arr.count == 1) {
                    int a = [self.arr[0] intValue];
                    BtnView *view2 = self.classView[a - 1];
                    self.beginTimeL.text = [view2.classTime.text substringToIndex:5];
                    self.stopTimeL.text = [view2.classTime.text substringFromIndex:6];
                }else {
                    self.datas = nil;
                    [self.tableView reloadData];
                    [self.dressLabel setText:@"请选择教室"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"roomid"];
                }
                //            NSString *startDate = [view.classTime.text substringToIndex:5];
                //            NSString *endDate = [view.classTime.text substringFromIndex:6];
                //            self.stopTimeL.text = [self lessCompareOneDate:endDate withAnotherDate:self.stopTimeL.text];
                //            self.beginTimeL.text = [self moreCompareOneDate:startDate withAnotherDate:self.beginTimeL.text];
                
            }else if (self.arr.count >= 3 ){
                
                if ([_arr containsObject:@(sender.view.tag + 1) ] && [_arr containsObject:@(sender.view.tag - 1)]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请保持预约时间段的连续！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else {
                    [self.arr removeObject:@(sender.view.tag)];
                    [sender.view setBackgroundColor:[UIColor hexChangeFloat:@"fafafa"]];
                    BtnView *view = (BtnView *)sender.view;
                    [view.className setTextColor:[UIColor blackColor]];
                    [view.classTime setTextColor:[UIColor hexChangeFloat:@"c5c5c5"]];
                    NSMutableArray *moreArr = [NSMutableArray array];
                    NSMutableArray *lessArr = [NSMutableArray array];
                    for (NSNumber *num in self.arr) {
                        NSComparisonResult result = [num compare:@(sender.view.tag)];
                        if (result == NSOrderedAscending) {
                            [moreArr addObject:num];
                        }else{
                            [lessArr addObject:num];
                        }
                    }
                    if ([moreArr isEqual:_arr]) {
                        BtnView *view = self.classView[sender.view.tag -2];
                        self.stopTimeL.text = [view.classTime.text substringFromIndex:6];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    }else if ([lessArr isEqual:_arr]){
                        BtnView *view = self.classView[sender.view.tag];
                        self.beginTimeL.text = [view.classTime.text substringToIndex:5];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        NSLog(@"*************%@",self.beginTimeL.text);
                    }
                }
            }
        }
        if (self.arr.count == 0) {
            [self.totalClass setText:[NSString stringWithFormat:@"请选择时段"]];
            [self.totalClass setBackgroundColor:[UIColor hexChangeFloat:@"bcbcbc"]];
        }else{
            [self.totalClass setText:[NSString stringWithFormat:@"共%zd节课",self.arr.count]];
            [self.totalClass setBackgroundColor:[UIColor hexChangeFloat:@"0094e9"]];
        }
    }
}
-(void)upLoadBookInformation {
    if (!_netManager) {
        return;
    }
    NSString *year = [self getCurrentYear];
    NSString *monthDay = [self changeDateFormatter:self.titleStr];
    NSString *begin = [NSString stringWithFormat:@"%@-%@ %@",year,monthDay,self.beginTimeL.text];
    NSString *end = [NSString stringWithFormat:@"%@-%@ %@",year,monthDay,self.stopTimeL.text];
    NSLog(@"%@",begin);
    NSLog(@"%@",end);
    
    
//    NSString *startStr = [NSString stringWithFormat:@"%@%@",self.titleStr,self.beginTimeL.text];
//    NSString *stopStr = [NSString stringWithFormat:@"%@%@",self.titleStr,self.stopTimeL.text];
//    NSLog(@"%@",startStr);
//    NSLog(@"%@",stopStr);
//    NSNumber *start = [NSNumber numberWithLong:[self translateDate:startStr]];
//    NSNumber *stop = [NSNumber numberWithLong:[self translateDate:stopStr]];
    
    
    NSNumber *yktid = [[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"];
    NSNumber *roomid = [[NSUserDefaults standardUserDefaults] objectForKey:@"roomid"];
    
    if ([self.totalClass.text isEqualToString:@"请选择时段"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择预约时段" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (!roomid){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择预约教室" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
       
    }else{
        NSDictionary *parameters = @{@"starttime":begin,@"endtime":end,@"classname":self.totalClass.text,@"roomid":roomid,@"yktid":yktid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
        _netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        [_netManager POST:BOOKURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"预约时间段网络连接成功!");
            if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
                    [self.navigationController  presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES completion:nil];
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
            if ([responseObject[@"result"] isEqual:@1]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"bespeakid"] forKey:@"bookid"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            
            NSLog(@"网络链接失败！");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网路连接失败！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
}
-(void)createTopScrollView {
    SmallScrollView *scroView  = [[SmallScrollView alloc] initWithButtonsArr:self.btnArr];
   
    self.titleStr = self.btnArr[scroView.index];
    NSLog(@"%@",self.titleStr);
    self.topScr = scroView;
    //__weak ViewController *weakSelf = self;
    void(^changeValue)(NSInteger) = ^(NSInteger currentIndex){
        self.titleStr = self.btnArr[currentIndex];
        self.currentIndex = currentIndex;
        self.datas = nil;
        [self.tableView reloadData];
        [self.dressLabel setText:@"请选择教室"];
        [self.totalClass setText:@"请选择时段"];
        [self.totalClass setBackgroundColor:[UIColor hexChangeFloat:@"bcbcbc"]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"roomid"];
        for (BtnView *view in self.classView) {
            [view setBackgroundColor:[UIColor hexChangeFloat:@"fafafa"]];
            [view.className setTextColor:[UIColor blackColor]];
            [view.classTime setTextColor:[UIColor hexChangeFloat:@"c5c5c5"]];
        }
        [self.arr removeAllObjects];
    };
    [_topScr setValue:changeValue forKey:@"changeIndexValue"];
    [self.view addSubview:_topScr];
}
//尝试设置透视图时自定义的透视图的方法（没有用）
-(UIView *)headerView {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"选择教室";
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [sectionView setBackgroundColor:[UIColor hexChangeFloat:@"f0f0f0"]];
    [sectionView addSubview:label];
    
    [label setFrame:CGRectMake(0, 0, 100, 40)];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    return sectionView;
    
}
#pragma mark    UITableViewDelegateMethords
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (kHeight == 480.0) {
        return 30.0;
    }else if (kHeight == 568.0){
        return 35.0;
    }else {
        return 40.0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *titleForSection = [self tableView:tableView titleForHeaderInSection:section];
    if (titleForSection == nil) {
        return nil;
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = titleForSection;
    if (kHeight == 480.0) {
        [label setFont:[UIFont systemFontOfSize:14.0]];
    }else if (kHeight == 568.0){
        [label setFont:[UIFont systemFontOfSize:15.0]];
    }else{
        [label setFont:[UIFont systemFontOfSize:18.0]];
    }
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight)];
    [sectionView setBackgroundColor:[UIColor hexChangeFloat:@"f0f0f0"]];
    [sectionView addSubview:label];
    
    [label setFrame:CGRectMake(5, 0, 100, tableView.sectionHeaderHeight)];
    [label setTextAlignment:NSTextAlignmentLeft];
    
    return sectionView;
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"选择教室";
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *sectionTitle = [self tableView:tableView viewForHeaderInSection:section];
//    if (!sectionTitle) {
//        return nil;
//    }
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame=CGRectMake(12, 0, 300, 22);
//    label.backgroundColor=[UIColor clearColor];
//    [label setTextColor:[UIColor blackColor]];
//    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
//    label.text=sectionTitle;
//    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
//    [sectionView setBackgroundColor:[UIColor blackColor]];
//    [sectionView addSubview:label];
//     return sectionView;
//    
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
//    CustomCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil][0];
//    [cell.icon setImage:[UIImage imageNamed:@"Marquee"]];
//    [cell.nameLabel setText:self.datas[indexPath.row][@"name"]];
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
   //cell.textLabel.text = @"青山湾校区创业路逸夫楼B栋302A";
    
    //ThreeCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeCell" owner:self options:nil][0];
    
    static NSString *identifier = @"cell0";
    
    ThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeCell" owner:self options:nil][0];
        
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    //forthCell *cell = [[forthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
//    
//    [cell.iconButton setTitle:nil forState:UIControlStateNormal];
//    [cell.iconButton setBackgroundImage:[UIImage imageNamed:@"Marquee@2x"] forState:UIControlStateNormal];
//    cell.nameLabel.text = self.datas[indexPath.row][@"name"];
//    cell.idStr = self.datas[indexPath.row][@"id"];
//    cell.index = indexPath.row + 1;
   
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"tag"] == indexPath.row + 1) {
//        [cell.iconButton setImage:[UIImage imageNamed:@"yes@2x"] forState:UIControlStateNormal];
//    }else if([[NSUserDefaults standardUserDefaults] integerForKey:@"tag"] == 0){
//        [cell.iconButton setEnabled:YES];
//
//    }else {
//        cell.iconButton.enabled = NO;
//        [cell.iconButton setImage:nil forState:UIControlStateNormal];
//        
//    }
    
    [cell.iconBTN setTitle:nil forState:UIControlStateNormal];
    
    [cell.iconBTN setBackgroundImage:[UIImage imageNamed:@"weixuanze@3x"] forState:UIControlStateNormal];
    [cell.nameBTN.titleLabel setTextAlignment:NSTextAlignmentRight];
    [cell.nameBTN setTintColor:[UIColor blackColor]];
    [cell.nameBTN setTitle:self.datas[indexPath.row][@"name"] forState:UIControlStateNormal];
    cell.idStr = self.datas[indexPath.row][@"id"];
    cell.index = indexPath.row + 1;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.nameBTN addTarget:self action:@selector(clickNameBTN:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"tag"] == indexPath.row + 1) {
        //[cell.iconBTN setImage:[UIImage imageNamed:@"勾@3x"] forState:UIControlStateNormal];
        [cell.iconBTN setBackgroundImage:[UIImage imageNamed:@"yixuanze@3x"] forState:UIControlStateNormal];
        [cell.iconBTN setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cell.iconBTN setTag:1];
    }else if([[NSUserDefaults standardUserDefaults] integerForKey:@"tag"] == 0){
        [cell.iconBTN setEnabled:YES];

    }else {
        cell.iconBTN.enabled = NO;
        [cell.iconBTN setImage:nil forState:UIControlStateNormal];
        
    }
    return cell;
}
-(void)clickNameBTN:(UIButton *)btn {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"class"];
    for (NSDictionary *dict in self.datas) {
        if ([btn.titleLabel.text isEqualToString:dict[@"name"]]) {
            [vc setValue:dict[@"name"] forKey:@"roomDress"];
            [vc setValue:dict[@"id"] forKey:@"roomId"];
            [vc setValue:dict[@"capacity"] forKey:@"capacity"];
            [vc setValue:dict[@"assets"] forKey:@"assets"];
        }
    }
   
    [self.navigationController pushViewController:vc animated:YES];
    UIBarButtonItem *returnBarButtonItem = [[UIBarButtonItem alloc] init];
    [returnBarButtonItem setTitle:@""];
    self.navigationItem.backBarButtonItem = returnBarButtonItem;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //注意：这个roomid就是进行网络请求要用到machineid  
    [[NSUserDefaults standardUserDefaults] setObject:self.datas[indexPath.row][@"id"] forKey:@"roomid"];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"class"];
    [vc setValue:self.datas[indexPath.row][@"name"] forKey:@"roomDress"];
    [vc setValue:self.datas[indexPath.row][@"id"] forKey:@"roomId"];
    [vc setValue:self.datas[indexPath.row][@"capacity"] forKey:@"capacity"];
    [vc setValue:self.datas[indexPath.row][@"assets"] forKey:@"assets"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    UIBarButtonItem *returnBarButtonItem = [[UIBarButtonItem alloc] init];
    [returnBarButtonItem setTitle:@""];
    self.navigationItem.backBarButtonItem = returnBarButtonItem;
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (long)translateDate:(NSString *)dateStr {
    //如果你发现报文显示的时间和你写得不一样，这个时候就要回忆一下自己写下这行注释的时候觉得自己多二！看看报文显示的时间后面是不是0000  这0000意味这什么？猜吧 笨蛋
    long date;
//    NSDate *one = [NSDate dateWithTimeIntervalSince1970:1476072000];
//    NSLog(@"%@",one);
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //[formater setTimeZone:timeZone];
    [formater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    [formater setLocale:[NSLocale currentLocale]];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date2 = [formater dateFromString:dateStr];
    NSLog(@"%@",date2);
    date = [date2 timeIntervalSince1970];
        //NSLog(@"%zd",date);
    return date;
}
- (NSString *)changeDateFormatter:(NSString *)str {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MM-dd"];
//    NSDate *date = [formatter dateFromString:str];
//    NSString *dateStr = [formatter stringFromDate:date];
//    NSLog(@"<><><><>><<><><<><>%@",dateStr);
//    return dateStr;
    
    NSString *month = [str substringToIndex:2];
    NSString *day = [str substringWithRange:NSMakeRange(3, 2)];
    NSString *monthDay = [NSString stringWithFormat:@"%@-%@",month,day];
    NSLog(@"%@",monthDay);
    return monthDay;
    
    
}
- (NSString *)getCurrentYear {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    [formatter setDateFormat:@"yyyy"];
    NSString *date1 = [formatter stringFromDate:date];
    NSLog(@"%@",date1);
    return date1;
}
- (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *currentDate = [formatter stringFromDate:date];
    NSLog(@"%@",currentDate);
    return currentDate;
}
- (NSString *)getCurrentHour {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    [formatter setDateFormat:@"HH:mm"];
    NSString *string = [formatter stringFromDate:date];
    return string;
}
- (NSMutableArray *)otherTitle {
    NSString *first = [self getCurrentDate];
    NSString *day1 = [first  substringFromIndex:3];
    NSString *month1 = [first substringToIndex:2];
    int day = [day1 intValue];
    int month = [month1 intValue];
    NSMutableArray *arry = [NSMutableArray array];
    [arry addObject:first];
    for (int i = 1; i < 8; i++) {
        
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
            if (day == 31) {
                month = month + 1;
                day = 1;
            }else {
                day = day + 1;
            }
        }else {
            if (day == 30) {
                month = month + 1;
                day = 1;
            }else {
                day = day + 1;
            }
        }
        
        if (month < 10) {
            if (day < 10) {
                NSString *date = [NSString stringWithFormat:@"0%zd月0%zd日",month,day];
                NSLog(@"%@",date);
                [arry addObject:date];
            }else{
                NSString *date = [NSString stringWithFormat:@"0%zd月%zd日",month,day];
                NSLog(@"%@",date);
                [arry addObject:date];
            }
        }else{
            if (day < 10) {
                NSString *date = [NSString stringWithFormat:@"%zd月0%zd日",month,day];
                NSLog(@"%@",date);
                [arry addObject:date];
            }else{
                NSString *date = [NSString stringWithFormat:@"%zd月%zd日",month,day];
                NSLog(@"%@",date);
                [arry addObject:date];
            }
        }
//        NSString *date = [NSString stringWithFormat:@"%zd月%zd日",month,day];
//        NSLog(@"%@",date);
//        [arry addObject:date];
    }
    return arry;
}
- (void)selectTimeAndRoom {
    if (!_netManager) {
        return;
    }
    self.netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    
//    long fromDate = [self translateDate:@"2016年10月10日12时00分"];
//    long toDate = [self translateDate:@"2016年10月10日12时45分"];
//    NSNumber *begintime =[NSNumber numberWithLong:fromDate];
//    NSNumber *endtime= [NSNumber numberWithLong:toDate];
//    NSDate *testDate = [NSDate date];
//    NSLog(@"??????%@",begintime);
//    NSLog(@"??????%@",endtime);
//    NSLog(@"%@",testDate);
    
    NSString *year = [self getCurrentYear];
    NSString *monthDay = [self changeDateFormatter:self.titleStr];
    NSString *begin = [NSString stringWithFormat:@"%@-%@ %@",year,monthDay,self.beginTimeL.text];
    NSString *end = [NSString stringWithFormat:@"%@-%@ %@",year,monthDay,self.stopTimeL.text];
    NSLog(@"%@",begin);
    NSLog(@"%@",end);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]);
    NSDictionary *parameters = @{@"starttime":begin,@"endtime":end,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
   
    [_netManager POST:ROOMURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",responseObject);
        NSLog(@"教室信息请求成功！");
        NSLog(@"%@",responseObject[@"msg"]);
        //点击进行网络请求的时候 把该对象移除掉 也就是每次请求完之后的数据显示都不会有对号标记
        //注意：该tag对象并不是对应button的tag属性 而是一个对应该button的cell的indexpath 对应button 所在的cell里面的index属性
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"刷新成功！" preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:alert animated:year completion:^{
//            [NSThread sleepForTimeInterval:2.0];
//        }];
        
        
        if (responseObject[@"msg"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
                    [self.navigationController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES completion:nil];
                }
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            self.datas = responseObject[@"obj"];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        NSLog(@"网络连接失败！");
        
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
   
    if ([object isEqual:self.beginTimeL]) {
        [self selectTimeAndRoom];
    }else if ([object isEqual:self.stopTimeL]){
        [self selectTimeAndRoom];
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dressLabelText"]) {
            self.dressLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"dressLabelText"];
            [self.tableView reloadData];
        }else{
            self.dressLabel.text = @"请选择教室";
            [self.tableView reloadData];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCodeSuccess"];
}
- (void)dealloc {
    [self.beginTimeL removeObserver:self forKeyPath:@"text"];
    [self.stopTimeL removeObserver:self forKeyPath:@"text"];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"dressLabelText"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

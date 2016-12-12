//
//  InformationVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/24.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "InformationVC.h"
#import "SpecialView.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "UIColor+Extend.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Header.h"


@interface InformationVC ()<UITextViewDelegate>
@property(nonatomic,strong) UITextView *textView;
@end

@implementation InformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"next" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 20)];
    [statusView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:statusView];
    
    
    UINavigationBar *naviBar = [[UINavigationBar alloc] init];
    [naviBar setTranslucent:NO];
    UINavigationItem *naItem = [[UINavigationItem alloc] initWithTitle:@"反馈信息"];
    [naviBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [naviBar setBarTintColor:[UIColor blackColor]];
    [naviBar pushNavigationItem:naItem animated:YES];
    
    [self.view addSubview:naviBar];
    
    [naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view);
        make.height.equalTo(@44);
        make.width.equalTo(self.view);
    }];
   
    
    //UIView *BorderView = [[UIView alloc] initWithFrame:CGRectMake(20, 85, Kwidth - 40, 163)];
    UILabel *USEInformationLabel = [[UILabel alloc] init];
    [self.view addSubview:USEInformationLabel];
    [USEInformationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(naviBar.mas_bottom).offset(20*kHeight/667.0);
        make.left.equalTo(self.view).offset(20*kWidth/375.0);
        if (kHeight == 480.0) {
            make.height.equalTo(@(25*kHeight/667.0));
        }else if (kHeight == 568.0){
            make.height.equalTo(@(30*kHeight/667.0));
        }else{
            make.height.equalTo(@(40*kHeight/667.0));
        }
        
        make.right.greaterThanOrEqualTo(self.view).offset(-20*kWidth/375.0);
    }];
    [USEInformationLabel setText:@"使用信息:"];
    if (kHeight == 480.0) {
        [USEInformationLabel setFont:[UIFont systemFontOfSize:14.0]];
    }else if(kHeight == 568.0){
          [USEInformationLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    [USEInformationLabel.layer setBorderColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0].CGColor];
    [USEInformationLabel.layer setBorderWidth:1.0];
    
    
    
//    UIView *BorderView = [[UIView alloc] init];
//    [self.view addSubview:BorderView];
//    [BorderView  setBorderWidth:1.0 withBroderColor:[UIColor blackColor] withCornerRadius:0.0];
//    [BorderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(20);
//        make.top.equalTo(USEInformationLabel.mas_bottom).offset(10);
//        make.right.equalTo(self.view).offset(-20);
//        make.height.equalTo(self.view).multipliedBy(0.2);
//    }];
    
    UIImageView *BorderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box-text"]];
    [self.view addSubview:BorderView];
    [BorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*kWidth/375.0);
        make.top.equalTo(USEInformationLabel.mas_bottom).offset(-1);
        make.right.equalTo(self.view).offset(-20*kWidth/375.0);
        make.height.equalTo(self.view).multipliedBy(0.2);
    }];

    UIImageView *littleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像-拷贝-8"]];
    [BorderView addSubview:littleImgView];
    [littleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BorderView).offset(19*kHeight/(2.0*667.0));
        //make.bottom.equalTo(BorderView).offset(-72/2.0);
        make.height.equalTo(BorderView).multipliedBy(112/203.0);
        make.width.equalTo(littleImgView.mas_height).multipliedBy(37/66.0);
        make.centerX.equalTo(BorderView.mas_left).offset(180*kWidth/(4.0*375));
    }];
    
    UILabel *userName = [[UILabel alloc] init];
    [BorderView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(littleImgView);
        make.top.equalTo(littleImgView.mas_bottom).offset(10*kHeight/667.0);
        make.width.equalTo(@(60*kWidth/375.0));
        make.height.equalTo(@(21*kHeight/667.0));
    }];
    //[userName setText:@"周虾米"];
    [userName setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [userName setTextAlignment:NSTextAlignmentCenter];
    if (kHeight == 568.0) {
        [userName setFont:[UIFont systemFontOfSize:16.0f]];
    }else if(kHeight == 480.0){
        [userName setFont:[UIFont systemFontOfSize:13.0f]];
    }else{
        [userName setFont:[UIFont systemFontOfSize:17.0f]];
    }
    
    
    UILabel *dateLabel = [[UILabel alloc] init];
    [BorderView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(littleImgView.mas_right).offset(10/2.0);
        if (kHeight == 480.0) {
            make.top.equalTo(BorderView).offset(15);
        }else{
            make.top.equalTo(BorderView).offset(52*kHeight/(2.0*667.0));
        }
        make.height.equalTo(@21);
        make.left.equalTo(BorderView).offset(181*kWidth/(2.0*375));
    }];
    //[dateLabel setText:@"2016年05月24日"];
    [dateLabel setText:[self getCurrentDate]];
    if (kHeight == 568.0) {
        [dateLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }else if(kHeight == 480.0) {
        [dateLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else{
        [dateLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
   
    
  
    
    
    UILabel *weekLabel = [[UILabel alloc] init];
    [BorderView addSubview:weekLabel];
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(dateLabel.mas_right).offset(10);
        make.centerY.equalTo(dateLabel);
        make.width.equalTo(dateLabel);
        make.height.equalTo(dateLabel);
        make.right.greaterThanOrEqualTo(BorderView).offset(0);
    }];
    //[weekLabel setText:@"星期二"];
    [weekLabel setText:[self getWeekDate]];
    if (kHeight == 568.0) {
        [weekLabel setFont:[UIFont systemFontOfSize:15.0]];
    }else if(kHeight == 480.0){
        [weekLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else{
        [weekLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
   
    
    
    UILabel *deviceNumberLabel = [[UILabel alloc] init];
    [BorderView addSubview:deviceNumberLabel];
    [deviceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel);
        make.top.equalTo(dateLabel.mas_bottom).offset(5*kHeight/667.0);
        make.height.equalTo(@21);
        //make.width.equalTo(@85);
    }];
    [deviceNumberLabel setText:@"设备编码:"];
    if (kHeight == 568.0) {
        [deviceNumberLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }else if(kHeight == 480.0){
        [deviceNumberLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else{
        [deviceNumberLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    
    
    
    UILabel *DeviceNum = [[UILabel alloc] init];
    [BorderView addSubview:DeviceNum];
    [DeviceNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(deviceNumberLabel.mas_trailing).offset(5*kHeight/667.0);
        make.top.equalTo(deviceNumberLabel.mas_top);
        make.height.equalTo(deviceNumberLabel);
        make.trailing.lessThanOrEqualTo(BorderView).offset(-8*kWidth/375.0);
    }];
    //[DeviceNum setText:@"00000000"];
    [DeviceNum setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceNum"]];
    //[DeviceNum setFont:[UIFont systemFontOfSize:15.0f]];
    if (kHeight == 568.0) {
        [DeviceNum setFont:[UIFont systemFontOfSize:15.0f]];
    }else if (kHeight == 480.0){
        [DeviceNum setFont:[UIFont systemFontOfSize:13.0f]];
    }else{
        [DeviceNum setFont:[UIFont systemFontOfSize:17.0f]];
    }

    UILabel *bookTimeLabel = [[UILabel alloc] init];
    [BorderView addSubview:bookTimeLabel];
    [bookTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceNumberLabel);
        make.right.greaterThanOrEqualTo(BorderView).offset(-8*kWidth/375.0);
        make.top.equalTo(deviceNumberLabel.mas_bottom).offset(15*kHeight/667.0);
        make.bottom.greaterThanOrEqualTo(BorderView).offset(-63*kHeight/(2.0*667.0));
    }];
//    NSString *begin = [[NSUserDefaults standardUserDefaults] objectForKey:@"beginTime"];
//    NSString *end = [[NSUserDefaults standardUserDefaults] objectForKey:@"endtime"];
//    NSString *totalTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalTime"];
    [bookTimeLabel setText:[NSString stringWithFormat:@"%@~%@,共计%@",self.beginTime,self.endTime,self.totalTime]];
    //[bookTimeLabel setText:@"09:00~10:00,共计60分钟"];
    [bookTimeLabel setTextColor:[UIColor colorWithRed:5/255.0 green:125/255.0 blue:194/255.0 alpha:1.0]];
    if (kHeight == 568.0) {
        [bookTimeLabel setFont:[UIFont systemFontOfSize:16.0]];

    }else if (kHeight == 480.0){
        [bookTimeLabel setFont:[UIFont systemFontOfSize:15.0]];
    }else{
        [bookTimeLabel setFont:[UIFont systemFontOfSize:18.0]];
    }
    
    UILabel *adviceLabel = [[UILabel alloc] init];
    [adviceLabel.layer setBorderWidth:1.0];
    [adviceLabel.layer setBorderColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0].CGColor];
    [self.view addSubview:adviceLabel];
    [adviceLabel setText:@"填写反馈意见:"];
    if (kHeight == 480.0) {
        [adviceLabel setFont:[UIFont systemFontOfSize:14.0]];
    }else if(kHeight == 568.0){
           [adviceLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    [adviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(USEInformationLabel);
        make.right.equalTo(USEInformationLabel);
        make.top.equalTo(BorderView.mas_bottom).offset(20*kHeight/667.0);
        if (kHeight == 480.0) {
            make.height.equalTo(@(25*kHeight/667.0));
        }else if(kHeight == 568.0){
            make.height.equalTo(@(30*kHeight/667.0));
        }else{
            make.height.equalTo(@(40*kHeight/667.0));
        }
    }];
    UIView *view3 = [[UIView alloc] init];
    [view3 setBorderWidth:1.0 withBroderColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0] withCornerRadius:0];
    [self.view addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adviceLabel.mas_bottom).offset(-1);
        make.height.equalTo(self.view).multipliedBy(0.4);
        make.left.equalTo(self.view).offset(20*kWidth/375.0);
        make.right.equalTo(self.view).offset(-20*kWidth/375.0);
    }];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"非常差" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:104/255.0 green:103/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
    [btn1.layer setBorderWidth:1.0];
    [btn1.layer setBorderColor:[UIColor hexChangeFloat:@"ffb779"].CGColor];
    [btn1.titleLabel setTextColor:[UIColor grayColor]];
    if (kHeight == 480.0) {
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }else if(kHeight == 568.0){
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else {
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [btn1 setHidden:NO];
    [view3 addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view3).offset(5*kHeight/667.0);
        make.left.equalTo(view3).offset(8*kWidth/375.0);
    }];
    [btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt2 setTitle:@"很差" forState:UIControlStateNormal];
    [bt2 setTitleColor:[UIColor colorWithRed:104/255.0 green:103/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
    [bt2.layer setBorderColor:[UIColor hexChangeFloat:@"ffb779"].CGColor];
    [bt2.layer setBorderWidth:1.0];
    if (kHeight == 480.0) {
        [bt2.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }else if(kHeight == 568.0){
        [bt2.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else {
        [bt2.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [view3 addSubview:bt2];
    [bt2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn1);
        make.height.equalTo(btn1);
        make.left.equalTo(btn1.mas_right).offset(5*kWidth/375.0);
        make.width.equalTo(btn1);
        make.top.equalTo(btn1);
    }];
    [bt2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setTitle:@"差" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor colorWithRed:104/255.0 green:103/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn3 setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
    [btn3.layer setBorderWidth:1.0];
    [btn3.layer setBorderColor:[UIColor hexChangeFloat:@"ffb779"].CGColor];
    if (kHeight == 480.0) {
        [btn3.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }else if(kHeight == 568.0){
        [btn3.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else {
        [btn3.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [view3 addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn1);
        make.left.equalTo(bt2.mas_right).offset(5*kWidth/375.0);
       // make.right.equalTo(view3).offset(-10);
        make.width.equalTo(bt2);
    }];
    [btn3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setTitle:@"一般" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor colorWithRed:104/255.0 green:103/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn4 setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
    [btn4.layer setBorderWidth:1.0];
    [btn4.layer setBorderColor:[UIColor hexChangeFloat:@"ffb779"].CGColor];
    if (kHeight == 480.0) {
        [btn4.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }else if(kHeight == 568.0){
        [btn4.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else {
        [btn4.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [view3 addSubview:btn4];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn1);
        make.left.equalTo(btn3.mas_right).offset(5*kWidth/375.0);
        make.right.equalTo(view3).offset(-8*kWidth/375.0);
        make.width.equalTo(bt2);
    }];
    [btn4 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 setTitle:@"良好" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor colorWithRed:104/255.0 green:103/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn5 setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
    [btn5.layer setBorderColor:[UIColor hexChangeFloat:@"ffb779"].CGColor];
    [btn5.layer setBorderWidth:1.0];
    if (kHeight == 480.0) {
        [btn5.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }else if(kHeight == 568.0){
        [btn5.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else {
        [btn5.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [view3 addSubview:btn5];
    [btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1);
        make.top.equalTo(btn1.mas_bottom).offset(5*kHeight/667.0);
    }];
    [btn5 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn6 setTitle:@"好" forState:UIControlStateNormal];
    [btn6 setTitleColor:[UIColor colorWithRed:104/255.0 green:103/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn6 setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
    [btn6.layer setBorderColor:[UIColor hexChangeFloat:@"ffb779"].CGColor];
    [btn6.layer setBorderWidth:1.0];
    if (kHeight == 480.0) {
        [btn6.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }else if(kHeight == 568.0){
        [btn6.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else {
        [btn6.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [view3 addSubview:btn6];
    [btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn5.mas_right).offset(5*kWidth/375.0);
        make.top.equalTo(bt2.mas_bottom).offset(5*kHeight/667.0);
        make.width.equalTo(btn5);
    }];
    [btn6 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn7 setTitle:@"很好" forState:UIControlStateNormal];
    [btn7 setTitleColor:[UIColor colorWithRed:104/255.0 green:103/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn7 setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
    [btn7.layer setBorderWidth:1.0];
    [btn7.layer setBorderColor:[UIColor hexChangeFloat:@"ffb779"].CGColor];
    if (kHeight == 480.0) {
        [btn7.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }else if(kHeight == 568.0){
        [btn7.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else {
        [btn7.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [view3 addSubview:btn7];
    [btn7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn3.mas_bottom).offset(5*kHeight/667.0);
        make.left.equalTo(btn6.mas_right).offset(5*kWidth/375.0);
        make.width.equalTo(btn5);
    }];
    [btn7 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn8 setTitle:@"非常好" forState:UIControlStateNormal];
    [btn8 setTitleColor:[UIColor colorWithRed:104/255.0 green:103/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn8 setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
    [btn8.layer setBorderColor:[UIColor hexChangeFloat:@"ffb779"].CGColor];
    [btn8.layer setBorderWidth:1];
    if (kHeight == 480.0) {
        [btn8.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }else if(kHeight == 568.0){
        [btn8.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }else {
        [btn8.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [view3 addSubview:btn8];
    [btn8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn7.mas_right).offset(5*kWidth/375.0);
        make.top.equalTo(btn4.mas_bottom).offset(5*kHeight/667.0);
        make.right.equalTo(view3).offset(-8*kWidth/375.0);
        make.width.equalTo(btn5);
    }];
    [btn8 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.textView = [[UITextView alloc] init];
    _textView.delegate = self;
    [_textView setBackgroundColor:[UIColor hexChangeFloat:@"eeeeee"]];
    [view3 addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn5.mas_bottom).offset(5*kHeight/667.0);
        make.left.equalTo(view3).offset(5*kWidth/375.0);
        make.right.equalTo(view3).offset(-5*kWidth/375.0);
        make.bottom.equalTo(view3).offset(-10*kHeight/667.0);
    }];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setTitle:@"提交" forState:UIControlStateNormal];
    [postButton.layer setCornerRadius:10.0f];
    [postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postButton setBackgroundColor:[UIColor hexChangeFloat:@"0c78d3"]];
    [self.view addSubview:postButton];
    
    [postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view3.mas_bottom).offset(20*kHeight/667.0);
        make.left.equalTo(_textView);
        make.right.equalTo(_textView);
        make.bottom.lessThanOrEqualTo(self.view).offset(-5*kHeight/667.0);
    }];
    [postButton addTarget:self action:@selector(POSTInformation) forControlEvents:UIControlEventTouchUpInside];
    //Do any additional setup after loading the view.
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
-(void)POSTInformation {
    //提交
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSLog(@"!!??%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"usagesid"]);
    //崩掉的原因是usagesid 为空！  
    NSDictionary *parameter = @{@"content":self.textView.text,@"usageid":[[NSUserDefaults standardUserDefaults] objectForKey:@"usagesid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    NSLog(@"<><><>%@",parameter);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:POSTURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"提交反馈网络连接成功！");
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息反馈成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
                    [self presentViewController:navc animated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
                        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InformationVC"] animated:YES completion:nil];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
//        if ([responseObject[@"msg"] isEqualToString:@"请重新登录！"]) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
//                [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InformationVC"] animated:YES completion:nil];
//            }];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }else{
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //            UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
//                //            [self presentViewController:homeVC animated:YES completion:nil];
//                if ([responseObject[@"result"] integerValue] == 1) {
//                    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
//                    [self presentViewController:navc animated:YES completion:nil];
//                }
//            }];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        NSLog(@"网络请求失败！");
        [self showOkayCancelAlert];
    }];
    
}
- (void)clickDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"fee8d0"] forState:UIControlStateNormal];
}
- (void)click:(UIButton *)sender {
    if (self.textView.text.length == 0) {
        self.textView.text = sender.titleLabel.text;
    }else{
      self.textView.text = [self.textView.text stringByAppendingString:sender.titleLabel.text];
    }
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"fee8d0"]];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDate = [formatter stringFromDate:date];
    NSLog(@"%@",currentDate);
    return currentDate;
}
- (NSString *)getWeekDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    now = [NSDate date];
    //components = [calendar component:unitFlags fromDate:now];
    components = [calendar components:unitFlags fromDate:now];
    NSInteger week = [components weekday];
    NSString *weekStr;
    switch (week) {
        case 1:
            weekStr = [NSString stringWithFormat:@"星期日"];
            break;
        case 2:
            weekStr = [NSString stringWithFormat:@"星期一"];
            break;
        case 3:
            weekStr = [NSString stringWithFormat:@"星期二"];
            break;
        case 4:
            weekStr = [NSString stringWithFormat:@"星期三"];
            break;
        case 5:
            weekStr = [NSString stringWithFormat:@"星期四"];
            break;
        case 6:
            weekStr = [NSString stringWithFormat:@"星期五"];
            break;
        case 7:
            weekStr = [NSString stringWithFormat:@"星期六"];
            break;
        default:
            break;
    }
    
    return weekStr;
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
- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"next"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)textViewDidEndEditing:(UITextView *)textView {
//    self.view.frame = CGRectMake(0, 0, self.view.size.width, self.view.size.height);
//    [self.SecondTextView resignFirstResponder];
//}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.SecondTextView resignFirstResponder];
//}
-(void)textViewDidBeginEditing:(UITextView *)textView {
//    
//    CGRect frame = self.SecondTextView.frame;
//        int offset = frame.origin.y + 32  - (self.view.frame.size.height - 216.0);
//    NSTimeInterval animateDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    
//    [UIView setAnimationDuration:animateDuration];
//    if (offset > 0) {
//        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        [UIView commitAnimations];
//    }
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

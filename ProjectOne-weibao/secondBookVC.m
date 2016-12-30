//
//  secondBookVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/11/7.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "secondBookVC.h"
#import "Header.h"
#import "Masonry.h"
#import "UIColor+Extend.h"
#import "roomVC.h"
#import "CMInputView.h"
#import "DIYCalendarVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Header.h"


@interface secondBookVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)UIWindow *alertWindow;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *datas1;
@property(nonatomic,strong)NSMutableArray *datas2;
@property(nonatomic,strong)UILabel *beginL;
@property(nonatomic,strong)UILabel *endL;
@property(nonatomic,strong)UILabel *detailLable;
@property(nonatomic,strong)void(^block)();
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,copy)NSString *dateForAPI;
@property(nonatomic,strong)CMInputView *label;
//@property(nonatomic,strong)UITextView *label;
@property(nonatomic,strong)void(^updateConstraitsBlcok)(CGFloat height);
@property(nonatomic,assign)int hour;
@property(nonatomic,assign)int minute;
@property(nonatomic,copy)NSString *startBookTime;
@property(nonatomic,copy)NSString *endBookTime;
@property(nonatomic,copy)NSString *selectedDate;
@end

@implementation secondBookVC

- (NSMutableArray *)datas1 {
    if (!_datas1) {
        _datas1 = [NSMutableArray array];
    }else{
        [_datas1 removeAllObjects];
        if ([_detailLable.text isEqualToString:self.selectedDate]) {
            
            for (int i=_hour; i<24; i++) {
                if (i<10) {
                    [_datas1 addObject:[NSString stringWithFormat:@"0%zd",i]];
                }else{
                    [_datas1 addObject:[NSString stringWithFormat:@"%zd",i]];
                }
            }

        }else{
            for (int i=0; i<24; i++) {
                if (i<10) {
                    [_datas1 addObject:[NSString stringWithFormat:@"0%zd",i]];
                }else{
                    [_datas1 addObject:[NSString stringWithFormat:@"%zd",i]];
                }
            }
        }
    }
    return _datas1;
}
- (NSMutableArray *)datas2 {
    if (!_datas2) {
        _datas2 = [NSMutableArray array];
    }else{
        [_datas2 removeAllObjects];
        if ([_detailLable.text isEqualToString:self.selectedDate]) {
            
            
            if ([_pickerView selectedRowInComponent:0] == 0) {
                for (int i=_minute; i<60; i++) {
                    if (i<10) {
                        [_datas2 addObject:[NSString stringWithFormat:@"0%zd",i]];
                    }else{
                        [_datas2 addObject:[NSString stringWithFormat:@"%zd",i]];
                    }
                }
            }else{
                for (int i=0; i<60; i++) {
                    if (i<10) {
                        [_datas2 addObject:[NSString stringWithFormat:@"0%zd",i]];
                    }else{
                        [_datas2 addObject:[NSString stringWithFormat:@"%zd",i]];
                    }
                }
            }

        }else{
            for (int i=0; i<60; i++) {
                if (i<10) {
                    [_datas2 addObject:[NSString stringWithFormat:@"0%zd",i]];
                }else{
                    [_datas2 addObject:[NSString stringWithFormat:@"%zd",i]];
                }
            }
        }
    }
    return _datas2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约教室";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看历史" style:UIBarButtonItemStylePlain target:self action:@selector(history:)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"next" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *view = [self createView:[UIImage imageNamed:@"日历图标"] andLabel:@"请选择预约日期"];
//    [view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        make.height.equalTo(@40);
    }];
    
    UIView *view2 = [self createViewWithImage:[UIImage imageNamed:@"时间图标"] andBeginTime:@"请选择预约起始时间" andEndTime:@"请选择预约结束时间"];
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@83);
    }];
    
    
    UIView *view3 = [self createCauseView:[UIImage imageNamed:@"使用原因图标"] andCause:@"使用原因"];
    [self.view addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    __weak secondBookVC *weakself = self;
    self.updateConstraitsBlcok = ^(CGFloat height){
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_bottom);
            make.left.equalTo(weakself.view);
            make.right.equalTo(weakself.view);
            make.height.equalTo(@(45+height));
        }];
    };
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查询可用教室" forState:UIControlStateNormal];
    [btn.layer setBorderWidth:1.0];
    [btn.layer setBorderColor:[UIColor hexChangeFloat:@"00a0e9"].CGColor];
    [btn.layer setCornerRadius:18.0];
    [btn setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(_label.mas_bottom).offset(40);
    }];
    [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)touchDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"00a0e9"]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)buttonClick:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    if ([self.detailLable.text isEqualToString:@"请选择预约日期"] || [_beginL.text isEqualToString:@"请选择预约起始时间"] || [self.endL.text isEqualToString:@"请选择预约结束时间"] || _label.text.length == 0||[_label.text isEqualToString:@"使用原因"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"预约时间信息不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIBarButtonItem *returnBarBtn = [[UIBarButtonItem alloc] init];
        [returnBarBtn setTitle:@""];
        self.navigationItem.backBarButtonItem = returnBarBtn;
        roomVC *vc = [[roomVC alloc] init];
        
        //    vc.date = @"2016-11-13";
        //
        //    vc.beginTime = @"08:00";
        //
        //    vc.endTime = @"10:00";
        //
        //    vc.useCause = @"地理信息基础";
        
        
        vc.date = _detailLable.text;
        vc.beginTime = [_beginL.text substringFromIndex:2];
        vc.endTime = [_endL.text substringFromIndex:2];
        vc.dateForApi = self.dateForAPI;
        vc.useCause = self.label.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UIView *)createView:(UIImage *)image andLabel:(NSString *)detailText {
    UIView *view = [[UIView alloc] init];
    UITapGestureRecognizer *gestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToCalendarPicer:)];
    [view addGestureRecognizer:gestureRecongnizer];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image highlightedImage:nil];
    _detailLable = [[UILabel alloc] init];
    [_detailLable setTextColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    [_detailLable setText:detailText];
    [view addSubview:imgView];
    [view addSubview:_detailLable];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.centerY.equalTo(view);
        make.height.equalTo(imgView.mas_width);
        make.width.equalTo(@15);
    }];
    [_detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(20);
        make.centerY.equalTo(view);
    }];
    return view;
}
- (UIView *)createViewWithImage:(UIImage *)image andBeginTime:(NSString *)begin andEndTime:(NSString *)end{
    UIView *view = [[UIView alloc] init];
    //[view setBackgroundColor:[UIColor redColor]];
    
    
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:[UIColor colorWithRed:237/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    
    UIView *upView = [[UIView alloc] init];
    [upView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickBeginTime:)]];
//    [upView setBackgroundColor:[UIColor blackColor]];
    [view addSubview:upView];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view.mas_centerY).offset(-1);
        make.top.equalTo(view).offset(1);
    }];
    
    UIImageView *imagView = [[UIImageView alloc] initWithImage:image];
    [upView addSubview:imagView];
    [imagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.centerY.equalTo(view).multipliedBy(0.5).offset(1);
        make.width.equalTo(imagView.mas_height);
        make.height.equalTo(@15);
    }];
    
    _beginL = [[UILabel alloc] init];
    [_beginL setTextColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    [_beginL setText:begin];
    [upView addSubview:_beginL];
    [_beginL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imagView.mas_right).offset(20);
        make.centerY.equalTo(imagView);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    [line2 setBackgroundColor:[UIColor colorWithRed:237/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
    [view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beginL);
        make.right.equalTo(view);
        make.height.equalTo(@1);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    UIView *downView = [[UIView alloc] init];
    [downView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickEndTime:)]];
//    [downView setBackgroundColor:[UIColor redColor]];
    [view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom);
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view.mas_bottom).offset(-1);
    }];
    
    _endL = [[UILabel alloc] init];
    [_endL setTextColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    [_endL setText:end];
    [downView addSubview:_endL];
    [_endL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beginL);
        make.centerY.equalTo(view).multipliedBy(1.5);
    }];
    UIView *line3 = [[UIView alloc] init];
    [line3 setBackgroundColor:[UIColor colorWithRed:225/255.0 green:228/255.0 blue:229/255.0 alpha:1.0]];
    [downView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.equalTo(@1);
    }];
    return view;
}
- (UIView *)createCauseView:(UIImage *)image andCause:(NSString *)string {
    UIView *view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor redColor]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.centerY.equalTo(view);
        make.width.equalTo(imgView.mas_height);
        make.height.equalTo(@15);
    }];
    
    
    
    _label = [[CMInputView alloc] init];
    _label.delegate = self;
    [_label setTintColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    [_label setFont:[UIFont systemFontOfSize:14.0]];
    [_label setPlaceholder:string];
    [_label setText:@"使用原因"];
    [_label setPlaceholderColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    [_label setTextColor:[UIColor hexChangeFloat:@"9fa0a0"]];
    
    
    //[label setText:string];
    [view addSubview:_label];
    
    UILabel *orderL = [[UILabel alloc] init];
    [orderL setTextAlignment:NSTextAlignmentCenter];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"*必填"];
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor redColor]};
    [str setAttributes:dict range:NSMakeRange(0, 1)];
    NSDictionary *dict1 = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    [str setAttributes:dict1 range:NSMakeRange(1, str.length-1)];
    [orderL setAttributedText:str];
    
    
    [view addSubview:orderL];
    [orderL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-9);
        make.centerY.equalTo(view);
        make.width.equalTo(@40);
    }];
    
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(20);
        make.right.equalTo(orderL.mas_left);
//        make.centerY.equalTo(view);
        make.top.equalTo(view).offset(5);
//        make.height.equalTo(@30);
        
    }];
    [_label textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = _label.frame;
        frame.size.height = textHeight;
        _label.frame = frame;
        self.updateConstraitsBlcok(textHeight);
        
        
//        CGRect frame1 = view.frame;
//        frame1.size.height = textHeight * 1.5;
//        view.frame = frame1;
//        [view setNeedsLayout];
//        [view layoutIfNeeded];
    }];
//    _label.maxNumberOfLines = 4;
    
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:[UIColor colorWithRed:237/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        //make.bottom.equalTo(view);
        make.height.equalTo(@1);
        make.top.equalTo(_label.mas_bottom).offset(5);
    }];
    return view;
}
- (void)pickBeginTime:(UITapGestureRecognizer *)sender {
    [_label resignFirstResponder];
    [self getCurrentDate];
    _alertWindow= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_alertWindow setWindowLevel:UIWindowLevelAlert];
    [_alertWindow makeKeyAndVisible];
    //    [_alertWindow setBackgroundColor:[UIColor blackColor]];
    [_alertWindow setUserInteractionEnabled:YES];
    
    _view1 = [[UIView alloc] init];
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [_backgroundView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    [_backgroundView addSubview:_view1];
    [_alertWindow addSubview:_backgroundView];
    [_view1 setBackgroundColor:[UIColor whiteColor]];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_alertWindow);
        make.left.equalTo(_alertWindow);
        make.right.equalTo(_alertWindow);
        if (ScreenHeight == 480) {
            make.height.equalTo(@(180));
        }else{
            make.height.equalTo(@((ScreenHeight-64)/3.0));
        }
    }];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTag:0];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:96/255.0 green:95/255.0 blue:95/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_view1 addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view1).offset(30);
        make.top.equalTo(_view1).offset(20);
    }];
    [leftBtn addTarget:self action:@selector(cancle1:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTag:1];
    [rightBtn setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_view1 addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_view1).offset(-30);
        make.top.equalTo(_view1).offset(20);
    }];
    [rightBtn addTarget:self action:@selector(cancle1:) forControlEvents:UIControlEventTouchUpInside];
    _pickerView = [[UIPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_view1 addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_view1).offset(50);
//        make.centerX.equalTo(_view1);
//        make.height.equalTo(@120);
//        make.width.equalTo(@200);
        make.left.equalTo(_view1);
        make.right.equalTo(_view1);
        make.bottom.equalTo(_view1);
        make.top.equalTo(_view1).offset(50*ScreenHeight/568.0);
    }];

}
- (void)pickEndTime:(UITapGestureRecognizer *)sender {
    [self pickDate];
}

- (void)pickDate {
    [_label resignFirstResponder];
    [self getCurrentDate];
    _alertWindow= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_alertWindow setWindowLevel:UIWindowLevelAlert];
    [_alertWindow makeKeyAndVisible];
//    [_alertWindow setBackgroundColor:[UIColor blackColor]];
    [_alertWindow setUserInteractionEnabled:YES];
    
    _view1 = [[UIView alloc] init];
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [_backgroundView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    [_backgroundView addSubview:_view1];
    [_alertWindow addSubview:_backgroundView];
    [_view1 setBackgroundColor:[UIColor whiteColor]];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_alertWindow);
        make.left.equalTo(_alertWindow);
        make.right.equalTo(_alertWindow);
        if (ScreenHeight == 480) {
            make.height.equalTo(@(180));
        }else{
            make.height.equalTo(@((ScreenHeight-64)/3.0));
        }
    }];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTag:0];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:96/255.0 green:95/255.0 blue:95/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_view1 addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view1).offset(30);
        make.top.equalTo(_view1).offset(20);
    }];
    [leftBtn addTarget:self action:@selector(cancle2:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTag:1];
    [rightBtn setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_view1 addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_view1).offset(-30);
        make.top.equalTo(_view1).offset(20);
    }];
    [rightBtn addTarget:self action:@selector(cancle2:) forControlEvents:UIControlEventTouchUpInside];
//    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [datePicker setDatePickerMode:UIDatePickerModeDate];
//    [view addSubview:datePicker];
//    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view).offset(50);
//        make.centerX.equalTo(view);
//        make.height.equalTo(@120);
//        make.width.equalTo(@200);
//    }];
    _pickerView = [[UIPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_view1 addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_view1).offset(50);
//        make.centerX.equalTo(_view1);
//        make.height.equalTo(@120);
//        make.width.equalTo(@200);
        make.left.equalTo(_view1);
        make.right.equalTo(_view1);
        make.bottom.equalTo(_view1);
        make.top.equalTo(_view1).offset(50*ScreenHeight/568.0);
    }];
}
- (void)jumpToCalendarPicer:(UITapGestureRecognizer *)sender {
//    DIYCalendarVC *vc = [[DIYCalendarVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [_label resignFirstResponder];
    _alertWindow= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_alertWindow setWindowLevel:UIWindowLevelAlert];
    [_alertWindow makeKeyAndVisible];
    //    [_alertWindow setBackgroundColor:[UIColor blackColor]];
    [_alertWindow setUserInteractionEnabled:YES];
    
    _view1 = [[UIView alloc] init];
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [_backgroundView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    [_backgroundView addSubview:_view1];
    [_alertWindow addSubview:_backgroundView];
    [_view1 setBackgroundColor:[UIColor whiteColor]];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_alertWindow);
        make.left.equalTo(_alertWindow);
        make.right.equalTo(_alertWindow);
        if (ScreenHeight == 480.0) {
            make.height.equalTo(@(ScreenHeight/2.5));
        }else{
            make.height.equalTo(@(ScreenHeight/3.0));
        }
        
    }];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTag:0];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:96/255.0 green:95/255.0 blue:95/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_view1 addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view1).offset(30);
        make.top.equalTo(_view1).offset(20);
    }];
    [leftBtn addTarget:self action:@selector(cancle2:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTag:1];
    [rightBtn setTitleColor:[UIColor hexChangeFloat:@"00a0e9"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_view1 addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_view1).offset(-30);
        make.top.equalTo(_view1).offset(20);
    }];
    [rightBtn addTarget:self action:@selector(makesure:) forControlEvents:UIControlEventTouchUpInside];
    
    _datePicker = [[UIDatePicker alloc] init];
    [_datePicker setDate:[NSDate date] animated:YES];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date1 = [NSDate date];
    [_datePicker setMinimumDate:date1];
    NSDate *date2 = [date1 dateByAddingTimeInterval:6*24*3600];
    [_datePicker setMaximumDate:date2];
    _datePicker.locale = locale;
    [_view1 addSubview:_datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_view1).offset(50);
//        make.centerX.equalTo(_view1).offset(12);
//        make.height.equalTo(@120);
//        make.width.equalTo(@240);
        make.left.equalTo(_view1);
        make.right.equalTo(_view1);
        make.bottom.equalTo(_view1);
        make.top.equalTo(_view1).offset(50*ScreenHeight/568.0);
    }];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//    __weak secondBookVC *weakSelf = self;
//    NSString *dateStr = [formatter stringFromDate:datePicker.date];
//    self.block = ^{
//        weakSelf.detailLable.text = dateStr;
//    };
    
//    _pickerView = [[UIPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    _pickerView.delegate = self;
//    _pickerView.dataSource = self;
//    [_view1 addSubview:_pickerView];
//    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_view1).offset(50);
//        make.centerX.equalTo(_view1);
//        make.height.equalTo(@120);
//        make.width.equalTo(@200);
//    }];

    
}
- (void)dateChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    self.detailLable.text = [formatter stringFromDate:sender.date];
    if (![_beginL.text isEqualToString:@"请选择预约起始时间"] || ![_endL.text isEqualToString:@"请选择预约结束时间"]) {
        [_beginL setText:@"请选择预约起始时间"];
        [_endL setText:@"请选择预约结束时间"];
        _startBookTime = nil;
        _endBookTime = nil;
    }
}
- (void)cancle1:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.backgroundView removeFromSuperview];
        [_alertWindow resignKeyWindow];
        _alertWindow = nil;
        
    }else if (sender.tag == 1){
        NSInteger row1 = [self.pickerView selectedRowInComponent:0];
        NSString *str1 = self.datas1[row1];
        NSInteger row2 = [self.pickerView selectedRowInComponent:2];
        NSString *str2 = self.datas2[row2];
        self.startBookTime = [NSString stringWithFormat:@"%@:%@",str1,str2];
        if (self.endBookTime && [self moreOrLess:self.startBookTime withTimeStr2:self.endBookTime] == NSOrderedDescending) {
            self.startBookTime = nil;
            [self.backgroundView removeFromSuperview];
            [_alertWindow resignKeyWindow];
            _alertWindow = nil;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"预约的开始时间不能晚于结束时间！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else if(self.endBookTime && [self moreOrLess:self.startBookTime withTimeStr2:self.endBookTime] == NSOrderedSame){
            
            self.startBookTime = nil;
            
            [self.backgroundView removeFromSuperview];
            [_alertWindow resignKeyWindow];
            _alertWindow = nil;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"预约的开始时间不能和结束时间一样！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            NSString *string = [NSString stringWithFormat:@"起  %@:%@",str1,str2];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:string];
            [string2 setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:28/255.0 green:176/255.0 blue:110/255.0 alpha:1.0]} range:NSMakeRange(0, 1)];
            [self.beginL setAttributedText:string2];
            [self.backgroundView removeFromSuperview];
            [_alertWindow resignKeyWindow];
            _alertWindow = nil;
        }
    }
}
- (void)cancle2:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.backgroundView removeFromSuperview];
        [_alertWindow resignKeyWindow];
        _alertWindow = nil;
    }else if (sender.tag == 1){
        NSInteger row1 = [self.pickerView selectedRowInComponent:0];
        NSString *str1 = self.datas1[row1];
        NSInteger row2 = [self.pickerView selectedRowInComponent:2];
        NSString *str2 = self.datas2[row2];
        self.endBookTime = [NSString stringWithFormat:@"%@:%@",str1,str2];
        if (self.startBookTime && [self moreOrLess:self.startBookTime withTimeStr2:self.endBookTime] == NSOrderedSame) {
            [self.backgroundView removeFromSuperview];
            [_alertWindow resignKeyWindow];
            _alertWindow = nil;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"预约的结束时间不能和开始时间一样！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];

        }else if (self.startBookTime && [self moreOrLess:self.startBookTime withTimeStr2:self.endBookTime] == NSOrderedDescending){
            [self.backgroundView removeFromSuperview];
            [_alertWindow resignKeyWindow];
            _alertWindow = nil;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"预约的结束时间不能早于开始时间！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];

        }else{
            NSString *string = [NSString stringWithFormat:@"止  %@:%@",str1,str2];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:string];
            [string2 setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:163/255.0 blue:85/255.0 alpha:1.0]} range:NSMakeRange(0, 1)];
            [self.endL setAttributedText:string2];
            [self.backgroundView removeFromSuperview];
            [_alertWindow resignKeyWindow];
            _alertWindow = nil;
        }
    }
}
- (NSComparisonResult)moreOrLess:(NSString *)timeStr1 withTimeStr2:(NSString *)timeStr2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date1 = [formatter dateFromString:timeStr1];
    NSDate *date2 = [formatter dateFromString:timeStr2];
    NSComparisonResult result =[date1 compare:date2];
    return result;
}
- (void)getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *hourStr = [dateStr substringToIndex:2];
    self.hour = [hourStr intValue];
//    NSLog(@"hour == %d",_hour);
    NSString *minuteStr = [dateStr substringFromIndex:3];
    self.minute = [minuteStr intValue];
//    NSLog(@"minute == %d",_minute);
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    self.selectedDate = [formatter stringFromDate:[NSDate date]];
}
- (void)makesure:(UIButton *)sender {
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    self.detailLable.text = [formatter stringFromDate:_datePicker.date];
    NSLog(@"%@",self.detailLable.text);
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateForAPI = [formatter stringFromDate:_datePicker.date];
    NSLog(@"%@",self.dateForAPI);
    [self.backgroundView removeFromSuperview];
    [_alertWindow resignKeyWindow];
    _alertWindow = nil;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([_label.text isEqualToString:@"使用原因"]) {
        [_label setText:@""];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_label.text.length == 0) {
        [_label setText:@"使用原因"];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.datas1.count;
    }else if (component == 1){
        return 1;
    }else{
        return self.datas2.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.datas1[row];
    }else if (component == 1){
        return @":";
    }else{
        return self.datas2[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //选中某一行后刷新 目的：在当前时段内分钟从当前分钟开始 选中非当前小时时，分钟从0开始，所以要刷新来展现从当前分钟开始和选中非当前小时分钟从0开始两种情况。
    [self getCurrentDate];
    //如果点击的是第一个滚轮 那么设置第三个滚轮当前选中行为0，即从头开始.
    if (component == 0 ) {
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    [pickerView reloadAllComponents];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 1) {
        return 15;
    }else{
        return 40;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

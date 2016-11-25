//
//  DIYCalendarVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/11/11.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "DIYCalendarVC.h"
#import "SZCalendarPicker.h"
#import "Masonry.h"

@interface DIYCalendarVC ()
@property(nonatomic,copy)NSString *selectedDateStr;
@end

@implementation DIYCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtn:)]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    SZCalendarPicker *calendarPicer = [[[NSBundle mainBundle] loadNibNamed:@"SZCalendarPicker" owner:self options:nil] firstObject];
    [self.view addSubview:calendarPicer];
    [calendarPicer setAlpha:1.0];
//    [calendarPicer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(0);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.height.equalTo(self.view).multipliedBy(3/8);
//    }];
    [calendarPicer setBackgroundColor:[UIColor redColor]];
    calendarPicer.today = [NSDate date];
    
    calendarPicer.date = calendarPicer.today;
    calendarPicer.frame = CGRectMake(0, 0, self.view.frame.size.width, 352);
    calendarPicer.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
    };
    
    
    // Do any additional setup after loading the view.
}
- (void)rightBarBtn:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        nil;
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

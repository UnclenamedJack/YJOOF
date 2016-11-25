//
//  SecondTimerVC-Clock.m
//  ProjectOne-weibao
//
//  Created by jack on 16/10/11.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "SecondTimerVC-Clock.h"
#import "HYBClockView.h"
#import "HYBAnimationClock.h"



@interface SecondTimerVC_Clock ()
@property (nonatomic,strong) HYBClockView *clockView;
@end

@implementation SecondTimerVC_Clock

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat x = ([UIScreen mainScreen].bounds.size.width - 200) / 2;
    self.clockView = [[HYBClockView alloc] initWithFrame:CGRectMake(x, 40, 200, 200)
                                               imageName:@"clock"];
    HYBAnimationClock *aniClockView = [[HYBAnimationClock alloc] initWithFrame:CGRectMake(x, 250, 200, 200)
                                                                     imageName:@"clock"];
    [self.view addSubview:aniClockView];
    [self.clockView releaseTimer];
    self.clockView = nil;
    // Do any additional setup after loading the view.
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

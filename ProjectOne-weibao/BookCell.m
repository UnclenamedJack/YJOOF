//
//  BookCell.m
//  ProjectOne-weibao
//
//  Created by jack on 16/10/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "BookCell.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "UIColor+Extend.h"
#import "MBProgressHUD.h"
#import "Header.h"


@interface BookCell ()

@end

@implementation BookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(self.contentView).multipliedBy(0.3);
        }];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDown)];
        [view addGestureRecognizer:gestureRecognizer];
        
        self.classRoom = [[UILabel alloc] init];
        //[_classRoom setText:@"信息学院A201"];
        [_classRoom setText:self.roomName];
        [_classRoom setTextColor:[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0]];
        [_classRoom setFont:[UIFont systemFontOfSize:13.0]];
        [_classRoom setAdjustsFontSizeToFitWidth:YES];
        [view addSubview:_classRoom];
        [_classRoom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.left.equalTo(self.contentView).offset(10);
            make.height.equalTo(@(94/4.0));
        }];
        
        UIImageView *jiantou = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-small"]];
        [view addSubview:jiantou];
        [jiantou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(_classRoom).offset(7);
            make.bottom.equalTo(_classRoom).offset(-7);
            make.width.equalTo(jiantou.mas_height).multipliedBy(0.58);
        }];
        
        
        self.status = [[UILabel alloc] init];
        [_status setText:@"通过"];
        [_status setFont:[UIFont systemFontOfSize:13.0]];
        [_status setTextColor:[UIColor colorWithRed:28/255.0 green:181/255.0 blue:235/255.0 alpha:1.0]];
        [view addSubview:_status];
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-129/4.0);
            make.centerY.equalTo(_classRoom);
        }];
        
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0]];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_classRoom);
            make.right.equalTo(self.contentView);
            //make.top.equalTo(self.contentView).offset(94/4.0);
            make.top.equalTo(view.mas_bottom);
            make.height.equalTo(@(1));
            
        }];
        
        self.date = [[UILabel alloc] init];
        [_date setFont:[UIFont systemFontOfSize:13.0]];
        [_date setTextColor:[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0]];
        [_date setText:[NSString stringWithFormat:@"预约日期：%@",self.startDate]];
        [self.contentView addSubview:_date];
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(35/4.0);
            make.left.equalTo(line);
        }];
        
        self.time = [[UILabel alloc] init];
        [_time setFont:[UIFont systemFontOfSize:13.0]];
        [_time setTextColor:[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0]];
        [_time setText:[NSString stringWithFormat:@"预约时间：%@",self.startTime]];
        [self.contentView addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_date.mas_bottom).offset(35/4.0);
            make.left.equalTo(_date);
            
        }];
        
        self.classCount = [[UILabel alloc] init];
        [_classCount setFont:[UIFont systemFontOfSize:13.0]];
        [_classCount setTextColor:[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0]];
        [_classCount setText:[NSString stringWithFormat:@"预约课时：共%@节",self.classNum]];
        [self.contentView addSubview:_classCount];
        [_classCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_time);
            make.top.equalTo(_time.mas_bottom).offset(40/4.0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-35/4.0);
        }];
        
        
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        [_cancleBtn setTitle:@"取消预约" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor colorWithRed:28/255.0 green:181/255.0 blue:235/255.0 alpha:1.0] forState:UIControlStateNormal];
        //[_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [_cancleBtn.layer setBorderColor:[UIColor colorWithRed:28/255.0 green:181/255.0 blue:235/255.0 alpha:1.0].CGColor];
        [_cancleBtn.layer setBorderWidth:1.0];
        [_cancleBtn.layer setCornerRadius:12];
        
        [self.contentView addSubview:_cancleBtn];
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-85*ScreenWidth/(4.0*320.0));
            make.centerY.equalTo(_time);
            make.width.equalTo(@(60*ScreenWidth/320.0));
        }];
        
        [_cancleBtn addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
        [_cancleBtn addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"changeCellStatusColor" object:nil];
        
        
    }
    
    return self;
    
}
- (void)receiveNoti:(NSNotification *)sender{
    [self.status setTextColor:[UIColor grayColor]];
    [self.cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancleBtn.layer setBorderColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor];
    //???
    [self.cancleBtn setEnabled:NO];
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}
- (void)touchDown{
    if (self.block) {
        self.block();
    }
}
- (void)clickDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor hexChangeFloat:@"0094e9"]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)cancleButtonClick:(UIButton *)sender{
    [sender setEnabled:NO];
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor colorWithRed:28/255.0 green:181/255.0 blue:235/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sender setHidden:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSDictionary *parameters = @{@"acoutid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"ids":[NSString stringWithFormat:@"%zd",self.ids],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    NSLog(@"<??>%@",parameters);
    [manager POST:CANCLEBOOKINFO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if(self.block1 && [responseObject[@"result"] isEqual:@1]      ){
            self.block1(responseObject[@"msg"]);
        }
        if([responseObject[@"msg"] isEqualToString:@"请重新登录！"]){
            self.block2?self.block2(responseObject[@"msg"]):nil;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)deleteOneSectionOnServer{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSDictionary *parameters = @{@"acoutid":[[NSUserDefaults standardUserDefaults] objectForKey:@"yktid"],@"ids":[NSString stringWithFormat:@"%zd",self.ids],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"]};
    [manager POST:DELETBOOKINFO parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.block2?self.block2(responseObject[@"msg"]):nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

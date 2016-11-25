//
//  BtnView.m
//  ProjectOne-weibao
//
//  Created by jack on 16/6/18.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "BtnView.h"
#import "Masonry.h"
#import "Header.h"
#import "UIColor+Extend.h"

@implementation BtnView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor hexChangeFloat:@"fafafa"]];
        self.gestureRecongnizer = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.gestureRecongnizer];
        
        self.className = [[UILabel alloc] init];
        [self.className setAdjustsFontSizeToFitWidth:YES];
        [self.className setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:self.className];
        [self.className mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            if (kHeight == 480) {
                make.top.equalTo(self).offset(8);
            }else {
                make.top.equalTo(self).offset(17*kHeight/736.0);
            }
        }];
        
        self.classTime = [[UILabel alloc] init];
        [self.classTime setFont:[UIFont systemFontOfSize:10.0]];
        [self.classTime setTextColor:[UIColor hexChangeFloat:@"c5c5c5"]];
        [self.classTime setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:self.classTime];
        [self.classTime mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kHeight == 480) {
                make.top.equalTo(_className.mas_bottom).offset(7);
            }else{
                make.top.equalTo(_className.mas_bottom).offset(15*kHeight/667.0);
            }
            make.centerX.equalTo(_className);
            //make.bottom.equalTo(self).offset(-44*kHeight/736.0);
            make.left.greaterThanOrEqualTo(self);
            make.right.lessThanOrEqualTo(self);
        }];
        
    }
    [self.layer setBorderWidth:1.0];
    [self.layer setBorderColor:[UIColor hexChangeFloat:@"c5c5c5"].CGColor];
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
   
}
*/

@end

//
//  BtnView.h
//  ProjectOne-weibao
//
//  Created by jack on 16/6/18.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtnView : UIView
@property(nonatomic,strong) UILabel *className;
@property(nonatomic,strong) UILabel *classTime;
@property(nonatomic,strong) UITapGestureRecognizer *gestureRecongnizer;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setGestureRecongnizer:(UITapGestureRecognizer *)gestureRecongnizer;
@end

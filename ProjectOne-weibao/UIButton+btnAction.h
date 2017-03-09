//
//  UIButton+btnAction.h
//  ProjectOne-weibao
//
//  Created by jack on 17/3/3.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClick)(UIButton *);

@interface UIButton (btnAction)
@property(nonatomic,copy) btnClick block;
- (void)addAction:(btnClick)block;
@end

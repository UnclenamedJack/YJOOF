//
//  DIYView.h
//  ProjectOne-weibao
//
//  Created by jack on 17/1/13.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIYView : UIView
@property(nonatomic, copy) void (^block)();
@end

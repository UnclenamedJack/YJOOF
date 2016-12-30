//
//  searchVC.h
//  ProjectOne-weibao
//
//  Created by jack on 16/12/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class searchModel;
@interface searchVC : UIViewController
@property(nonatomic, copy)NSString *mac;
@property(nonatomic, copy)void(^block)(NSString *,searchModel *);
@end

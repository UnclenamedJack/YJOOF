//
//  bindingOrHistroyBindViewController.h
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class searchModel;
@class binddingModel;
@class chapaiModel;
@interface bindingOrHistroyBindViewController : UIViewController
@property(nonatomic,copy) NSString *mac;
//@property(nonatomic, copy)NSString *num;
//@property(nonatomic, copy)NSString *name;
//@property(nonatomic, copy)NSString *departName;
//@property(nonatomic, copy)NSString *address;
//@property(nonatomic, copy)NSNumber *assetid;
@property(nonatomic,strong) searchModel *model;
@property(nonatomic,strong) binddingModel *model1;
@property(nonatomic,strong) chapaiModel *model2;
@property(nonatomic,assign) NSInteger WhatIsBinding;
@end

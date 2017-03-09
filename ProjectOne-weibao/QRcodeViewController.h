//
//  QRcodeViewController.h
//  ProjectOne-weibao
//
//  Created by jack on 16/5/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRcodeViewController : UIViewController

typedef void (^BackValue)(NSString *str);
@property(nonatomic,strong) BackValue backValue;
@property(nonatomic,assign) NSInteger identifier;
@property(nonatomic,copy) NSString *secondMac;
@property(nonatomic,strong) NSNumber *chaKongId;
@end

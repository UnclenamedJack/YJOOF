//
//  ChaKongCell.h
//  ProjectOne-weibao
//
//  Created by jack on 17/1/17.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class searchModel;
@class chapaiModel;
@class binddingModel;
@interface ChaKongCell : UICollectionViewCell
@property(nonatomic, assign)NSInteger index;
//@property(nonatomic, copy)NSString *mac;
//@property(nonatomic, strong)NSNumber *number;
//@property(nonatomic, copy)NSString *device;
@property(nonatomic, strong)searchModel *model;
@property(nonatomic, strong)binddingModel *model1;
@property(nonatomic, strong)chapaiModel *model2;
@property(nonatomic, assign)BOOL isBinding;
@property(nonatomic, copy)void (^blcok)();
@end

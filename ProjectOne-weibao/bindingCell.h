//
//  bindingCell.h
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class searchModel;
@class binddingModel;
@interface bindingCell : UITableViewCell
@property(nonatomic, strong)searchModel *model;
@property(nonatomic, strong)binddingModel *model1;
@property(nonatomic, copy)void(^cancelBlock)(UIButton *);
@property(nonatomic, strong)NSNumber *hubid;

@property(nonatomic, strong)UILabel *label1;
@property(nonatomic, strong)UILabel *label2;
@property(nonatomic, strong)UILabel *label3;
@property(nonatomic, strong)UILabel *label4;
@property(nonatomic, strong)UIButton *btn;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

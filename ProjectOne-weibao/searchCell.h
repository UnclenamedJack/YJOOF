//
//  searchCell.h
//  ProjectOne-weibao
//
//  Created by jack on 16/12/29.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class searchModel;
@interface searchCell : UITableViewCell
@property(nonatomic, strong)UILabel *label1;
@property(nonatomic, strong)UILabel *label2;
@property(nonatomic, strong)UILabel *label3;
@property(nonatomic, strong)UILabel *label4;
@property(nonatomic, strong)searchModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

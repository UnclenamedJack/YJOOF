//
//  bindingCell.h
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class binddingModel;
@interface bindingCell : UITableViewCell
@property(nonatomic, strong)binddingModel *model;
@property(nonatomic, copy)void(^cancelBlock)();

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

//
//  forthCell.h
//  ProjectOne-weibao
//
//  Created by jack on 16/7/27.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forthCell : UITableViewCell


@property(nonatomic,strong) NSString *idStr;
@property(nonatomic,assign) NSInteger index;

@property (weak, nonatomic)  UIButton *iconBTN;
@property (weak, nonatomic)  UIButton *nameBTN;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

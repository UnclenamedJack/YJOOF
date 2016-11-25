//
//  ThreeCell.h
//  ProjectOne-weibao
//
//  Created by jack on 16/7/4.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeCell : UITableViewCell

@property(nonatomic,strong) NSString *idStr;
@property(nonatomic,assign) NSInteger index;

@property (weak, nonatomic) IBOutlet UIButton *iconBTN;
@property (weak, nonatomic) IBOutlet UIButton *nameBTN;


@property (nonatomic, copy) void (^block)();
@property (nonatomic ,copy) void (^block2)();
@property (nonatomic,copy) void (^block3)();
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

//
//  BookCell.h
//  ProjectOne-weibao
//
//  Created by jack on 16/10/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UITableViewCell
@property(nonatomic,copy) void(^block)();
@property(nonatomic,copy) void(^block1)(NSString *str);
@property(nonatomic,copy) void(^block2)(NSString *str);
@property(nonatomic,strong) UILabel *status;
@property(nonatomic,strong) UIButton *cancleBtn;
@property(nonatomic,strong) UILabel *classRoom;
@property(nonatomic,strong) UILabel *date;
@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UILabel *classCount;

@property(nonatomic,copy)NSString *roomName;
@property(nonatomic,copy)NSString *startDate;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,assign)NSNumber *classNum;
@property(nonatomic,assign)NSInteger ids;
-(void)deleteOneSectionOnServer;
@end

//
//  SmallScrollView.h
//  腾讯新闻
//
//  Created by qingyun on 16/1/25.
//  Copyright (c) 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallScrollView : UIScrollView
@property(nonatomic,strong)UIColor  *selectedColor;
@property(nonatomic)NSInteger index;
@property(nonatomic,strong)void (^changeIndexValue)(NSInteger);
@property(nonatomic)int currentIndex;
@property(nonatomic,strong) NSString *btnTitle;
-(instancetype)initWithButtonsArr:(NSArray *)arr;
@end

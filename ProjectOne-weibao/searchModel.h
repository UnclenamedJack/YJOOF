//
//  searchModel.h
//  ProjectOne-weibao
//
//  Created by jack on 16/12/29.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchModel : NSObject
@property(nonatomic, copy)NSString *num;
@property(nonatomic, copy)NSString *device;
@property(nonatomic, copy)NSString *college;
@property(nonatomic, copy)NSString *room;
@property(nonatomic, assign)double assetid;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

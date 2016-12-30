//
//  binddingModel.h
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface binddingModel : NSObject
@property(nonatomic, copy)NSString *num;
@property(nonatomic, copy)NSString *device;
@property(nonatomic, copy)NSString *college;
@property(nonatomic, copy)NSString *room;
@property(nonatomic, strong)NSNumber *assetid;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

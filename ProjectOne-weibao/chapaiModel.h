//
//  chapaiModel.h
//  ProjectOne-weibao
//
//  Created by jack on 17/1/6.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chapaiModel : NSObject
@property(nonatomic, copy)NSString *macDress;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, strong)NSNumber *machineid;
@property(nonatomic, strong)NSNumber *type;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
@end

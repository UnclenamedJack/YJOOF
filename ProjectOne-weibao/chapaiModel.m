//
//  chapaiModel.m
//  ProjectOne-weibao
//
//  Created by jack on 17/1/6.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "chapaiModel.h"

@implementation chapaiModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _macDress = dict[@"mac"];
        _name = dict[@"name"];
    }
    return self;
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc]initWithDictionary:dict];
}

@end

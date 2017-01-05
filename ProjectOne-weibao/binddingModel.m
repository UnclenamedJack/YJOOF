//
//  binddingModel.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/30.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "binddingModel.h"

@implementation binddingModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.num = dict[@"num"];
        self.device = dict[@"name"];
        self.college = dict[@"deptname"];
        self.room = dict[@"address"];
        self.machineid = dict[@"machineid"];
    }
    return self;
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}
@end

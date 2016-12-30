//
//  searchModel.m
//  ProjectOne-weibao
//
//  Created by jack on 16/12/29.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "searchModel.h"

@implementation searchModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.num = dict[@"num"];
        self.device = dict[@"name"];
        self.college = dict[@"college"];
        self.room = dict[@"address"];
        self.assetid = [dict[@"assetid"] doubleValue];
    }
    return self;
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}
@end

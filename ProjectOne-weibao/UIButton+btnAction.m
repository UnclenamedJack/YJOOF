//
//  UIButton+btnAction.m
//  ProjectOne-weibao
//
//  Created by jack on 17/3/3.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "UIButton+btnAction.h"
#import <objc/runtime.h>

@implementation UIButton (btnAction)

- (void)addAction:(btnClick)block {
    self.block = block;
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton *)sender {
    self.block(sender);
}
static btnClick BLOCK = ^(UIButton *sender){};
- (void)setBlock:(btnClick)block {
    objc_setAssociatedObject(self, &BLOCK, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (btnClick)block{
    return objc_getAssociatedObject(self, &BLOCK);
}
@end

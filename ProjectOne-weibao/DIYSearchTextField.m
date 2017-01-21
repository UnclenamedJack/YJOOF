//
//  DIYSearchTextField.m
//  ProjectOne-weibao
//
//  Created by jack on 17/1/18.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "DIYSearchTextField.h"

@implementation DIYSearchTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += 50;
    return bounds;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    bounds.origin.x = 10;
    bounds.origin.y = 4;
    bounds.size.width = 20;
    bounds.size.height = 20;
    return bounds;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

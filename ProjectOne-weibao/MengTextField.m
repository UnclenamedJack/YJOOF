//
//  MengTextField.m
//  ProjectOne-weibao
//
//  Created by jack on 16/10/18.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "MengTextField.h"

@implementation MengTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


// 修改文本展示区域，一般跟editingRectForBounds一起重写
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+5, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+5, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}

@end

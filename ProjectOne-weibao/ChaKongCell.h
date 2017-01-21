//
//  ChaKongCell.h
//  ProjectOne-weibao
//
//  Created by jack on 17/1/17.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChaKongCell : UICollectionViewCell
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, copy)NSString *mac;
@property(nonatomic, assign)BOOL isBinding;
@property(nonatomic, copy)void (^blcok)();
@end

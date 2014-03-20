//
//  UILabel+CustomeLabel.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-4.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CustomeLabel)

//通用初始化方法
+ (UILabel *)labelWithTitle:(NSString *)title
                      frame:(CGRect)frame
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)textAlignment
                       font:(UIFont*)font
                superView:(UIView *)superView;


@end
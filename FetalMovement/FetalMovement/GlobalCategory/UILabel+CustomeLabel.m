//
//  UILabel+CustomeLabel.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-4.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "UILabel+CustomeLabel.h"

@implementation UILabel (CustomeLabel)
+ (UILabel *)labelWithTitle:(NSString *)title
                      frame:(CGRect)frame
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)textAlignment
                       font:(UIFont*)font
                  superView:(UIView *)superView
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = color;
    label.font = font;
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    [superView addSubview:label];

    return label;
}

@end

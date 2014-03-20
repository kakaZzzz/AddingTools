//
//  ADBar.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADBar : UIView
@property (nonatomic,assign) float grade;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UILabel *titleLabel;

@end

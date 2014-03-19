//
//  ADLine.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLine : UIView

@property (assign, nonatomic) CGPoint  firstPoint;
@property (assign, nonatomic) CGPoint  secondPoint;

// COLORS
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *topColor;
@property (strong, nonatomic) UIColor *bottomColor;


// ALPHA
@property (nonatomic,assign) float topAlpha;
@property (nonatomic,assign) float bottomAlpha;
@property (nonatomic,assign) float lineAlpha;

@property (nonatomic,assign) float lineWidth;

@end

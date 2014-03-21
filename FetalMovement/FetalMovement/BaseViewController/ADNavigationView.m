//
//  ADNavigationView.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//


#import "ADNavigationView.h"

#define kMargin 24/2
#define kButtonWidth 41/2
#define kButtonHeight 35/2

#define kTitleLabelWidth 100.0
#define kTitleLabelHeight 30.0
@implementation ADNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubviewsWithFrame:frame];
    }
    return self;
}
- (void)createSubviewsWithFrame:(CGRect)frame

{
    
    CGRect rect = CGRectMake((SCREEN_WIDTH - kTitleLabelWidth)/2, (frame.size.height - kTitleLabelHeight)/2, kTitleLabelWidth, kTitleLabelHeight);
    
    if (IOS7_OR_LATER) {
        rect.origin.y = 20 + (frame.size.height -20 - kTitleLabelHeight)/2;
    }

    self.titleLabel = [[UILabel alloc]initWithFrame:rect];
 
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    
    rect.origin.x = kMargin;
    if (IOS7_OR_LATER) {
        rect.origin.y = 20 + (frame.size.height -20 - kButtonWidth)/2;
    }else{
        rect.origin.y = (frame.size.height - kButtonWidth)/2;
    }
    rect.size.width = kButtonWidth;
    rect.size.height = kButtonHeight;
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = rect;
    [self addSubview:_backButton];
    
    rect.origin.x = (SCREEN_WIDTH - kMargin - kButtonWidth);

    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = rect;
    [self addSubview:_rightButton];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

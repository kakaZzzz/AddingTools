//
//  ADNavigationView.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//


#import "ADNavigationView.h"

#define kMargin 24/2
#define kButtonWidth 50/2
#define kButtonHeight 50/2

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
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - kTitleLabelWidth)/2, (frame.size.height - 20/2 - kButtonHeight), kTitleLabelWidth, kTitleLabelHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
<<<<<<< HEAD
    
    rect.origin.x = kMargin;
    if (IOS7_OR_LATER) {
        rect.origin.y = 20 + (frame.size.height -20 - kButtonWidth)/2;
    }else{
        rect.origin.y = (frame.size.height - kButtonWidth)/2;
    }
    rect.size.width = kButtonWidth;
    rect.size.height = kButtonHeight;
    
=======
>>>>>>> FETCH_HEAD
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(kMargin, frame.size.height - 24/2 - kButtonHeight , kButtonWidth, kButtonHeight);
    [self addSubview:_backButton];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(SCREEN_WIDTH - kMargin - kButtonWidth, frame.size.height - 24/2 - kButtonHeight , kButtonWidth, kButtonHeight);
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

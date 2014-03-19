//
//  ADStartRecordView.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-5.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADStartRecordView.h"
#import "ADTimeLabel.h"
#import "ADStartRecordView.h"
@interface ADStartRecordView ()
@property(nonatomic,strong) UIImageView *bgImageView;
@property(nonatomic,strong) UIButton * completeButton;
@end

@implementation ADStartRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    

    
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bgImageView.image = [UIImage imageNamed:@"start_record_bg@2x"];
    [self addSubview:_bgImageView];
    
    ADTimeLabel *timer2 = [[ADTimeLabel alloc] initWithFrame:CGRectMake(0, 0, 100, self.frame.size.height)];
    [self addSubview:timer2];
    //do some styling
    timer2.timeLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_lable_bg@2x"]];
    timer2.timeLabel.font = [UIFont systemFontOfSize:24.0f];
    timer2.timeLabel.textColor = [UIColor whiteColor];
    timer2.timeLabel.textAlignment = NSTextAlignmentCenter; //UITextAlignmentCenter is deprecated in iOS 7.0
    //fire
    [timer2 start];
 
    
    self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeButton.frame = CGRectMake(self.frame.size.width - 100/2 - 12, (self.frame.size.height - 54/2)/2, 100/2, 54/2);
    [_completeButton setBackgroundImage:[UIImage imageNamed:@"record_complete_button@2x"] forState:UIControlStateNormal];
    [_completeButton setBackgroundImage:[UIImage imageNamed:@"record_complete_button_sel@2x"] forState:UIControlStateHighlighted];
    [_completeButton setBackgroundImage:[UIImage imageNamed:@"record_complete_button_sel@2x"] forState:UIControlStateSelected];
    [_completeButton addTarget:self action:@selector(completeRecord) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_completeButton];
   
  
    
}
#pragma mark - completeButton event
- (void)completeRecord
{
    
    UIWindow *appWindow =  MAIN_WINDOW;
   
    for (UIView *subView in appWindow.subviews) {
        if ([subView isKindOfClass:[ADStartRecordView class]]) {
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
                subView.frame = CGRectMake(0, SCREEN_HEIGHT - 50 -100/2 + 100,SCREEN_WIDTH, 100/2);
            } completion:^(BOOL finished){
                [subView removeFromSuperview];
            }];

            
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EndRecordFetalMovementNotification object:nil];
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

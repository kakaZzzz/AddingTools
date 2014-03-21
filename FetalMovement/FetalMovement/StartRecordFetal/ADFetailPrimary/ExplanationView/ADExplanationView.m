//
//  ADExplanationView.m
//  FetalMovement
//
//  Created by 大头滴血 on 14-3-20.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADExplanationView.h"
#import "CAKeyframeAnimation+GLPadShake.h"

#define coverView_tag (80001)

@interface ADExplanationView()
@property (nonatomic, retain)UIView* superVirw_a;
@end

@implementation ADExplanationView
@synthesize superVirw_a;

+ (void)createShareView:(UIView *)superView{
    UIView *coverView = [[UIView alloc]initWithFrame:superView.frame];
    coverView.tag = coverView_tag;
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [superView addSubview:coverView];
    
    ADExplanationView * explanationView = [[ADExplanationView alloc]initWithFrame:CGRectMake(0, 0, 400, superView.frame.size.height)];
    explanationView.superVirw_a = superView;
    [coverView addSubview:explanationView];
    
    [explanationView showAnimation];
    
    //添加取消手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:explanationView action:@selector(tapGesture)];
    [coverView addGestureRecognizer:tapGesture];
}

- (void)tapGesture{
    NSLog(@"收回展示");
    [self removeViewInSuperView];
}

- (void)removeViewInSuperView//隐藏
{
    CGRect beginrect = self.frame;
    beginrect.origin.x = -270;
    
    UIView *coverView = (UIView *)[self.superview viewWithTag:coverView_tag];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = beginrect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [coverView removeFromSuperview];
    }];
    
}

- (void)showAnimation//显示
{
    self.frame = CGRectMake(-270, 0, 400, self.superVirw_a.frame.size.height);
    
    CGPoint centerPoint = CGPointMake(65, self.superVirw_a.frame.size.height/2);
    CALayer *layer=[self layer];
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.750] forKey:kCATransactionAnimationDuration];
    CAAnimation *chase = [CAKeyframeAnimation animationWithKeyPath:@"position"
                                                          function:BackEaseOut_a
                                                         fromPoint:[self center]
                                                           toPoint:centerPoint];
    [chase setDelegate:self];
    [layer addAnimation:chase forKey:@"position"];
    [CATransaction commit];
    [self setCenter:centerPoint];
}

CGFloat BackEaseOut_a(CGFloat p)
{
	CGFloat f = (1 - p);
	return 1 - (f * f * f - f * sin(f * M_PI));
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

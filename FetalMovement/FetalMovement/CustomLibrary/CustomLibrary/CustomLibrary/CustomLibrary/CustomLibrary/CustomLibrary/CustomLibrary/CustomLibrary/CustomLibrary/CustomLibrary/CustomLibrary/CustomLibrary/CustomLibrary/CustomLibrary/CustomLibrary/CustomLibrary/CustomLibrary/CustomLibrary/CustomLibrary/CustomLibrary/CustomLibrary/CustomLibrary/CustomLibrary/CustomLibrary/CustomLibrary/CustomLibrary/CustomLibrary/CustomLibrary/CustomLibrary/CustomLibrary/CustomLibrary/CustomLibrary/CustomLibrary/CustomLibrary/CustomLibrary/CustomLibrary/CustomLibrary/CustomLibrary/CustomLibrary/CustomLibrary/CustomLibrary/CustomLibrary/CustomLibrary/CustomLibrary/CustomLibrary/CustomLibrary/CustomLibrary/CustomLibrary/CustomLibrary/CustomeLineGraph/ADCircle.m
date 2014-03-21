//
//  ADCircle.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADCircle.h"
#import "ADLineGraphView.h"
#import "ADMarkView.h"
@implementation ADCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
       }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect edgeRect =  CGRectMake(rect.origin.x + rect.size.width/4, rect.size.height/4, rect.size.width/2, rect.size.height/2);
    
    CGContextAddEllipseInRect(ctx, edgeRect);
    [[UIColor whiteColor] set];
    CGContextFillPath(ctx);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"哈哈哈哈哈哈哈 点的值是%f",self.value);
    
    
    NSLog(@"坐标分别是.............%@",NSStringFromCGRect(self.frame));
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    // aView.center = self.center;
    aView.backgroundColor = [UIColor redColor];
    // [self addSubview:aView];
    
    
    ADLineGraphView *superView = (ADLineGraphView *)self.superview;
    superView.isDrawing = NO;
    
    
    
//    CGSize size = self.bounds.size;
//    CGPoint point = self.frame.origin;
    
    CALayer *waveLayer=[CALayer layer];
    waveLayer.frame = CGRectMake(5, 5, 14, 14);//经验值
    waveLayer.borderColor =kYellowColor.CGColor;
    waveLayer.borderWidth =1.5;
    waveLayer.cornerRadius =14/2;
    [self.layer addSublayer:waveLayer];
    
    ADMarkView *mark;
    for (UIView *aView in [superView subviews]) {
        if ([aView isKindOfClass:[ADMarkView class] ]&& (aView.tag == 2 * self.tag)) {
            mark = (ADMarkView *)aView;
        }

    }
  
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setTransform:CATransform3DMakeScale( 2.0, 2.0, 1.0)];
        //[waveLayer setTransform:CATransform3DMakeScale( 1.5, 1.5, 1.0)];
          mark.hidden = NO;
          mark.alpha = 1.0;
          
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //[waveLayer setTransform:CATransform3DMakeScale( 1.0, 1.0, 1.0)];
            [self.layer setTransform:CATransform3DMakeScale( 1.0, 1.0, 1.0)];
          
            mark.alpha = 0;
            //waveLayer.hidden = YES;
        } completion:^(BOOL finished){
            [aView removeFromSuperview];
            [waveLayer removeFromSuperlayer];
        }];
        
    }];
    
    
    //
    
    
    
}
@end

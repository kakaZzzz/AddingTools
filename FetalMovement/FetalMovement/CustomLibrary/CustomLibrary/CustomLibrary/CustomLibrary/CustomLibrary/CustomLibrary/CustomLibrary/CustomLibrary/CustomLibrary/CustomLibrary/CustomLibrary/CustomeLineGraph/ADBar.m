//
//  ADBar.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADBar.h"

@implementation ADBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapSquare;
		_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
		_chartLine.lineWidth   = self.frame.size.width;
		_chartLine.strokeEnd   = 1.0;
		self.clipsToBounds = YES;
		[self.layer addSublayer:_chartLine];
		self.layer.cornerRadius = 2.0;

        
        //
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgImageView];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  
//	UIBezierPath *progressline = [UIBezierPath bezierPath];
//    [progressline moveToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height)];
//	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2, 0.1* self.frame.size.height)];
//    [progressline setLineCapStyle:kCGLineCapSquare];
// 
//   
//	_chartLine.path = progressline.CGPath;
//    _chartLine.strokeColor = [[UIColor whiteColor] CGColor];
//	
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 1.0;
//    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//    pathAnimation.autoreverses = NO;
//    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    //动画绘制之后的值
   // _chartLine.strokeEnd = 1.0;

}


@end

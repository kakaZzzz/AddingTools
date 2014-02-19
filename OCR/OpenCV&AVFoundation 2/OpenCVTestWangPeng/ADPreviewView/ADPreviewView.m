//
//  ADPreviewView.m
//  OpenCVTestWangPeng
//
//  Created by wangpeng on 14-2-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "ADPreviewView.h"
#import "ADContours.h"
@implementation ADPreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)display
{
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    NSLog(@"绘制绘制");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 1.0);
    //CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    
	for (int i=0; i<[self.modelArray count]; i++) {
        
        
        ADContours *contours = [self.modelArray objectAtIndex:i];
        //		CGContextMoveToPoint(ctx, contours.point_x * 2.5 , contours.point_y * 2.5 );
        CGContextMoveToPoint(ctx, 320 -  contours.point_y * 2.2222, contours.point_x * 2.2222 - 10 );
        if (i == [self.modelArray count] - 1) {
            
            break;
        }
        else{
            ADContours *contourNext = [self.modelArray objectAtIndex:i + 1];
            //            CGContextAddLineToPoint(ctx, contourNext.point_x * 2.5 ,contourNext.point_y * 2.5 );
            CGContextAddLineToPoint(ctx, 320 -  contourNext.point_y * 2.2222, contourNext.point_x * 2.2222 - 10);
            NSLog(@"画线划线  %f  %f",contourNext.point_x,contourNext.point_y);
            
        }
        CGContextStrokePath(ctx);
	}
    
    
    
    
}


@end

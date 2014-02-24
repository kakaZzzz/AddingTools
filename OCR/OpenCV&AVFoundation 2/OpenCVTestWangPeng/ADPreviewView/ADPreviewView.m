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
        self.isRightStatus = NO;
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
    int yfix = -53;
    if (IPHONE_5_OR_LATER) {
        yfix = 0;
    }
    NSLog(@"绘制绘制");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 2.0);
    //CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
    
    if (self.isRightStatus) {
        CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    }else{
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    }
    
    
    if ([self.modelArray count] > 0) {
        for (int i=0; i<[self.modelArray count]; i++) {
            
//            if (i ==0 ) {
//                CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//            }else if (i == 1){
//                CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
//            }else if (i == 2){
//                CGContextSetStrokeColorWithColor(ctx, [UIColor yellowColor].CGColor);
//            }else if(i ==3){
//                CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//            }
            
            NSLog(@"轮廓点数%d",[self.modelArray count]);
            ADContours *contours = [self.modelArray objectAtIndex:i];

            CGContextMoveToPoint(ctx, 320 -  contours.point_y  , contours.point_x + yfix  );
            if (i == [self.modelArray count] - 1) {
                ADContours *contourNext = [self.modelArray objectAtIndex:0];
                CGContextAddLineToPoint(ctx, 320 -  contourNext.point_y  , contourNext.point_x + yfix );
            }
            else{
                ADContours *contourNext = [self.modelArray objectAtIndex:i + 1];

                CGContextAddLineToPoint(ctx, 320 -  contourNext.point_y  , contourNext.point_x + yfix);
                NSLog(@"画线划线  %f  %f",contourNext.point_x,contourNext.point_y);
                
            }
            CGContextStrokePath(ctx);
        }
        
    }
    
    
    
}


@end

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
        
    [self.layer addSublayer:self.focusBox];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击屏幕 实现聚焦");
    
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:touch.view];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        double  screenWidth = screenRect.size.width;
        double  screenHeight = screenRect.size.height;
        double focus_x = touchPoint.x/screenWidth;
        double focus_y = touchPoint.y/screenHeight;
        CGPoint resultPoint = CGPointMake(touchPoint.x, touchPoint.y);
        //CGPoint resultPoint = CGPointMake(focus_x, focus_y);
        
        if (_delegate && [_delegate respondsToSelector:@selector(previewView:focusAtPoint:)]) {
            
            [_delegate previewView:self focusAtPoint:resultPoint];
        }
        
        // NSLog(@"x = %f, y = %f", touchPoint.x, touchPoint.y);
    }];
}

#pragma mark - Focus / Expose Box

- (CALayer *) focusBox
{
    if ( !_focusBox ) {
        _focusBox = [[CALayer alloc] init];
        [_focusBox setCornerRadius:45.0f];
        [_focusBox setBounds:CGRectMake(0.0f, 0.0f, 90, 90)];
        [_focusBox setBorderWidth:5.f];
        [_focusBox setBorderColor:[UIColor blueColor].CGColor];
        [_focusBox setOpacity:0];
    }
    
    return _focusBox;
}

- (void)draw:(CALayer *)layer atPointOfInterest:(CGPoint)point andRemove:(BOOL)remove
{
    if ( remove )
        [layer removeAllAnimations];
    
    if ( [layer animationForKey:@"transform.scale"] == nil && [layer animationForKey:@"opacity"] == nil ) {
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        [layer setPosition:point];
        [CATransaction commit];
        
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scale setFromValue:[NSNumber numberWithFloat:1]];
        [scale setToValue:[NSNumber numberWithFloat:0.7]];
        [scale setDuration:0.8];
        [scale setRemovedOnCompletion:YES];
        
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacity setFromValue:[NSNumber numberWithFloat:1]];
        [opacity setToValue:[NSNumber numberWithFloat:0]];
        [opacity setDuration:0.8];
        [opacity setRemovedOnCompletion:YES];
        
        [layer addAnimation:scale forKey:@"transform.scale"];
        [layer addAnimation:opacity forKey:@"opacity"];
    }
}

- (void) drawFocusBoxAtPointOfInterest:(CGPoint)point andRemove:(BOOL)remove
{
    [self draw:_focusBox atPointOfInterest:point andRemove:remove];
}

@end

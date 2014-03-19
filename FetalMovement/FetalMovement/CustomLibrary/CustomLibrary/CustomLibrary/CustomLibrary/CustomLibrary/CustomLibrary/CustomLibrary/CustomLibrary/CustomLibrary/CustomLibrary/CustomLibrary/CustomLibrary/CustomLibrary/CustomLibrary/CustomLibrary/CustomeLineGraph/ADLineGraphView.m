//
//  ADLineGraphView.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADLineGraphView.h"
#import "ADLine.h"
#import "ADCircle.h"
#import "ADAnimations.h"
#import "ADBar.h"
#import "ADMarkView.h"

#define kXaxisHeight (self.viewForBaselineLayout.frame.size.height   - 80/2)

#define circleSize 24.0
#define labelYaxisOffset 20.0
#define kLabelHeight 20.0

#define kXMargin 32.0
#define kYLineMargin 63.0
#define kCustomeWidth (self.viewForBaselineLayout.frame.size.width - 2 * kXMargin)
#define kCustomeLineHeight (self.viewForBaselineLayout.frame.size.height - 80/2 - kYLineMargin)

@implementation ADLineGraphView

int numberOfPoints; // The number of Points in the Graph.
int numberOfBars;
ADCircle *closestDot;
int currentlyCloser;

- (void)reloadGraph {
    _isDrawing = YES;
    [self setNeedsLayout];
}
- (void)commenInit
{
    self.labelFont = [UIFont systemFontOfSize:12];//横坐标刻度字体
    self.colorXaxisLabel = kXaxisColor;
    
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _isDrawing = YES;
        [self commenInit];
    }
    return self;
}


- (void)layoutSubviews {
    
    if (_isDrawing) {
        numberOfPoints = [self.delegate numberOfPointsInGraph]; // The number of Points in the Graph.
        self.animationDelegate = [[ADAnimations alloc] init];
        self.animationDelegate.delegate = self;
        [self drawGraph];
        [self drawXAxis];
        
    }
    
}

- (void)drawGraph {
    
    
    float gradeOfXAxis = kCustomeWidth/(numberOfPoints);
    float gradeOfYAxis;
    
    
    
    // CREATION OF THE DOTS
    
    float maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    float minValue = [self minValue]; // Smallest Y-axis value from all the points.
    
    float positionOnXAxis; // The position on the X-axis of the point currently being created.
    float positionOnYAxis; // The position on the Y-axis of the point currently being created.
    
    
    if ([self.delegate respondsToSelector:@selector(numberOfGradesInYAxis)]) {
        gradeOfYAxis = kCustomeLineHeight/[self.delegate numberOfGradesInYAxis];
        
    }else{
        gradeOfYAxis = (kCustomeLineHeight)/(maxValue - minValue);
    }
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[ADCircle class]])
            [subview removeFromSuperview];
    }
    
    for (int i = 0; i < numberOfPoints; i++) {
        
        float dotValue = [self.delegate valueForIndex:i];
        
        if (dotValue !=  0) {
            positionOnXAxis = kXMargin + gradeOfXAxis*i + gradeOfXAxis *0.5;
            positionOnYAxis = (kCustomeLineHeight) - (dotValue - minValue) *gradeOfYAxis + kYLineMargin;
            
            ADCircle *circleDot = [[ADCircle alloc] initWithFrame:CGRectMake(positionOnXAxis, positionOnYAxis, circleSize, circleSize)];
            circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
            circleDot.tag = i+100;
            circleDot.alpha = 0.0;
            circleDot.value = dotValue;
            [self addSubview:circleDot];
            
            //假逼动画
            [self.animationDelegate animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
            
            //创建markView
            ADMarkView *mark = [[ADMarkView alloc] initWithFrame:CGRectMake(positionOnXAxis, 0, 87/2, positionOnYAxis - 10)];//7为经验值
            CGPoint aCenter = mark.center;
            mark.center = CGPointMake(positionOnXAxis, aCenter.y);
            mark.markLabel.text = [NSString stringWithFormat:@"%d次",(int)dotValue];
            mark.alpha = 0.0;
            mark.hidden = YES;
            mark.tag = 2 * circleDot.tag;
            [self addSubview:mark];
        }
        else{
            positionOnXAxis = kXMargin + gradeOfXAxis *i + gradeOfXAxis *0.5;
            positionOnYAxis = (kCustomeLineHeight) - (dotValue - minValue) *gradeOfYAxis + kYLineMargin;
            
            ADCircle *circleDot = [[ADCircle alloc] initWithFrame:CGRectMake(positionOnXAxis, positionOnYAxis, 0, 0)];
            circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
            circleDot.tag = i+100;
            circleDot.alpha = 0.0;
            circleDot.value = dotValue;
            [self addSubview:circleDot];
            
            //假逼动画
            [self.animationDelegate animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
            
        }
        
    }
    
    // CREATION OF THE LINE AND BOTTOM AND TOP FILL
    
    float xDot1; // Postion on the X-axis of the first dot.
    float yDot1; // Postion on the Y-axis of the first dot.
    float xDot2; // Postion on the X-axis of the next dot.
    float yDot2; // Postion on the Y-axis of the next dot.
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[ADLine class]])
            [subview removeFromSuperview];
    }
    
    for (int i = 0; i < numberOfPoints - 1; i++) {
        
        for (ADCircle *dot in [self.viewForBaselineLayout subviews]) {
            if (dot.tag == i + 100)  {
                xDot1 = dot.center.x;
                yDot1 = dot.center.y;
                
                if (dot.value == 0) {
                    xDot1 = dot.center.x + gradeOfXAxis *0.5;
                }
            } else if (dot.tag == i + 101) {
                xDot2 = dot.center.x;
                yDot2 = dot.center.y;
                if (dot.value == 0) {
                    xDot2 = dot.center.x - gradeOfXAxis *0.5;
                }
            }
        }
        
        ADLine *line = [[ADLine alloc] initWithFrame:CGRectMake(0, 0, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
    
        line.opaque = NO;
        line.tag = i + 1000;
        line.alpha = 0.0;
        line.backgroundColor = [UIColor clearColor];
        line.firstPoint = CGPointMake(xDot1, yDot1);
        line.secondPoint = CGPointMake(xDot2, yDot2);
        line.topColor = self.colorTop;
        line.bottomColor = self.colorBottom;
        line.color = self.colorLine;
        line.topAlpha = self.alphaTop;
        line.bottomAlpha = self.alphaBottom;
        line.lineAlpha = self.alphaLine;
        line.lineWidth = self.widthLine;
        [self addSubview:line];
        [self sendSubviewToBack:line];
        
        [self.animationDelegate animationForLine:i line:line animationSpeed:self.animationGraphEntranceSpeed];
    }
    
    
    //CREATION OF THE BAR
    
    float positionOfBarXAxis; // The position on the X-axis of the point currently being created.
    
    if ([self.delegate respondsToSelector:@selector(numberOfPointsInBar)]) {
        numberOfBars = [self.delegate numberOfPointsInBar];
        
    }else{
        numberOfBars = 0;
    }
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[ADBar class]])
            [subview removeFromSuperview];
    }
    
    for (int i = 0; i<numberOfBars; i++) {
        
        float xGrage = [self.delegate xAxisOfBarForIndex:i];
        NSLog(@"绘制柱形图%f",xGrage);
        positionOfBarXAxis = kXMargin + xGrage *gradeOfXAxis;
        ADBar *bar = [[ADBar alloc] initWithFrame:CGRectMake(positionOfBarXAxis,54/2, gradeOfXAxis, kXaxisHeight - 54/2)];
        bar.backgroundColor = [UIColor clearColor];
        
        bar.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bar_bg_%d",i+ 1]];
        bar.alpha = 1.0;
        [self addSubview:bar];
        [self sendSubviewToBack:bar];
        
    }
    
    
}


// Determines the biggest Y-axis value from all the points.
- (float)maxValue {
    
    float dotValue;
    float maxValue = 0;
    
    for (int i = 0; i < numberOfPoints; i++) {
        dotValue = [self.delegate valueForIndex:i];
        
        if (dotValue > maxValue) {
            maxValue = dotValue;
        }
    }
    
    return maxValue;
}

// Determines the smallest Y-axis value from all the points.
- (float)minValue {
    float dotValue;
    float minValue = 0;
    
    for (int i = 0; i < numberOfPoints; i++) {
        dotValue = [self.delegate valueForIndex:i];
        
        if (dotValue < minValue) {
            minValue = dotValue;
        }
    }
    
    return minValue;
}

- (void)drawXAxis {
    
    
    if (![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels)]) return;
    
   
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]])
            [subview removeFromSuperview];
    }
    
    int numberOfGaps = [self.delegate numberOfGapsBetweenLabels] + 1;
    
    if (numberOfGaps >= (numberOfPoints - 1)) {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.frame.size.height - (labelYaxisOffset), self.frame.size.width/2, kLabelHeight)];
        firstLabel.text = [self.delegate labelOnXAxisForIndex:0];
        firstLabel.font = self.labelFont;
        firstLabel.textAlignment = 0;
        firstLabel.textColor =kXaxisColor;
        firstLabel.backgroundColor = [UIColor redColor];
        [self addSubview:firstLabel];
        
        UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 3, self.frame.size.height - (labelYaxisOffset), self.frame.size.width/2, kLabelHeight)];
        lastLabel.text = [self.delegate labelOnXAxisForIndex:(numberOfPoints - 1)];
        lastLabel.font = self.labelFont;
        lastLabel.textAlignment = 2;
        lastLabel.textColor =kXaxisColor;
        lastLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:lastLabel];
    } else {
        for (int i = 1; i <= (numberOfPoints/numberOfGaps) + 1; i++) {
            UILabel *labelXAxis = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 10)];
            labelXAxis.text = [self.delegate labelOnXAxisForIndex:(i * numberOfGaps - 1)];
            //[labelXAxis sizeToFit];
            [labelXAxis setCenter:CGPointMake(kXMargin + (kCustomeWidth/(numberOfPoints))*(i*numberOfGaps - 1) - 5 , self.frame.size.height - labelYaxisOffset +5)];
            labelXAxis.font = self.labelFont;
            labelXAxis.textAlignment = 1;
            labelXAxis.textColor = kXaxisColor;
            labelXAxis.backgroundColor = [UIColor clearColor];
            labelXAxis.transform = CGAffineTransformMakeRotation(-45*M_PI/180);
            [self addSubview:labelXAxis];
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, kXaxisColor.CGColor);
    
    CGContextMoveToPoint(ctx,0, kXaxisHeight);
    CGContextAddLineToPoint(ctx,kXMargin, kXaxisHeight );
    CGContextAddLineToPoint(ctx, kXMargin, kXaxisHeight + 5);
    
    for (int i = 0;i < numberOfPoints + 1 ;i++) {
        
        
        if (i == numberOfPoints) {
            
            CGContextMoveToPoint(ctx,kXMargin +(kCustomeWidth/numberOfPoints)* i, kXaxisHeight);
            CGContextAddLineToPoint(ctx,640, kXaxisHeight);
            CGContextStrokePath(ctx);
            break;
        }
        CGContextMoveToPoint(ctx,kXMargin + (kCustomeWidth/numberOfPoints)*i, kXaxisHeight );
        CGContextAddLineToPoint(ctx,kXMargin +(kCustomeWidth/numberOfPoints)* (i+1), kXaxisHeight);
        CGContextAddLineToPoint(ctx, kXMargin +(kCustomeWidth/numberOfPoints)* (i+1), kXaxisHeight + 5);
        CGContextStrokePath(ctx);
        
        
    }
    
    
}


@end

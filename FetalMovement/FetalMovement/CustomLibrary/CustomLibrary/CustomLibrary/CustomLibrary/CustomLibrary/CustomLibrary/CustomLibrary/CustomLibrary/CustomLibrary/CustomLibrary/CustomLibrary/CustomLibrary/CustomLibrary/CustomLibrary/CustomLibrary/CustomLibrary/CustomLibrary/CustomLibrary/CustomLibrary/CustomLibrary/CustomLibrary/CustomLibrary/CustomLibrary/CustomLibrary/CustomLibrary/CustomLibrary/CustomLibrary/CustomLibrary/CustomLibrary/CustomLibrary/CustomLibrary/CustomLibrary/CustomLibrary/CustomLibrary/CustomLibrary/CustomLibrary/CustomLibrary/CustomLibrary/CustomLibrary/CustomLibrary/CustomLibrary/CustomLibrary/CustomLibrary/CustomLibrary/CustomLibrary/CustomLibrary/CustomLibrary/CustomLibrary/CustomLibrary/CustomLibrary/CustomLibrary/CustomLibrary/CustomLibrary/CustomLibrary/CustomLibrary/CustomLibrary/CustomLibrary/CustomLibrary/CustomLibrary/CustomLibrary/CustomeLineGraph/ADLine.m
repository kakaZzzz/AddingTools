//
//  ADLine.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADLine.h"

@implementation ADLine

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
    
    //LINE GRAPH
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 setLineWidth:self.lineWidth];
    [path1 moveToPoint:self.firstPoint];
    [path1 addLineToPoint:self.secondPoint];
    path1.lineCapStyle = kCGLineCapRound;
    [self.color set];
    [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
    
    
    
}

@end

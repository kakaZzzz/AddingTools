//
//  ADAnimations.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADAnimations.h"

@implementation ADAnimations

// Animation of the dots
- (void)animationForDot:(NSInteger)dotIndex circleDot:(ADCircle *)circleDot animationSpeed:(NSInteger)speed {
    if (speed == 0) {
        circleDot.alpha = 1.0;
    } else {
        [UIView animateWithDuration:0.5 delay:dotIndex/(speed*2.0) options:UIViewAnimationOptionCurveEaseOut animations:^{
            circleDot.alpha = 0.7;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                circleDot.alpha = 1.0;
            } completion:nil];
        }];
    }
}

// Animation of the graph
- (void)animationForLine:(NSInteger)lineIndex line:(ADLine *)line animationSpeed:(NSInteger)speed {
    if (speed == 0) {
        line.alpha = 1.0;
    } else {
        [UIView animateWithDuration:1.0 delay:lineIndex/(speed*2.0) options:UIViewAnimationOptionCurveEaseOut animations:^{
            line.alpha = 1.0;
        } completion:^(BOOL finished){
            
                line.alpha = 1.0;
          
        }];

    }
}

@end

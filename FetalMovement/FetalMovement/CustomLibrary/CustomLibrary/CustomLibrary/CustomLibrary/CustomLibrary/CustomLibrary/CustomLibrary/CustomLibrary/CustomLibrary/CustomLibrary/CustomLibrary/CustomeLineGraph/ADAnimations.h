//
//  ADAnimations.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADCircle.h"
#import "ADLine.h"

@protocol ADAnimationDelegate <NSObject>

@end

@interface ADAnimations : NSObject
- (void)animationForDot:(NSInteger)dotIndex circleDot:(ADCircle *)circleDot animationSpeed:(NSInteger)speed;
- (void)animationForLine:(NSInteger)lineIndex line:(ADLine *)line animationSpeed:(NSInteger)speed;

@property (nonatomic,weak) id <ADAnimationDelegate> delegate;

@end

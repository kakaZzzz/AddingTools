//
//  CAKeyframeAnimation+GLPadShake.h
//  iShoppingIPadLib
//
//  Created by guowenlong on 14-3-6.
//
//

#import <QuartzCore/QuartzCore.h>
#include "GLPadEasing.h"
@interface CAKeyframeAnimation (GLPadShake)
+ (id)animationWithKeyPath:(NSString *)path function:(GLPadEasingFunction)function fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint keyframeCount:(size_t)keyframeCount;
+ (id)animationWithKeyPath:(NSString *)path function:(GLPadEasingFunction)function fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
@end

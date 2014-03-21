//
//  CAKeyframeAnimation+GLPadShake.m
//  iShoppingIPadLib
//
//  Created by guowenlong on 14-3-6.
//
//

#import "CAKeyframeAnimation+GLPadShake.h"
#if !defined(GLPadEasingDefaultKeyframeCount)
#define GLPadEasingDefaultKeyframeCount 60
#endif
@implementation CAKeyframeAnimation (GLPadShake)
+ (id)animationWithKeyPath:(NSString *)path function:(GLPadEasingFunction)function fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint keyframeCount:(size_t)keyframeCount
{
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:keyframeCount];
	
	CGFloat t = 0.0;
	CGFloat dt = 1.0 / (keyframeCount - 1);
	for(size_t frame = 0; frame < keyframeCount; ++frame, t += dt)
	{
		CGFloat x = fromPoint.x + function(t) * (toPoint.x - fromPoint.x);
		CGFloat y = fromPoint.y + function(t) * (toPoint.y - fromPoint.y);
		[values addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
	}
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
	[animation setValues:values];
	return animation;
}

+ (id)animationWithKeyPath:(NSString *)path function:(GLPadEasingFunction)function fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    return [self animationWithKeyPath:path function:function fromPoint:fromPoint toPoint:toPoint keyframeCount:GLPadEasingDefaultKeyframeCount];
}

@end

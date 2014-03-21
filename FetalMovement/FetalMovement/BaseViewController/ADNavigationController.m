//
//  ADNavigationController.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADNavigationController.h"
#import "ADAppDelegate.h"
#import "ADTabBarViewController.h"
#import "ADTabBarView.h"

@interface ADNavigationController ()
@property(nonatomic,strong) CALayer *animationLayer;
@end

@implementation ADNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //set NavigationBar
        [self setNavigationBarStyle];
    }
    return self;
}

#pragma mark - set NavigationBar
//set  NavigationBar
- (void)setNavigationBarStyle
{
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    
    /*simple color process*/
    if (IOS7_OR_LATER) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
    else{
        CGRect rect = CGRectMake(0.0f, 0.0f, 320, 44.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
        
    }
    
    self.navigationBar.translucent =NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.animationLayer = [CALayer layer] ;
    CGRect layerFrame = self.view.frame;
    layerFrame.size.height = self.view.frame.size.height-self.navigationBar.frame.size.height;
    layerFrame.origin.y = self.navigationBar.frame.size.height+20;
    _animationLayer.frame = layerFrame;
    _animationLayer.masksToBounds = YES;
    [_animationLayer setContentsGravity:kCAGravityBottomLeft];
    [self.view.layer insertSublayer:_animationLayer atIndex:0];
    _animationLayer.delegate = self;
    
    
}

#pragma mark - push 和 pop 动画效果
-(void)loadLayerWithImage
{
    
    
    UIGraphicsBeginImageContext(self.visibleViewController.view.bounds.size);
    [self.visibleViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_animationLayer setContents: (id)viewImage.CGImage];
    [_animationLayer setHidden:NO];
    
    
    
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    
    id<CAAction> action = (id)[NSNull null];
    return action;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:YES];
    
    //hide system backButton
    // [viewController.navigationItem setHidesBackButton:YES];
    
    //hide tabbar when push next VC
    //system
    viewController.hidesBottomBarWhenPushed = YES;
    //custome
    ADAppDelegate *app =(ADAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *tabController = app.window.rootViewController;
    //hide tabController's tabbar，avoid long white when push
    if ([tabController isKindOfClass:[ADTabBarViewController class]]) {
        ADTabBarViewController *tabbarControl = (ADTabBarViewController *)tabController;
        tabbarControl.tabBar.hidden = YES;
        for (UIView * tabview in [tabController.view subviews]) {
            if ([tabview isKindOfClass:[ADTabBarView class]]) {
                if (tabview.hidden == NO) {
                    tabview.hidden = YES;
                }
            }
        }

    }
    
    
}
/**
 *  返回上一级页面
 *
 *  @param animated 参数 是否动画
 *
 *  @return 返回值为上一级页面
 */
-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    NSLog(@"返回上一级");
    
    [_animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:_animationLayer above:self.view.layer];
    if(animated)
    {
        [self loadLayerWithImage];
        
        
        
        UIView * toView = [[self.viewControllers objectAtIndex:[self.viewControllers indexOfObject:self.visibleViewController]-1] view];
        
        
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setDuration:kNavigationPopAnimationDuration];
        Animation.delegate = self;
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        [_animationLayer addAnimation:Animation forKey:@"scale"];
        
        
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation1 setDuration:kNavigationPopAnimationDuration];
        Animation1.delegate = self;
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [toView.layer addAnimation:Animation1 forKey:@"scale"];
        
    }
    return [super popViewControllerAnimated:NO];
}
/**
 *   Pops until there's only a single view controller left on the stack. Returns the popped controllers
 *
 *  @param animated bool
 *
 *  @return  Returns the popped controllers
 */
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    

    
    ADAppDelegate *app = (ADAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *tabController = app.window.rootViewController;
    
    if ([tabController isKindOfClass:[ADTabBarViewController class]]) {
    for (UIView * tabview in [tabController.view subviews]) {
        if ([tabview isKindOfClass:[ADTabBarView class]]) {
            
            ADTabBarViewController *tabbarControl = (ADTabBarViewController *)tabController;
            if (tabview.hidden == YES) {
                tabview.hidden = NO;
            }
            tabbarControl.tabBar.hidden = YES;
            [tabController.view bringSubviewToFront:tabview];
        }
    }
    }
    
    
    //
    [_animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:_animationLayer above:self.view.layer];
    if(animated)
    {
        [self loadLayerWithImage];
        
        
        
        UIView * toView = [[self.viewControllers objectAtIndex:[self.viewControllers indexOfObject:self.visibleViewController]-1] view];
        
        
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setDuration:kNavigationPopAnimationDuration];
        Animation.delegate = self;
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        [_animationLayer addAnimation:Animation forKey:@"scale"];
        
        
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation1 setDuration:kNavigationPopAnimationDuration];
        Animation1.delegate = self;
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [toView.layer addAnimation:Animation1 forKey:@"scale"];
        
    }
    return [super popToRootViewControllerAnimated:NO];
    
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    
    [_animationLayer setContents:nil];
    [_animationLayer removeAllAnimations];
    [self.visibleViewController.view.layer removeAllAnimations];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

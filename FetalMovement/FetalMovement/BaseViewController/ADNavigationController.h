//
//  ADNavigationController.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADNavigationController : UINavigationController
/**
 *  invoke when back to top viewController
 *
 *  @param topViewController is pop to top viewController
 */
- (void)popToViewControllerIsTopViewController:(BOOL)topViewController;
@end

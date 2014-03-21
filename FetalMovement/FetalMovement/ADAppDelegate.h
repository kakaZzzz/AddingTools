//
//  ADAppDelegate.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-1.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTabBarViewController.h"
@interface ADAppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

<<<<<<< HEAD
=======
<<<<<<< HEAD
@property (strong, nonatomic)ADTabBarViewController *tabBarController;
//登录页面
//@property (strong, nonatomic) ADLoginFirstVC *loginFirstVC;
//@property (strong, nonatomic) ADNavigationController *loginFirstNav;
=======
@property (strong, nonatomic) NSString *wbtoken;
>>>>>>> FETCH_HEAD
>>>>>>> FETCH_HEAD
@property (assign, nonatomic) ADACCOUNT_TYPE urlType;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

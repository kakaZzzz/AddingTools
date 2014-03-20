//
//  ADAppDelegate.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-1.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADAppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSString *wbtoken;
@property (assign, nonatomic) ADACCOUNT_TYPE urlType;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

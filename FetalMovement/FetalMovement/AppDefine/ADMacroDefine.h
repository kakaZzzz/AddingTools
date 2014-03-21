//
//  ADMacroDefine.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADMacroDefine : NSObject
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES:NO)

#define RETINA_INCH4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)  //获取屏幕 宽度
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height) //获取屏幕 高度

#define navItem_height (44)
#define statusBar_height (20)
#define tabbar_height   (49)


#define MAIN_WINDOW  [[[UIApplication sharedApplication] windows] objectAtIndex:0]//获得主窗口
@end

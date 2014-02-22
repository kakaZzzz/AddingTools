//
//  ADPreviewView.h
//  OpenCVTestWangPeng
//
//  Created by wangpeng on 14-2-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADContours;
@interface ADPreviewView : UIView
@property(nonatomic,strong)NSMutableArray *modelArray;
- (void)display;
@end

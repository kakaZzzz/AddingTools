//
//  ADTabbarView.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABBARITEM_OFFSET 0.0f

//ADTabBarViewDelegate
@protocol ADTabBarViewDelegate <NSObject>
@optional
-(void)selectedButtonWithIndex:(NSInteger)index;
@end

@interface ADTabBarView : UIView

@property (nonatomic, weak) id<ADTabBarViewDelegate> delegate;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *normalItemImages;
@property (nonatomic, strong) NSArray *normalItemBackgroundImages;
@property (nonatomic, strong) NSArray *highlightItemImages;
@property (nonatomic, strong) NSArray *highlightItemBackgroundImages;
@property (nonatomic, assign, setter = setSelectedIndex:) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL isRecording;
@end

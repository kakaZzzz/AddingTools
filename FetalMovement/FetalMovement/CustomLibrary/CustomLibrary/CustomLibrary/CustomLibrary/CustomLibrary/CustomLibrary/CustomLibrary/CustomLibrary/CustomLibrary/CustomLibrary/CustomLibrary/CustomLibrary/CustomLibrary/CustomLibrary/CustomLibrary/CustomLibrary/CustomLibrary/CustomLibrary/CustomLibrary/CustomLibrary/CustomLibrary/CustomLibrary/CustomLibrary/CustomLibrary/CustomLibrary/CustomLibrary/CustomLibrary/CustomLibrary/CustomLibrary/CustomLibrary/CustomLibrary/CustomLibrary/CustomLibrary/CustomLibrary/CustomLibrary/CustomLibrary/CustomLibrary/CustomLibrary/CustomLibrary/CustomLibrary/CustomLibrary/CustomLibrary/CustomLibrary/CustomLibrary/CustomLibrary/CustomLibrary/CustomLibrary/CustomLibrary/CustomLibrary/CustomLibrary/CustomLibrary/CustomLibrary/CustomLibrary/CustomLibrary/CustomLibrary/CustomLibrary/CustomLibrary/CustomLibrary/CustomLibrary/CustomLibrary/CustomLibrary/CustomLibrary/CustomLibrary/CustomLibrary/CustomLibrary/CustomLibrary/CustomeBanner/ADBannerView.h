//
//  ADBannerVIew.h
//  BannerTest
//
//  Created by wangpeng on 14-3-14.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADBannerView;
@protocol ADBannerDelegate <NSObject>

- (void)tapImageFrame:(ADBannerView *)imageFrame didSelectItem:(int)item;

@end


@interface ADBannerView : UIView
<UIScrollViewDelegate,
UIGestureRecognizerDelegate>

@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (strong, nonatomic)UITextField *text;

@property (weak, nonatomic)id<ADBannerDelegate> delegate;
//自定义初始化方法
- (id)initWithFrame:(CGRect)frame delegate:(id<ADBannerDelegate>)delegate focusImageItems:(NSArray *)items;
@end

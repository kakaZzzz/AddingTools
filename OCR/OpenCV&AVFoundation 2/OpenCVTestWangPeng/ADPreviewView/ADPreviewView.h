//
//  ADPreviewView.h
//  OpenCVTestWangPeng
//
//  Created by wangpeng on 14-2-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADContours;

@protocol ADPreviewViewDelegate <NSObject>
@optional
- (void) previewView:(UIView *)preview focusAtPoint:(CGPoint)point;
- (void) previewView:(UIView *)preview exposeAtPoint:(CGPoint)point;

- (void) previewView:(UIView *)preview showGridView:(BOOL)show;
@end

@interface ADPreviewView : UIView
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic, assign)BOOL isRightStatus;
@property (nonatomic, weak) id <ADPreviewViewDelegate> delegate;
@property (nonatomic, strong) CALayer *focusBox, *exposeBox;


- (void) drawFocusBoxAtPointOfInterest:(CGPoint)point andRemove:(BOOL)remove;
@end

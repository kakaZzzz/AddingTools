//
//  BTSheetPickerview.h
//  TestDatePicker
//
//  Created by wangpeng on 13-12-25.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADAppDelegate.h"
#define kModalViewAnimationDuration 0.25f
typedef enum BTActionSheetPickerStyle
{
    BTActionSheetPickerStyleTextPicker = 0,//自定义
    BTActionSheetPickerStyleDateAndTimePicker,//系统datePicker
    BTActionSheetPickerStyleDatePicker
}BTActionSheetPickerStyle;

@class BTSheetPickerview;
@protocol BTSheetPickerviewDelegate <NSObject>

//如果使用系统的datePicker，则用此代理方法回调
- (void)actionSheetPickerView:(BTSheetPickerview *)pickerView didSelectDate:(NSDate*)date;

@optional
//如果使用自己填写内容的pickerview，则使用此代理方法
- (void)actionSheetPickerView:(BTSheetPickerview *)pickerView didSelectTitles:(NSArray*)titles;
- (void)actionSheetPickerView:(BTSheetPickerview *)pickerView didScrollDate:(NSDate*)date;
@end

@interface BTSheetPickerview : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
//枚举值 以后可以灵活变动
@property(nonatomic, assign) BTActionSheetPickerStyle actionSheetPickerStyle;
//将要显示在该视图上
@property (nonatomic, weak) UIView *referView;
//取消 确定按钮
@property (nonatomic, strong) UIButton *enterButton;
//选择器上的标签
@property (nonatomic, strong) NSString *title;
//选择器上的标签
@property (nonatomic, strong) UILabel *titleLabel;
//是否正在显示
@property (nonatomic,assign) BOOL isShow;

//代理
@property(nonatomic,assign) id<BTSheetPickerviewDelegate> delegate; // weak reference
//日期选择器
@property (nonatomic, strong)UIDatePicker *datePicker;//日期选择器

@property(nonatomic,strong)UIView *coverView;//遮挡层
//当不是日期选择器 自己定义的pickerView
@property (nonatomic, strong)UIPickerView *pickerView;
@property(nonatomic, strong) NSArray *titlesForComponenets;
@property(nonatomic, strong) NSArray *widthsForComponents;

//初始化
- (id)initWithPikerType:(BTActionSheetPickerStyle)actionStyle referView:(UIView *)referView delegate:(id)delegate;
//初始化
- (id)initWithPikerType:(BTActionSheetPickerStyle)actionStyle referView:(UIView *)referView delegate:(id)delegate title:(NSString *)title;
//显示
- (void)show;
//移除 隐藏
- (void)hide;

@end

//
//  ADTabbarView.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADTabbarView.h"
#import "ADStartRecordView.h"
#import "ADFetalMovementManager.h"
#import "NSDate+DateHelper.h"
#define kTabbarWidth 240/2
#define kButtonWidth 161/2

@interface ADTabBarView()
@property (nonatomic,strong) NSMutableArray * buttonItems;

- (void)endRecord:(NSNotification *)notification;
@end
@implementation ADTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.buttonItems = [[NSMutableArray alloc] initWithCapacity:5];
        
        //NotificationCenter
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRecord:) name:EndRecordFetalMovementNotification object:nil];
        
    }
    return self;
}

- (void)layoutSubviews
{
    NSInteger maxCount = MAX( MAX(_normalItemImages.count, _normalItemBackgroundImages.count),
                             MAX(_highlightItemImages.count, _highlightItemBackgroundImages.count));
    CGRect tabBarFrame = self.frame;
    //    CGFloat buttonWidth = (tabBarFrame.size.width - (maxCount+1)*TABBARITEM_OFFSET) / maxCount;
    
    for(int index = 0 ; index< maxCount; index++)
    {
        //        CGFloat buttonX = TABBARITEM_OFFSET + (buttonWidth + TABBARITEM_OFFSET) * index;
        //        CGRect butttonFrame = CGRectMake(buttonX, TABBARITEM_OFFSET, buttonWidth,tabBarFrame.size.height- TABBARITEM_OFFSET);
        CGRect butttonFrame;
        switch (index) {
            case 0:
                butttonFrame = CGRectMake(0, TABBARITEM_OFFSET, kTabbarWidth,tabBarFrame.size.height- TABBARITEM_OFFSET);
                break;
            case 1:
                butttonFrame = CGRectMake(kTabbarWidth + TABBARITEM_OFFSET, TABBARITEM_OFFSET, kButtonWidth,tabBarFrame.size.height- TABBARITEM_OFFSET);
                break;
            case 2:
                butttonFrame = CGRectMake(kTabbarWidth + kButtonWidth + TABBARITEM_OFFSET * 2, TABBARITEM_OFFSET, kTabbarWidth,tabBarFrame.size.height- TABBARITEM_OFFSET);
                break;
            default:
                break;
        }
        
        //UIButton * button = [[UIButton alloc] initWithFrame:frame];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = butttonFrame;
        
        //Setting Background image
        UIImage * normalBackgroundImage = [_normalItemBackgroundImages objectAtIndex:0];
        [button setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
        UIImage * highlightBackgroundImage = [_highlightItemBackgroundImages objectAtIndex:0];
        [button setBackgroundImage:highlightBackgroundImage forState:UIControlStateSelected];
        
        //Setting Selected image and Highlight image
        UIImage * normalImage = nil;
        UIImage * highlightImage = nil;
        if(_normalItemImages.count > index)
        {
            normalImage = [_normalItemImages objectAtIndex:index];
        }
        else
        {
            normalImage = [_normalItemImages objectAtIndex:0];
        }
        
        if(_highlightItemImages.count > index)
        {
            highlightImage = [_highlightItemImages objectAtIndex:index];
        }
        else
        {
            highlightImage = [_highlightItemImages objectAtIndex:0];
        }
        
        UIImageView *btnImgView = [[UIImageView alloc] initWithImage:normalImage highlightedImage:highlightImage];
        btnImgView.frame = CGRectMake(0, 0, butttonFrame.size.width, butttonFrame.size.height);
        [button addSubview:btnImgView];
        
        if (index == 1) {
            
            btnImgView.userInteractionEnabled = YES;//阻挡button的响应，然后在imageview上添加手势
            
            //TAP
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordFetalMovementWithTap:)];
            [btnImgView addGestureRecognizer:tap];
            
            //longPress
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordFetalMovementWithLongPress:)];
            //            longPress.numberOfTouchesRequired = 1;
            longPress.minimumPressDuration = 1.0;
            // [tap requireGestureRecognizerToFail:longPress];
            [btnImgView addGestureRecognizer:longPress];
            
            
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake((butttonFrame.size.width - 50)/2, (butttonFrame.size.height - 50)/2, 50, 50)];
            countLabel.backgroundColor = [UIColor clearColor];
            countLabel.textColor = [UIColor whiteColor];
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.text = [NSString stringWithFormat:@"%d次",1];
            countLabel.font = [UIFont systemFontOfSize:40/2];
            countLabel.hidden = YES;
            [btnImgView addSubview:countLabel];
        }
        
        //Other
        button.tag = index;
        [button addTarget:self action:@selector(clickTabbarButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonItems addObject:button];
    }
    
    [self setSelectedIndex:0];
}

-(void)setSelectedIndex:(NSInteger)index
{
    
    
    _selectedIndex = index;
    UIButton *button = [self.buttonItems objectAtIndex:index];
    [self clickTabbarButton:button];
}

- (void)clickTabbarButton:(UIButton*)button
{
    
    if (button.tag == 1) {
        
        [self recordFetalMovementWithButton:button];
    }
    
    
    else{
        //clear all highlight and select status
        for (UIButton * tabButton in self.subviews)
        {
            if (tabButton.tag == 1) {
                continue;
            }
            for (UIView *subView in [tabButton subviews])
            {
                if ([subView isKindOfClass:[UIImageView class]])
                {
                    UIImageView * imgView = (UIImageView *)subView;
                    imgView.highlighted = NO;
                }
            }
            
            tabButton.selected = NO;
        }
        
        //settinghighlight and select status
        for (UIView *subView in [button subviews])
        {
            if ([subView isKindOfClass:[UIImageView class]])
            {
                UIImageView * imgView = (UIImageView *)subView;
                imgView.highlighted = YES;
            }
        }
        button.selected = YES;
        
        //Send deleget msg
        if([self.delegate respondsToSelector:@selector(selectedButtonWithIndex:)])
        {
            if (button.tag == 2) {
                [self.delegate selectedButtonWithIndex:button.tag-1];
            }
            else{
                [self.delegate selectedButtonWithIndex:button.tag];
                
            }
        }
        
    }
    
}

/**
 *  record the fetalMovement event
 *
 *  @param button click button
 */

//单击记录胎动
- (void)recordFetalMovementWithTap:(UITapGestureRecognizer *)tap
{
    
    
    UIImageView *aImageView = (UIImageView *)tap.view;
    static int count = 1;
    
    if (!_isRecording) {//第一次点击
        //开始记录胎动的代码
        
        ADStartRecordView *startRecord = [[ADStartRecordView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 -100/2 + 100, SCREEN_WIDTH, 100/2)];
        UIWindow *appWindow =  MAIN_WINDOW;
        
        [appWindow addSubview:startRecord];
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            startRecord.frame = CGRectMake(0, SCREEN_HEIGHT - 50 -100/2,SCREEN_WIDTH, 100/2);
        } completion:^(BOOL finished){
            
        }];
        
        
        aImageView.highlighted = YES;
        
        //        for (UIView *subView in [button subviews])
        //        {
        //            if ([subView isKindOfClass:[UIImageView class]])
        //            {
        //                UIImageView * imgView = (UIImageView *)subView;
        //                imgView.highlighted = YES;
        //            }
        //        }
        
        //
        for (UIView *label in [aImageView subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                label.hidden = NO;
            }
        }
        
        //write data to coredata
        NSDate *date = [NSDate localdate];
        double seconds = [date timeIntervalSince1970];
        //将第一次记录胎动时间存起来
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kFirstRecordFetal]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:seconds] forKey:kFirstRecordFetal];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        [[ADFetalMovementManager sharedADFetalMovementManager] appendData:@[date]];
        
        count = 1;
        self.isRecording = YES;
    }else{
        NSLog(@"正在记录胎动....");
        //在此做记录胎动的事情
        
        
        for (UIView *label in [aImageView subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                UILabel *resultLabel = (UILabel *)label;
                resultLabel.text = [NSString stringWithFormat:@"%d次",++count];
            }
        }
        //write data to coredata
        NSDate *date = [NSDate localdate];
       [[ADFetalMovementManager sharedADFetalMovementManager] appendData:@[date]];
    }
    
}

//长按记录胎动
- (void)recordFetalMovementWithLongPress:(UILongPressGestureRecognizer *)longPress
{
    NSLog(@"长按了乐乐乐乐乐乐乐乐了");
}
- (void)recordFetalMovementWithButton:(UIButton *)button
{
    if (!_isRecording) {//第一次点击
        //开始记录胎动的代码
        NSLog(@"点击button按钮");
        ADStartRecordView *startRecord = [[ADStartRecordView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 -100/2 + 100, SCREEN_WIDTH, 100/2)];
        UIWindow *appWindow =  MAIN_WINDOW;
        
        [appWindow addSubview:startRecord];
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            startRecord.frame = CGRectMake(0, SCREEN_HEIGHT - 50 -100/2,SCREEN_WIDTH, 100/2);
        } completion:^(BOOL finished){
            
        }];
        
        
        
        for (UIView *subView in [button subviews])
        {
            if ([subView isKindOfClass:[UIImageView class]])
            {
                UIImageView * imgView = (UIImageView *)subView;
                imgView.highlighted = YES;
            }
        }
        
        //
        for (UIView *label in [button subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                label.hidden = NO;
            }
        }
        
        //write data to coredata
        NSDate *date = [NSDate localdate];
        [[ADFetalMovementManager sharedADFetalMovementManager] appendData:@[date]];
        
        self.isRecording = YES;
    }else{
        NSLog(@"正在记录胎动....");
        //在此做记录胎动的事情
        
        static int count = 1;
        for (UIView *label in [button subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                UILabel *resultLabel = (UILabel *)label;
                resultLabel.text = [NSString stringWithFormat:@"%d次",++count];
            }
        }
        //write data to coredata
        NSDate *date = [NSDate localdate];
        [[ADFetalMovementManager sharedADFetalMovementManager] appendData:@[date]];
    }
    
}

- (void)endRecord:(NSNotification *)notification
{
    
    
    UIButton *button;
    UIImageView *aImageView;
    for (UIButton * tabButton in self.subviews)
    {
        if (tabButton.tag == 1) {
            button = tabButton;
            break;
        }
        tabButton.selected = NO;
    }
    
    //
    for (UIView *subView in [button subviews])
    {
        if ([subView isKindOfClass:[UIImageView class]])
        {
            aImageView = (UIImageView *)subView;
            aImageView.highlighted = NO;
        }
    }
    
    //
    for (UIView *label in [aImageView subviews])
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            UILabel *aLabel = (UILabel *)label;
            aLabel.hidden = YES;
            aLabel.text = [NSString stringWithFormat:@"%d次",1];
            
        }
    }
    
    
    self.isRecording = NO;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

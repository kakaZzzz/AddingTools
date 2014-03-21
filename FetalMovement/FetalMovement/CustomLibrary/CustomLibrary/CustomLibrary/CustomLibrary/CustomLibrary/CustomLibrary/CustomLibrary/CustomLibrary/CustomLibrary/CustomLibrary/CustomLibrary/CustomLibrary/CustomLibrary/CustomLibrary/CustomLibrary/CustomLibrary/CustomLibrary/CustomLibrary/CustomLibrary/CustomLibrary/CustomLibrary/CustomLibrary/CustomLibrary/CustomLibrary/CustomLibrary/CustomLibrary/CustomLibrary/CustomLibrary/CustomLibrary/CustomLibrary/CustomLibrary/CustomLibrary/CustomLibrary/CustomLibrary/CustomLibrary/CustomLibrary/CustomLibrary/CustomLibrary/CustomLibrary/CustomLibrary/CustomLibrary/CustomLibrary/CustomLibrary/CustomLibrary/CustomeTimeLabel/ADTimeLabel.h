//
//  ADTimeLabel.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-5.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADTimeLabel : UILabel
/*Time format wish to display in label*/
@property (nonatomic,copy) NSString *timeFormat;

/*Target label obejct, default self if you do not initWithLabel nor set*/
@property (nonatomic,strong) UILabel *timeLabel;


/*is The Timer Running?*/
@property (assign,readonly) BOOL counting;

/*do you reset the Timer after countdown?*/
@property (assign) BOOL resetTimerAfterFinish;


/*--------Timer control methods to use*/
-(void)start;
-(void)pause;
-(void)reset;


-(void)setStopWatchTime:(NSTimeInterval)time;

@end

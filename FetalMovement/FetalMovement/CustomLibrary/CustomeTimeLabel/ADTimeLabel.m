//
//  ADTimeLabel.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-5.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADTimeLabel.h"
#define kDefaultTimeFormat  @"HH:mm:ss"
#define kDefaultFireIntervalNormal  0.1
#define kDefaultFireIntervalHighUse  0.02
#define kDefaultTimerType ADTimerLabelTypeStopWatch

@interface ADTimeLabel(){
    
    NSTimeInterval timeUserValue;
    NSDate *startCountDate;
    NSDate *pausedTime;
    NSDate *date1970;
    NSDate *timeToCountOff;
}
@property (strong) NSTimer *timer;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

- (void)setup;
- (void)updateLabel;

@end
@implementation ADTimeLabel
@synthesize timeFormat = _timeFormat;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
        [self setup];
	}
	return self;
}

#pragma mark - Getter and Setter Method

- (void)setStopWatchTime:(NSTimeInterval)time{
    
    timeUserValue = (time < 0) ? 0 : time;
    if(timeUserValue > 0){
        startCountDate = [[NSDate date] dateByAddingTimeInterval:-timeUserValue];
        [self updateLabel];
    }
}


- (void)setTimeFormat:(NSString *)timeFormat{
    
    if ([timeFormat length] != 0) {
        _timeFormat = timeFormat;
        self.dateFormatter.dateFormat = timeFormat;
    }
    [self updateLabel];
}



- (NSString*)timeFormat
{
    if ([_timeFormat length] == 0 || _timeFormat == nil) {
        _timeFormat = kDefaultTimeFormat;
    }
    
    return _timeFormat;
}

- (NSDateFormatter*)dateFormatter{
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        _dateFormatter.dateFormat = self.timeFormat;
    }
    return _dateFormatter;
}

- (UILabel*)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = self;
    }
    return _timeLabel;
}

#pragma mark - Timer Control Method


-(void)start{
    
    if ([self.timeFormat rangeOfString:@"SS"].location != NSNotFound) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kDefaultFireIntervalHighUse target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    }else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:kDefaultFireIntervalNormal target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    if(startCountDate == nil){
        startCountDate = [NSDate date];
        
        if (timeUserValue > 0) {
            startCountDate = [startCountDate dateByAddingTimeInterval:(timeUserValue<0)?0:-timeUserValue];
        }
    }
    if(pausedTime != nil){
        NSTimeInterval countedTime = [pausedTime timeIntervalSinceDate:startCountDate];
        startCountDate = [[NSDate date] dateByAddingTimeInterval:-countedTime];
        pausedTime = nil;
    }
    
    _counting = YES;
    [_timer fire];
}


-(void)pause{
    [_timer invalidate];
    _timer = nil;
    _counting = NO;
    pausedTime = [NSDate date];
}

-(void)reset{
    pausedTime = nil;
    timeUserValue =  0;
    startCountDate = (self.counting)? [NSDate date] : nil;
    [self updateLabel];
}


#pragma mark - Private method

-(void)setup{
    date1970 = [NSDate dateWithTimeIntervalSince1970:0];
    [self updateLabel];
}


-(void)updateLabel{
    
    NSTimeInterval timeDiff = [[[NSDate alloc] init] timeIntervalSinceDate:startCountDate];
    NSDate *timeToShow = [NSDate date];
    
    
    if (_counting) {
        timeToShow = [date1970 dateByAddingTimeInterval:timeDiff];
    }else{
        timeToShow = [date1970 dateByAddingTimeInterval:(!startCountDate)?0:timeDiff];
    }
    
    
    NSString *strDate = [self.dateFormatter stringFromDate:timeToShow];
    self.timeLabel.text = strDate;
    
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

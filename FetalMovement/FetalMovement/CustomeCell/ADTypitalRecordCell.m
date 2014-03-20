//
//  ADTypitalRecordCell.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-4.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADTypitalRecordCell.h"
#import "ADTypicalRecordModel.h"
@implementation ADTypitalRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCustomCell];
    }
    return self;
}
//配置cell内容
- (void)createCustomCell
{
    
    self.contentView.backgroundColor = [UIColor colorWithRed:251/255.0 green:247/255.0 blue:241/255.0 alpha:1.0];
    //序列号
    self.orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(28/2,(self.frame.size.height - 20)/2, 20, 20)];
    _orderLabel.textColor = kOrangeFontColor;
    _orderLabel.font = [UIFont systemFontOfSize:28/2];
    _orderLabel.backgroundColor = [UIColor clearColor];
    _orderLabel.opaque = NO;
    [self.contentView addSubview:_orderLabel];
    
    //起始时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,(self.frame.size.height - 40)/2, 150, 40)];
    _timeLabel.textColor = kOrangeFontColor;
    _timeLabel.font = [UIFont systemFontOfSize:28/2];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.opaque = NO;
    [self.contentView addSubview:_timeLabel];
    
    //胎动次数
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 100 - 28/2),(self.frame.size.height - 40)/2, 100, 40)];
    _countLabel.textAlignment = NSTextAlignmentRight;
     _countLabel.textColor = kOrangeFontColor;
    _countLabel.font = [UIFont systemFontOfSize:28/2];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.opaque = NO;
    [self.contentView addSubview:_countLabel];
    
    
    
}
- (void)setRecordModel:(ADTypicalRecordModel *)model
{
    
    _recordModel = model;
    self.orderLabel.text = [NSString stringWithFormat:@"%d",_recordModel.order];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",_recordModel.startTime,_recordModel.endTime];
    self.countLabel.text = [NSString stringWithFormat:@"%d 次",_recordModel.fetalcount];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

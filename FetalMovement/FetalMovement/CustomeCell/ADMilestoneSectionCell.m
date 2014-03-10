//
//  ADMilestoneSectionCell.m
//  Milestone
//
//  Created by wangpeng on 14-3-7.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADMilestoneSectionCell.h"
#import "ADMilestoneModel.h"
#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT self.frame.size.height

@implementation ADMilestoneSectionCell

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
    
      // self.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:133/255.0 alpha:1.0];
//    UIView *backcolorView =[[UIView alloc] init];
//    backcolorView.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:133/255.0 alpha:1.0];
//    cellSection.backgroundView = backcolorView;
    self.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:133/255.0 alpha:1.0];

    //刻度
    self.scaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milestone_scal@2x"]];
    _scaleImageView.frame = CGRectMake(60/2 - 5.5, 0, 5.5, CELL_HEIGHT);
    [self.contentView addSubview:_scaleImageView];

    //日期
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((CELL_WIDTH - 80)/2 ,(CELL_HEIGHT - 20)/2, 80, 20)];
    //  _dateLabel.textColor = kOrangeFontColor;//
    _dateLabel.textColor = [UIColor whiteColor];//
    _dateLabel.font = [UIFont systemFontOfSize:28/2];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.text = @"1";
    [self addSubview:_dateLabel];


}
- (void)layoutSubviews
{
    NSLog(@"重新调整高度");
    NSLog(@"行高是%f",CELL_HEIGHT);
    self.contentView.frame = self.bounds;//iOS6上要加这句话，你妹啊
    
    //重新调整尺寸
    self.dateLabel.frame = CGRectMake((CELL_WIDTH - 80)/2,(CELL_HEIGHT - 20)/2, 80, 20);
    _scaleImageView.frame = CGRectMake(60/2 - 5.5, 0, 5.5, CELL_HEIGHT);

    
    
    double seconds = [self.model.date doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSNumber *year = [NSDate getYear:date];
    NSNumber *month = [NSDate getMonth:date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

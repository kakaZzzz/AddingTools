//
//  ADMilestoneContentCell.m
//  Milestone
//
//  Created by wangpeng on 14-3-7.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADMilestoneContentCell.h"
#import "ADMilestoneModel.h"
#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT self.frame.size.height
#define HALF_CELL_WIDTH 160
@implementation ADMilestoneContentCell

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

    
    //self.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:118/255.0 blue:133/255.0 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    //日期
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,(CELL_HEIGHT - 20)/2, 60/2, 20)];
    _dateLabel.textColor = [UIColor colorWithRed:255/255.0 green:176/255.0 blue:170/255.0 alpha:1.0];//
    _dateLabel.font = [UIFont systemFontOfSize:28/2];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.text = @"1";
    [self.contentView addSubview:_dateLabel];
    
    //刻度
    self.scaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milestone_scal@2x"]];
    _scaleImageView.frame = CGRectMake(60/2 - 5.5, 0, 5.5, CELL_HEIGHT);
    [self.contentView addSubview:_scaleImageView];
    
    //胎动次数背景
    self.countImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"milestone_content_bg@2x"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 10, 20)]];
    _countImageView.frame = CGRectMake(60/2 ,(CELL_HEIGHT - 30)/2, 100, 30);
    [self.contentView addSubview:_countImageView];

    //胎动次数
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_countImageView.frame.size.width - 50 -10,(_countImageView.frame.size.height - 20)/2, 50, 20)];
    //  _dateLabel.textColor = kOrangeFontColor;//
    _countLabel.textColor = [UIColor whiteColor];//
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.font = [UIFont systemFontOfSize:24/2];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.text = @"61次";
    [_countImageView addSubview:_countLabel];
    
    //黄线
    self.yellowLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milestone_yellow_line@2x"]];
    _yellowLineImageView.frame = CGRectMake(_countImageView.frame.origin.x + _countImageView.frame.size.width,(CELL_HEIGHT - 1)/2, HALF_CELL_WIDTH - (_countImageView.frame.origin.x + _countImageView.frame.size.width) + 1, 1);
    _yellowLineImageView.hidden = YES;
    [self.contentView addSubview:_yellowLineImageView];

    //mark 背景
    self.markImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milestone_mark_bg@2x"]];
    _markImageView.frame = CGRectMake(HALF_CELL_WIDTH,(CELL_HEIGHT - 25)/2, 176/2, 25);
    _markImageView.hidden = YES;
    [self.contentView addSubview:_markImageView];
    
    //mark 内容Label
    self.markLabel = [[UILabel alloc] initWithFrame:_markImageView.bounds];
    _markLabel.textColor = [UIColor whiteColor];//
    _markLabel.textAlignment = NSTextAlignmentCenter;
    _markLabel.font = [UIFont systemFontOfSize:28/2];
    _markLabel.backgroundColor = [UIColor clearColor];
     _markLabel.text = @"最活跃宝宝";
    [_markImageView addSubview:_markLabel];


    //奖牌
    self.medalImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milestone_medal_image3@2x"]];
    _medalImageView.frame = CGRectMake(60/2 - 73/2/2, 0, 73/2, CELL_HEIGHT);
    _medalImageView.hidden = YES;
    [self.contentView addSubview:_medalImageView];

    
    
    
}
//- (void)setModel:(ADMilestoneModel *)model
//{
//    
//    NSLog(@"行高是%f",CELL_HEIGHT);
//    
//    _model = model;
//    //    @property(nonatomic,strong)NSString *date;
//    //    @property(nonatomic,strong)NSString *tag;
//    //    @property(nonatomic,assign)int gestationalWeeks;
//    //    @property(nonatomic,assign)int medal;
//    //    @property(nonatomic,assign)int fetalcount;
//    //    @property(nonatomic,assign)BOOL isSection ;
//    
//    //调整内容
//    double dateSeconds = [self.model.date doubleValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateSeconds];
//    NSNumber *day = [NSDate getDay:date];
//    self.dateLabel.text = [NSString stringWithFormat:@"%@",day];
//    
//    //黄色mark
//    if (self.model.tag) {
//        _yellowLineImageView.hidden = NO;
//        _markImageView.hidden = NO;
//        _markLabel.text = self.model.tag;
//    }else{
//        _yellowLineImageView.hidden = YES;
//        _markImageView.hidden = YES;
//        
//    }
//    
//    
//    //次数
//    int count = self.model.fetalcount;
//    if (count == 0) {
//        _countImageView.frame = CGRectMake(60/2 ,(CELL_HEIGHT - 30)/2, 0, 30);
//        self.countLabel.text = @"";
//    }else
//    {
//        _countImageView.frame = CGRectMake(60/2 ,(CELL_HEIGHT - 30)/2, 100 * (count/61.0), 30);
//        if (count < 28) {
//            self.countLabel.text = @"";
//        }else{
//            self.countLabel.text = [NSString stringWithFormat:@"%d次",count];
//        }
//    }
//    
//    
//    //重新调整尺寸
//    self.dateLabel.frame = CGRectMake(0,(CELL_HEIGHT - 20)/2, 60/2, 20);
//    _scaleImageView.frame = CGRectMake(60/2 -5.5, 0, 5.5, CELL_HEIGHT);
//    //_countImageView.frame = CGRectMake(60/2 ,(CELL_HEIGHT - 30)/2, 100, 30);
//    _yellowLineImageView.frame = CGRectMake(_countImageView.frame.origin.x + _countImageView.frame.size.width,(CELL_HEIGHT - 1)/2, HALF_CELL_WIDTH - (_countImageView.frame.origin.x + _countImageView.frame.size.width) + 1, 1);
//    _markImageView.frame = CGRectMake(HALF_CELL_WIDTH,(CELL_HEIGHT - 25)/2, 176/2, 25);
//    
//}
- (void)layoutSubviews
{
   
    NSLog(@"行高是%f",CELL_HEIGHT);
   
//    @property(nonatomic,strong)NSString *date;
//    @property(nonatomic,strong)NSString *tag;
//    @property(nonatomic,assign)int gestationalWeeks;
//    @property(nonatomic,assign)int medal;
//    @property(nonatomic,assign)int fetalcount;
//    @property(nonatomic,assign)BOOL isSection ;

     //调整内容
    double dateSeconds = [self.model.date doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateSeconds];
    NSNumber *day = [NSDate getDay:date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",day];
    
    //黄色mark
    if (self.model.tag) {
        _yellowLineImageView.hidden = NO;
        _markImageView.hidden = NO;
        _markLabel.text = self.model.tag;
    }else{
        _yellowLineImageView.hidden = YES;
        _markImageView.hidden = YES;

    }
    
    
    //次数
    int count = self.model.fetalcount;
    if (count == 0) {
         _countImageView.frame = CGRectMake(60/2 ,(CELL_HEIGHT - 30)/2, 0, 30);
        self.countLabel.text = @"";
    }else
    {
        _countImageView.frame = CGRectMake(60/2 ,(CELL_HEIGHT - 30)/2, 100 * (count/61.0), 30);
        if (count < 28) {
            self.countLabel.text = @"";
        }else{
            self.countLabel.text = [NSString stringWithFormat:@"%d次",count];
        }
    }
    
    //勋章
   if(self.model.medal == 3)
    {
        self.medalImageView.hidden = NO;
        _medalImageView.image = [UIImage imageNamed:@"milestone_medal_image3@2x"];
    }else if (self.model.medal == 14)
    {
        self.medalImageView.hidden = NO;
        _medalImageView.image = [UIImage imageNamed:@"milestone_medal_image14@2x"];

    }else{
        self.medalImageView.hidden = YES;
    }
    //重新调整尺寸
    self.dateLabel.frame = CGRectMake(0,(CELL_HEIGHT - 20)/2, 60/2, 20);
    _scaleImageView.frame = CGRectMake(60/2 -5.5, 0, 5.5, CELL_HEIGHT);
    //_countImageView.frame = CGRectMake(60/2 ,(CELL_HEIGHT - 30)/2, 100, 30);
    _countLabel.frame =CGRectMake(_countImageView.frame.size.width - 50 -10,(_countImageView.frame.size.height - 20)/2, 50, 20);
    _yellowLineImageView.frame = CGRectMake(_countImageView.frame.origin.x + _countImageView.frame.size.width,(CELL_HEIGHT - 1)/2, HALF_CELL_WIDTH - (_countImageView.frame.origin.x + _countImageView.frame.size.width) + 1, 1);
    _markImageView.frame = CGRectMake(HALF_CELL_WIDTH,(CELL_HEIGHT - 25)/2, 176/2, 25);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

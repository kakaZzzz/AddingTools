//
//  ADSettingCell.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-14.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADSettingCell.h"

#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT self.frame.size.height

#define kMargin 36/2
@implementation ADSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCustomCell];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

//配置cell内容
- (void)createCustomCell
{
    // self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingcell_bg.png"]];
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, (CELL_HEIGHT - 50/2)/2, 50/2, 50/2)];
    _iconImage.image = [UIImage imageNamed:@"indicate.png"];
    [self.contentView addSubview:_iconImage];
    
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,(CELL_HEIGHT - 40)/2, 100, 50/2)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kTitleFontColor;
    _titleLabel.font = kTitleFont;
    [self.contentView addSubview:_titleLabel];
    
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((CELL_WIDTH - 100 - kMargin - 12),(CELL_HEIGHT - 40)/2, 100, 50/2)];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = kContentFontColor;
    _contentLabel.font = kContentFont;
    [self.contentView addSubview:_contentLabel];
    
    
    self.indicateImage = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_WIDTH - 14/2 - kMargin, (CELL_HEIGHT - 30/2)/2, 14/2, 30/2)];
    _indicateImage.image = [UIImage imageNamed:@"setting_indicator"];
    [self.contentView addSubview:_indicateImage];
    
    
    
}
- (void)layoutSubviews
{

    self.contentView.frame = self.bounds;//iOS6上要加这句话，你妹啊
    
    //重新调整尺寸
    CGRect rect;
    rect = _iconImage.frame;
    rect.origin.y = (CELL_HEIGHT - 50/2)/2;
    _iconImage.frame = rect;
    
    rect = _titleLabel.frame;
    rect.origin.y = (CELL_HEIGHT - 50/2)/2;
    self.titleLabel.frame = rect;
    
    rect = _contentLabel.frame;
    rect.origin.y = (CELL_HEIGHT - 50/2)/2;
    self.contentLabel.frame = rect;
    
    rect = _indicateImage.frame;
    rect.origin.y = (CELL_HEIGHT - 30/2)/2;
    self.indicateImage.frame = rect;
    
    //
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

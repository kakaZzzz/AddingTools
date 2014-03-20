//
//  ADSettingSectionCell.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-14.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADSettingSectionCell.h"


#define titleLabelX 24/2
#define titleLabelY 7
#define titleLabelWidth 250
#define titleLabelHeight 30

#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT self.frame.size.height
@implementation ADSettingSectionCell

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
    
    // self.contentView.backgroundColor = [UIColor grayColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,(self.frame.size.height - titleLabelHeight)/2, titleLabelWidth, titleLabelHeight)];
    _titleLabel.font = kContentFont;
    _titleLabel.textColor = kContentFontColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.opaque = NO;
    [self.contentView addSubview:_titleLabel];
    
    
    
    
}
- (void)layoutSubviews
{

    self.contentView.frame = self.bounds;//iOS6上要加这句话，你妹啊
    
    //重新调整尺寸
    self.titleLabel.frame = CGRectMake(24/2,(CELL_HEIGHT - 20)/2, 250, 20);


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

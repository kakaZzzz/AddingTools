//
//  ADAccoundCell.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-15.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADAccoundCell.h"
#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT self.frame.size.height

#define kMargin 36/2
@implementation ADAccoundCell

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
    _titleLabel.font = kTitleFont;
    _titleLabel.textColor = kTitleFontColor;
    _titleLabel.opaque = NO;
    [self.contentView addSubview:_titleLabel];
    
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((CELL_WIDTH - 100 - kMargin - 50),(CELL_HEIGHT - 40)/2, 100, 50/2)];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = kContentFont;
    _contentLabel.textColor = kContentFontColor;

    _contentLabel.opaque = NO;
    [self.contentView addSubview:_contentLabel];
    
    
    self.accoundSwitch = [[ADSwitch alloc] initWithFrame:CGRectMake(CELL_WIDTH - kMargin - 96/2, (55 - 52/2)/2, 96/2, 52/2)];
    [self.accoundSwitch setOnTintColor: [UIColor colorWithRed:255/255.0 green:83/255.0 blue:110/255.0 alpha:1.0]];
    [self.accoundSwitch setContrastColor:[UIColor colorWithRed:241/255.0 green:235/255.0 blue:223/255.0 alpha:1.0]];
    
//    [self.accoundSwitch setOn: YES
//                     animated: YES];
    
    __weak ADAccoundCell *cell = self;
    [self.accoundSwitch setDidChangeHandler:^(BOOL isOn) {
        
        
        NSLog(@"Biggest switch changed to %d", isOn);
        if (isOn) {
            [cell bind];
        }else{
            [cell nonBind];
        }
        
    }];

    [self.contentView addSubview:_accoundSwitch];
    
    
}

- (void)bind
{
     _swichOnBlock(_cellType);
}
- (void)nonBind
{
    _swichOffBlock(_cellType);
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
    

    if (_cellType == CELL_TYPE_UNKNOW) {
        
      NSString *nikeName = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_NICKNAME];
        self.contentLabel.text = nikeName;
        self.contentLabel.frame = CGRectMake((CELL_WIDTH - 100 - kMargin),(CELL_HEIGHT - 50/2)/2, 100, 50/2);
        _accoundSwitch.hidden = YES;
    }
    
    int sinaBind = [[[NSUserDefaults standardUserDefaults] objectForKey:WEIBO_ENABLED_KEY] intValue];
    int qqBind = [[[NSUserDefaults standardUserDefaults] objectForKey:QQ_ENABLED_KEY] intValue];
    int baiduBind = [[[NSUserDefaults standardUserDefaults] objectForKey:BAIDU_ENABLED_KEY] intValue];
    
    //是否绑定状态判断 怎么判断
    if (_cellType == CELL_TYPE_SINA) {
        if (sinaBind == 1) {
            _accoundSwitch.on = YES;
            _iconImage.image = [UIImage imageNamed:@"sina_bind_icon@2x"];
            _contentLabel.text = [NSString stringWithFormat:@"已绑定"];
        }else{
            _accoundSwitch.on = NO;
            _iconImage.image = [UIImage imageNamed:@"sina_nonbind_icon@2x"];
            _contentLabel.text = [NSString stringWithFormat:@"未绑定"];
        }
        
    }
    
    if (_cellType == CELL_TYPE_QQ) {
        if (qqBind == 1) {
            _accoundSwitch.on = YES;
            _iconImage.image = [UIImage imageNamed:@"qq_bind_icon@2x"];
            _contentLabel.text = [NSString stringWithFormat:@"已绑定"];
        }else{
            _accoundSwitch.on = NO;
            _iconImage.image = [UIImage imageNamed:@"qq_nonbind_icon@2x"];
            _contentLabel.text = [NSString stringWithFormat:@"未绑定"];
        }
        
    }

    if (_cellType == CELL_TYPE_BAIDU) {
        if (baiduBind == 1) {
            _accoundSwitch.on = YES;
            _iconImage.image = [UIImage imageNamed:@"baidu_bind_icon@2x"];
            _contentLabel.text = [NSString stringWithFormat:@"已绑定"];
        }else{
            _accoundSwitch.on = NO;
            _iconImage.image = [UIImage imageNamed:@"baidu_nonbind_icon@2x"];
            _contentLabel.text = [NSString stringWithFormat:@"未绑定"];
        }
        
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

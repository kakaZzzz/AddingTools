//
//  ADMarkView.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-4.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADMarkView.h"

@implementation ADMarkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,67/2)];
        //_aImageView.backgroundColor = [UIColor yellowColor];
        _aImageView.image = [UIImage imageNamed:@"mark_bgImage@2x"];
        [self addSubview:_aImageView];
        
        
        self.linkLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 1.5)/2, _aImageView.frame.size.height - 1, 1.5,self.frame.size.height - _aImageView.frame.size.height)];
        _linkLineImageView.backgroundColor = [UIColor clearColor];
       
        _linkLineImageView.image = [UIImage imageNamed:@"mark_link_line"];
        [self addSubview:_linkLineImageView];
        
        self.markLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, self.frame.size.width, 67/2)];
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.numberOfLines = 0;
        _markLabel.font = [UIFont systemFontOfSize:34/2];
        self.markLabel.textAlignment = NSTextAlignmentCenter;
        self.markLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _markLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_markLabel];

    }
    return self;
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

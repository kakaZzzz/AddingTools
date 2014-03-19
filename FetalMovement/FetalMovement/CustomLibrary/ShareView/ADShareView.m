//
//  ADShareView.m
//  ShareTestDemo
//
//  Created by 大头滴血 on 14-3-19.
//  Copyright (c) 2014年 liulei_prerry. All rights reserved.
//

#import "ADShareView.h"
#define coverView_tag (80000)

#define sinaShareButton_tag (10000)
#define weixin_tag (20000)
#define friendCircle_tag (30000)

#define shareTitleLabel_tag (40000)
#define sinaLabel_tag (50000)
#define weixinLabel_tag (60000)
#define friendLabel_tag (70000)

#define common_textCcolor [UIColor colorWithRed:143/255.0f green:132/255.0f blue:123/255.f alpha:1.0]

@interface ADShareView(){
    
}
@property (nonatomic, retain)UIView* superVirw_a;
@end

@implementation ADShareView
@synthesize superVirw_a;

+ (void)createShareView:(UIView *)superView{
    
    UIView *coverView = [[UIView alloc]initWithFrame:superView.frame];
    coverView.tag = coverView_tag;
    [superView addSubview:coverView];
    
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    ADShareView * shareView = [[ADShareView alloc]initWithFrame:CGRectMake(0, superView.frame.size.height, 320, 400)];
    shareView.superVirw_a = superView;
    [shareView showAnimation];
    [coverView addSubview:shareView];
    
    //添加取消手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(tapGesture)];
    [coverView addGestureRecognizer:tapGesture];

}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //title
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.tag = shareTitleLabel_tag;
        titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:118/255.0f blue:133/255.f alpha:1.0];
        titleLabel.text = @"分享到";
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:titleLabel];
        
        //sina
        UIButton * sinaShareButton = [[UIButton alloc]init];
        sinaShareButton.tag = sinaShareButton_tag;
        [sinaShareButton setImage:[UIImage imageNamed:@"AD微博@2x"] forState:UIControlStateNormal];
        [sinaShareButton setImage:[UIImage imageNamed:@"AD微博点击@2x"] forState:UIControlStateHighlighted];
        [sinaShareButton addTarget:self action:@selector(sinaShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sinaShareButton];
        UILabel *sinaLabel = [[UILabel alloc]init];
        sinaLabel.tag = sinaLabel_tag;
        sinaLabel.text = @"新浪微博";
        sinaLabel.textColor = common_textCcolor;
        [self addSubview:sinaLabel];
        
        //weixin
        UIButton * weixinShareButton =  [[UIButton alloc]init];
        weixinShareButton.tag = weixin_tag;
        [weixinShareButton addTarget:self action:@selector(weixinShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [weixinShareButton setImage:[UIImage imageNamed:@"AD微信@2x"] forState:UIControlStateNormal];
        [weixinShareButton setImage:[UIImage imageNamed:@"AD微信点击@2x"] forState:UIControlStateHighlighted];
        [self addSubview:weixinShareButton];
        UILabel *weixinLabel = [[UILabel alloc]init];
        weixinLabel.tag = weixinLabel_tag;
        weixinLabel.text = @"微信好友";
        weixinLabel.textColor = common_textCcolor;
        [self addSubview:weixinLabel];
        
        //Circle of friends
        UIButton * friendCircle = [[UIButton alloc]init];
        friendCircle.tag = friendCircle_tag;
        [friendCircle addTarget:self action:@selector(friendCircleShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [friendCircle setImage:[UIImage imageNamed:@"AD朋友圈@2x"] forState:UIControlStateNormal];
        [friendCircle setImage:[UIImage imageNamed:@"AD朋友圈点击@2x"] forState:UIControlStateHighlighted];
        [self addSubview:friendCircle];
        UILabel *friendLabel = [[UILabel alloc]init];
        friendLabel.tag = friendLabel_tag;
        friendLabel.text = @"朋友圈";
        friendLabel.textColor = common_textCcolor;
        [self addSubview:friendLabel];
    
        [self showAnimation];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    NSInteger tempWidth = 95;
    
    UILabel * titleLabel = (UILabel *)[self viewWithTag:shareTitleLabel_tag];
    titleLabel.frame = CGRectMake(0, 0, 320, 50);
    
    UIButton * sinaShareButton = (UIButton *)[self viewWithTag:sinaShareButton_tag];
    sinaShareButton.frame = CGRectMake(30, 65, 70, 70);
    UILabel * sinaLabel = (UILabel *)[self viewWithTag:sinaLabel_tag];
    sinaLabel.frame = CGRectMake(30, 123, 70, 70);
    
    UIButton *weixinShareButton = (UIButton *)[self viewWithTag:weixin_tag];
    weixinShareButton.frame = CGRectMake(30 + tempWidth, 65, 70, 70);
    UILabel * weixinLabel = (UILabel *)[self viewWithTag:weixinLabel_tag];
    weixinLabel.frame = CGRectMake(30 + tempWidth+3, 123, 70, 70);
    
    UIButton * friendCircle = (UIButton *)[self viewWithTag:friendCircle_tag];
    friendCircle.frame = CGRectMake(30 + 2*tempWidth, 65, 70, 70);
    UILabel * friendLabel = (UILabel *)[self viewWithTag:friendLabel_tag];
    friendLabel.frame = CGRectMake(30 + 2*tempWidth + 10, 123, 70, 70);
    
}

- (void)showAnimation//显示
{
    self.frame = CGRectMake(0, superVirw_a.frame.size.height, 320, 400);
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, superVirw_a.frame.size.height-200, 320, 400);
    }];
}

- (void)removeViewInSuperView//隐藏
{
    CGRect beginrect = self.frame;
    beginrect.origin.y = self.superview.frame.size.height;
    
    UIView *coverView = (UIView *)[self.superview viewWithTag:coverView_tag];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = beginrect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [coverView removeFromSuperview];
    }];

}

#pragma mark - click action

- (void)sinaShareAction:(UIButton *)button{
    NSLog(@"新浪分享");
    [self removeViewInSuperView];
}

- (void)weixinShareAction:(UIButton *)button{
    NSLog(@"微信分享");
    [self removeViewInSuperView];
}
- (void)friendCircleShareAction:(UIButton *)button{
    NSLog(@"朋友圈分享");
    [self removeViewInSuperView];
}

- (void)tapGesture{
    NSLog(@"取消分享");
    [self removeViewInSuperView];
}


@end

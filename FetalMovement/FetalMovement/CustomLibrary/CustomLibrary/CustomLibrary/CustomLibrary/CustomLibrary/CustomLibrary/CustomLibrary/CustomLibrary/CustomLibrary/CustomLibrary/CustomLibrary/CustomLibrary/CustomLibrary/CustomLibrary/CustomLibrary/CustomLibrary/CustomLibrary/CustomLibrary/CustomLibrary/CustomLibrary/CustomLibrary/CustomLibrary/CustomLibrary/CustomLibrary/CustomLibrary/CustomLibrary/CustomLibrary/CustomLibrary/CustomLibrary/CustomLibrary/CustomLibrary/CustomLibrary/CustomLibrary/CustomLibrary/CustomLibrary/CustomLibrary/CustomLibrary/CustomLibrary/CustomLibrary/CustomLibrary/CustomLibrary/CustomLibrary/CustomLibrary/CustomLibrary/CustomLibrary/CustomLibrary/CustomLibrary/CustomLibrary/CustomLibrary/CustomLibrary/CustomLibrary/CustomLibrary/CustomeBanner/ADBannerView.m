//
//  ADBannerVIew.m
//  BannerTest
//
//  Created by wangpeng on 14-3-14.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADBannerView.h"

#define SCROLL_TIME 3

@interface ADBannerView()

@property(nonatomic,strong)NSTimer *timer;

@end
@implementation ADBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark initial method
- (id)initWithFrame:(CGRect)frame delegate:(id<ADBannerDelegate>)delegate focusImageItems:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = delegate;
        self.slideImages = [NSMutableArray arrayWithCapacity:1];
        self.slideImages.array = items;
        [self createSubviews];
    }
    return self;
    
}
- (void)createSubviews
{
    
//    self.backgroundColor = [UIColor redColor];
    if (_timer == nil) {
        self.timer =[NSTimer scheduledTimerWithTimeInterval:SCROLL_TIME target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    }
    
    // 初始化 scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
//    if (IOS7_OR_LATER) {
//        _scrollView.frame = CGRectMake(0, -20, 320, self.frame.size.height);
//    }
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
    [self addSubview:_scrollView];
    
    // pagecontrol
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(120,self.frame.size.height - 18 - 5,100,18)]; // 初始化mypagecontrol
//    [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
//    [_pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    _pageControl.numberOfPages = [self.slideImages count];
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self addSubview:_pageControl];
    // 创建四个图片 imageview
    for (int i = 0;i<[_slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake((320 * i) + 320, 0, 320, self.frame.size.height);
        [_scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    }
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:([_slideImages count]-1)]]];
    imageView.frame = CGRectMake(0, 0, 320, self.frame.size.height); // 添加最后1页在首页 循环
    [_scrollView addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:0]]];
    imageView.frame = CGRectMake((320 * ([_slideImages count] + 1)) , 0, 320, self.frame.size.height); // 添加第1页在最后 循环
    [_scrollView addSubview:imageView];
    
    [_scrollView setContentSize:CGSizeMake(320 * ([_slideImages count] + 2), self.frame.size.height)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,self.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
}

#pragma mark - 
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/([_slideImages count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ ([_slideImages count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(320 * [_slideImages count],0,320,self.frame.size.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([_slideImages count]+1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,self.frame.size.height) animated:NO]; // 最后+1,循环第1页
    }
}
#pragma mark - 
#pragma mark - all Event
// pagecontrol event
- (void)turnPage
{
    int page = _pageControl.currentPage; // 获取当前的page
    [self.scrollView scrollRectToVisible:CGRectMake(320*(page+1),0,320,self.frame.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// timer event
- (void)runTimePage
{
    int page = _pageControl.currentPage; // 获取当前的page
    page++;
    page = page > (_pageControl.numberOfPages - 1) ? 0 : page ;
    _pageControl.currentPage = page;
    [self turnPage];
}
- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/ ([_slideImages count]+2)) / pagewidth) + 1;
    
    if ([self.delegate respondsToSelector:@selector(tapImageFrame:didSelectItem:)]) {
        [self.delegate tapImageFrame:self didSelectItem:page];
    }
    
}
- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
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

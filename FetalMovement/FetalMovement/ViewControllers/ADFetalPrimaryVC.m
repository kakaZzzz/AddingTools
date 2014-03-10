//
//  ADFetalPrimaryVC.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADFetalPrimaryVC.h"
#import "ADSecondVC.h"
#import "NSDate+DateHelper.h"
#import "ADFetalMovementManager.h"
#import "ADTypicalRecordModel.h"
#import "ADTypitalRecordCell.h"
#import "UILabel+CustomeLabel.h"
#import "ADSortModel.h"
#import "ADMilestoneVC.h"
@interface ADFetalPrimaryVC ()
{
    NSTimeInterval seconds1970;
   
    
}
@property (strong, nonatomic)UIImageView *cloadImageView;
//line
@property (strong, nonatomic) NSMutableArray *ArrayOfValues;//绘制曲线y值
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;//绘制曲线横坐标

//bar
@property (strong, nonatomic) NSMutableArray *ArrayOfBarXAxis;
@property (strong, nonatomic) NSMutableArray *ArrayOfBarValues;

//
@property(nonatomic,strong)UILabel *todayCountLabel;
@property(nonatomic,strong)UILabel *todayContentLabel;
@property(nonatomic,strong)UILabel *totalPredicationLabel;
@property(nonatomic,strong)UILabel *hourlyPredicationLabel;
//tabelView dataArray
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation ADFetalPrimaryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //NotificationCenter
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeRecord:) name:EndRecordFetalMovementNotification object:nil];
    }
    return self;
}
#pragma mark - Notification event
- (void)completeRecord:(NSNotification *)notification
{
    [self updateUI];
}
//可用来更新页面数据
- (void)viewWillAppear:(BOOL)animated{
    
        [self updateUI];
    
}
//invoke the method  update UI when need to refresh the view
- (void)updateUI
{
    seconds1970 = [[NSDate localdate] timeIntervalSince1970];
    //显示的数字需要更新
    int count1 = [[ADFetalMovementManager sharedADFetalMovementManager] getTotalCountByDate:seconds1970];
    int count2 = [[ADFetalMovementManager sharedADFetalMovementManager] getPredictDailyCountByDate:seconds1970];
    int count3 = [[ADFetalMovementManager sharedADFetalMovementManager] getPredictHourlyCountByDate:seconds1970];
    _todayCountLabel.text = [NSString stringWithFormat:@"%d",count1];
    _totalPredicationLabel.text = [NSString stringWithFormat:@"%d",count2];
    _hourlyPredicationLabel.text = [NSString stringWithFormat:@"%d",count3];
    
    
    //更新曲线图数据
    self.ArrayOfValues.array = [[ADFetalMovementManager sharedADFetalMovementManager] getHourlyStatDataByDate:seconds1970];
    self.ArrayOfDates.array  = [[ADFetalMovementManager sharedADFetalMovementManager] getTwentyfourHours];
    
    [self.ArrayOfBarValues removeAllObjects];
    [self.ArrayOfBarXAxis removeAllObjects];
    NSArray *arrayBar = [[ADFetalMovementManager sharedADFetalMovementManager] getTypicalRecordByDate:seconds1970];
    for (NSDictionary *dic in arrayBar) {
        [self.ArrayOfBarValues addObject:[dic objectForKey:kFetalCount]];
        [self.ArrayOfBarXAxis addObject:[dic objectForKey:kStartTimeStamp]];
    }

    [self.lineGraph reloadGraph];
    
    //更新列表数据
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *array = [[ADFetalMovementManager sharedADFetalMovementManager] getTypicalRecordByDate:seconds1970];
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        ADTypicalRecordModel *model = [[ADTypicalRecordModel alloc] initWithDictionary:dic order:(i+1)];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    seconds1970 = [[NSDate localdate] timeIntervalSince1970];
    [self configureNavigationView];
    [self addLineGraphView];
    [self addFetalMovementCountScrollView];
    [self addTypicalRecordView];
    UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton.frame = CGRectMake(100, 300, 100, 100);
    thirdButton.backgroundColor = [UIColor redColor];
    [thirdButton setTitle:@"Enter" forState:UIControlStateNormal];
    [thirdButton addTarget:self action:@selector(pushNextView) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:thirdButton];
    
  	// Do any additional setup after loading the view.

    
    
//    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"03:00",kStartTimeStamp, @"04:00",kEndTimeStamp,@"5",kFetalCount,nil];
//    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"06:00",kStartTimeStamp, @"07:00",kEndTimeStamp,@"12",kFetalCount, nil];
//    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"10:00",kStartTimeStamp, @"11:00",kEndTimeStamp,@"8",kFetalCount, nil];
//
//    NSArray *array = [NSArray arrayWithObjects:dic1,dic2,dic3, nil];
//    
//    
//    
//    NSLog(@"原始数据是%@",array);
//    
//    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
//    for (int i = 0; i <3; i++) {
//        
//        NSDictionary *dic = [array objectAtIndex:i];
//        NSString *str1 = [dic objectForKey:kStartTimeStamp];
//        NSString *str2 = [dic objectForKey:kEndTimeStamp];
//        NSString *str3 = [dic objectForKey:kFetalCount];
//
//        
//        ADSortModel *model = [ADSortModel modelWithCount:[str3 intValue] withStartTime:str1 withEndTime:str2];
//        [array1 addObject:model];
//    }
//    //然后再对tansferArray 数组进行排序，按照胎动次数高低排序
//    NSSortDescriptor *carNameDesc = [NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO];
//
//    NSArray *descriptorArray = [NSArray arrayWithObjects:carNameDesc, nil];
//    NSArray *sortedArray = [array1 sortedArrayUsingDescriptors: descriptorArray];
//    NSLog(@"排序之后的数据是什%@",sortedArray);
//
//
//    for (int i = 0; i < 3; i ++) {
//        ADSortModel *model = [sortedArray objectAtIndex:i];
//        
//        NSLog(@"次数是%d",model.count);
//    }



}
- (void)pushNextView
{
    ADSecondVC *secondVC = [[ADSecondVC alloc] initWithNavigationViewWithTitle:@"胎动详情"];
    [self.navigationController pushViewController:secondVC animated:YES];
}

#pragma mark - configure navigationView 
- (void)configureNavigationView
{
    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"historydata_button@2x"] forState:UIControlStateNormal];
    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"historydata_button_selected@2x"] forState:UIControlStateHighlighted];
    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"historydata_button_selected@2x"] forState:UIControlStateSelected];
    
    [self.navigationView.rightButton setBackgroundImage:[UIImage imageNamed:@"share_button@2x"] forState:UIControlStateNormal];
    [self.navigationView.rightButton setBackgroundImage:[UIImage imageNamed:@"share_button_selected@2x"] forState:UIControlStateHighlighted];
    [self.navigationView.rightButton setBackgroundImage:[UIImage imageNamed:@"share_button_selected@2x"] forState:UIControlStateSelected];

}
#pragma mark - navigation button event
- (void)clickLeftButton
{
    NSLog(@"点击里程碑按钮");
    ADMilestoneVC *milestoneVC = [[ADMilestoneVC alloc] initWithNavigationViewWithTitle:@"胎动里程碑"];
    [self.navigationController pushViewController:milestoneVC animated:YES];
}
- (void)clickRightButton
{
    NSLog(@"点击分享按钮");
}

#pragma mark - line graph
- (void)addLineGraphView
{
    //line datas
    self.ArrayOfValues = [[NSMutableArray alloc] init];
    self.ArrayOfDates = [[NSMutableArray alloc] init];
    
   
    self.ArrayOfValues.array = [[ADFetalMovementManager sharedADFetalMovementManager] getHourlyStatDataByDate:seconds1970];
    self.ArrayOfDates.array  = [[ADFetalMovementManager sharedADFetalMovementManager] getTwentyfourHours];
    
    NSLog(@"hahhahahaha%@", self.ArrayOfValues);
    
    //bar datas
    self.ArrayOfBarValues = [[NSMutableArray alloc] init];
    self.ArrayOfBarXAxis = [[NSMutableArray alloc] init];
    
    NSArray *array = [[ADFetalMovementManager sharedADFetalMovementManager] getTypicalRecordByDate:seconds1970];
    for (NSDictionary *dic in array) {
        [self.ArrayOfBarValues addObject:[dic objectForKey:kFetalCount]];
        [self.ArrayOfBarXAxis addObject:[dic objectForKey:kStartTimeStamp]];
    }
   
    int yAxias = 0;
    if (IOS7_OR_LATER) {
        yAxias = 20;
    }
    self.cloadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90/2 + yAxias, SCREEN_WIDTH, 380/2)];
    
    _cloadImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:118/255.0 blue:133/255.0 alpha:1.0];
    _cloadImageView.image = [UIImage imageNamed:@"cload_bg@2x"];
    _cloadImageView.userInteractionEnabled = YES;
    [self.view addSubview:_cloadImageView];
    
    self.graphBackgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, _cloadImageView.frame.size.height - 0)];
    _graphBackgroundScrollView.backgroundColor = [UIColor clearColor];
    _graphBackgroundScrollView.bouncesZoom = NO;
    _graphBackgroundScrollView.showsHorizontalScrollIndicator = NO;
    int yMargin = 0;
    if (IOS7_OR_LATER) {
        yMargin = 80;
    }
    _graphBackgroundScrollView.contentSize = CGSizeMake(640, _graphBackgroundScrollView.frame.size.height - yMargin);
    [_cloadImageView addSubview:_graphBackgroundScrollView];
    
    self.lineGraph = [[ADLineGraphView alloc] initWithFrame:CGRectMake(0,0, 640, _graphBackgroundScrollView.frame.size.height)];
    if (IOS7_OR_LATER) {
        _lineGraph.frame = CGRectMake(0,0, 640, _graphBackgroundScrollView.frame.size.height);
    }
    _lineGraph.delegate = self;
    _lineGraph.backgroundColor = [UIColor clearColor];
    _lineGraph.colorLine = [UIColor whiteColor];
    _lineGraph.colorXaxisLabel = [UIColor whiteColor];
    _lineGraph.widthLine = 1.0;
    _lineGraph.alphaLine = 1.0;
    _lineGraph.animationGraphEntranceSpeed = 5.0;
    [_graphBackgroundScrollView addSubview:_lineGraph];
    
    
}
#pragma mark - SimpleLineGraph Data Source
- (int)numberOfPointsInGraph {
    
    return (int)[self.ArrayOfValues count];

}

- (float)valueForIndex:(NSInteger)index {
    
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}
//optional delegate method
- (int)numberOfGradesInYAxis
{
    return 12 - 1;
}

//bar delegate method
- (int)numberOfPointsInBar
{
    return (int)[self.ArrayOfBarValues count];
}

//
- (float)valueOfBarForIndex:(NSInteger)index
{
    return [[self.ArrayOfBarValues objectAtIndex:index] floatValue];
}

//
- (float)xAxisOfBarForIndex:(NSInteger)index
{
    //要将类似“20:14”的时间转化成浮点数
    NSString *str = [self.ArrayOfBarXAxis objectAtIndex:index];
    NSArray *array = [str componentsSeparatedByString:@":"];
    float xAxis = [[array objectAtIndex:0] floatValue] + [[array objectAtIndex:1] floatValue]/60.0;
    return xAxis;
}
#pragma mark - SimpleLineGraph Delegate

- (int)numberOfGapsBetweenLabels {
    return 0;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index {
    return [self.ArrayOfDates objectAtIndex:index];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - total fetalCount && Prediction
/**
 *  已记录一天胎动总数  推测一天胎动总和平均每小时胎动
 */
- (void)addFetalMovementCountScrollView
{
    self.fetalMovementScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _cloadImageView.frame.origin.y + _cloadImageView.frame.size.height, SCREEN_WIDTH, 240/2)];
    _fetalMovementScrollView.backgroundColor = [UIColor whiteColor];
    _fetalMovementScrollView.bouncesZoom = NO;
    _fetalMovementScrollView.pagingEnabled = YES;
    _fetalMovementScrollView.showsHorizontalScrollIndicator = NO;
    _fetalMovementScrollView.contentSize = CGSizeMake(SCREEN_WIDTH *2, _fetalMovementScrollView.frame.size.height);
    [self.view addSubview:_fetalMovementScrollView];
    
    
    UILabel *todayTitle = [UILabel labelWithTitle:@"今日记录胎动总数"
                                            frame:CGRectMake((SCREEN_WIDTH - 200)/2, 30/2, 200, 24/2)
                                        textColor:kOrangeFontColor
                                    textAlignment:NSTextAlignmentCenter
                                             font:kMacroFontSize
                                        superView:_fetalMovementScrollView];
    
    
    NSDate *localDate = [NSDate localdate];
    NSTimeInterval seconds = [localDate timeIntervalSince1970];
    int count = [[ADFetalMovementManager sharedADFetalMovementManager] getTotalCountByDate:seconds];
    self.todayCountLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"%d",count]
                                            frame:CGRectMake((SCREEN_WIDTH - 70)/2, todayTitle.frame.origin.y + todayTitle.frame.size.height + 30/2, 70, 50)
                                        textColor:kRedFontColor
                                    textAlignment:NSTextAlignmentCenter
                                             font:[UIFont systemFontOfSize:120/2]
                                        superView:_fetalMovementScrollView];
    
    
    UILabel *unitLable1 = [UILabel labelWithTitle:@"次"
                                            frame:CGRectMake(_todayCountLabel.frame.origin.x + _todayCountLabel.frame.size.width, _todayCountLabel.frame.origin.y + _todayCountLabel.frame.size.height - 20 , 20, 20)
                                        textColor:kRedFontColor
                                    textAlignment:NSTextAlignmentLeft
                                             font:[UIFont systemFontOfSize:28/2]
                                        superView:_fetalMovementScrollView];

    
    
    self.todayContentLabel = [UILabel labelWithTitle:@"2222222位妈妈记录超过20次"
                                            frame:CGRectMake((SCREEN_WIDTH - 300)/2, _todayCountLabel.frame.origin.y + _todayCountLabel.frame.size.height + 24/2, 300, 24/2)
                                        textColor:kRedFontColor
                                    textAlignment:NSTextAlignmentCenter
                                             font:kMacroFontSize
                                        superView:_fetalMovementScrollView];


    UILabel *totalPredicationTitle = [UILabel labelWithTitle:@"推算今日胎动总数"
                                               frame:CGRectMake( 320 + 48/2, todayTitle.frame.origin.y, 150, todayTitle.frame.size.height)
                                           textColor:todayTitle.textColor
                                       textAlignment:NSTextAlignmentLeft
                                                font:todayTitle.font
                                           superView:_fetalMovementScrollView];

    
    count = [[ADFetalMovementManager sharedADFetalMovementManager] getPredictDailyCountByDate:seconds];
    self.totalPredicationLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"%d",count]
                                                       frame:CGRectMake(totalPredicationTitle.frame.origin.x, totalPredicationTitle.frame.origin.y + totalPredicationTitle.frame.size.height + 40/2, 70, 50)
                                                   textColor:kRedFontColor
                                               textAlignment:NSTextAlignmentCenter
                                                        font:[UIFont systemFontOfSize:120/2]
                                                   superView:_fetalMovementScrollView];

    
    UILabel *unitLable2 = [UILabel labelWithTitle: @"次"
                                                   frame:CGRectMake(_totalPredicationLabel.frame.origin.x + _totalPredicationLabel.frame.size.width, _totalPredicationLabel.frame.origin.y + _totalPredicationLabel.frame.size.height - 20, 20, 20)
                                               textColor:kRedFontColor
                                           textAlignment:NSTextAlignmentLeft
                                                    font:[UIFont systemFontOfSize:28/2]
                                               superView:_fetalMovementScrollView];

    
    UILabel *hourlyPredicationTitle = [UILabel labelWithTitle:@"推算每小时平均胎动"
                                            frame:CGRectMake( SCREEN_WIDTH + 356/2, todayTitle.frame.origin.y, 150, todayTitle.frame.size.height)
                                        textColor:todayTitle.textColor
                                    textAlignment:NSTextAlignmentLeft
                                             font:todayTitle.font
                                        superView:_fetalMovementScrollView];

    
    count = [[ADFetalMovementManager sharedADFetalMovementManager] getPredictHourlyCountByDate:seconds];
    self.hourlyPredicationLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"%d",count]
                                                        frame:CGRectMake(hourlyPredicationTitle.frame.origin.x, _totalPredicationLabel.frame.origin.y, 70, 50)
                                                    textColor:kRedFontColor
                                                textAlignment:NSTextAlignmentCenter
                                                         font:[UIFont systemFontOfSize:120/2]
                                                    superView:_fetalMovementScrollView];

    
    
    UILabel *unitLable3 = [UILabel labelWithTitle:@"次/每小时"
                                                    frame:CGRectMake(_hourlyPredicationLabel.frame.origin.x + _hourlyPredicationLabel.frame.size.width, _hourlyPredicationLabel.frame.origin.y + _hourlyPredicationLabel.frame.size.height - 20, 80, 20)
                                                textColor:kRedFontColor
                                            textAlignment:NSTextAlignmentLeft
                                                     font:[UIFont systemFontOfSize:28/2]
                                                superView:_fetalMovementScrollView];


}

#pragma mark - total fetalCount && Prediction
/**
 *  展示当天典型的三次小时胎动记录
 */
- (void)addTypicalRecordView
{
    //加载tableview
    int kHeight;
    if (RETINA_INCH4) {
        kHeight = 200;
    }else{
        kHeight = 60;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _fetalMovementScrollView.frame.origin.y + _fetalMovementScrollView.frame.size.height, SCREEN_WIDTH,kHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:251/255.0 green:247/255.0 blue:241/255.0 alpha:1.0];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *array = [[ADFetalMovementManager sharedADFetalMovementManager] getTypicalRecordByDate:20000];
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        ADTypicalRecordModel *model = [[ADTypicalRecordModel alloc] initWithDictionary:dic order:(i+1)];
        [self.dataArray addObject:model];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellTypicalRecord = @"CellTypicalRecord";
    
    ADTypitalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTypicalRecord];
    if (cell == nil) {
        cell = [[ADTypitalRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTypicalRecord];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ADTypicalRecordModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.recordModel = model;
    
    return cell;
    
    
}
#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
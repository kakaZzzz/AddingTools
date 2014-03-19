//
//  ADMilestoneVC.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-7.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADMilestoneVC.h"
#import "ADMilestoneContentCell.h"
#import "ADMilestoneSectionCell.h"
#import "ADMilestoneModel.h"
#import "ADFetalMovementManager.h"
@interface ADMilestoneVC ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIImageView *cloadImageView;
@property(nonatomic,assign)int currentRow;
@end

@implementation ADMilestoneVC

- (void)dealloc
{
    NSLog(@"------milestone dealloc");
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNavigationView];
    
    int yAxias = 0;
    if (IOS7_OR_LATER) {
        yAxias = 20;
    }

    self.cloadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90/2 + yAxias, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _cloadImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:118/255.0 blue:133/255.0 alpha:1.0];
    _cloadImageView.image = [UIImage imageNamed:@"milestone_cload_bg@2x"];
    _cloadImageView.userInteractionEnabled = YES;
    [self.view addSubview:_cloadImageView];

    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45 + yAxias, 320,self.view.frame.size.height - (45 + yAxias))];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    NSDate *loacalDate = [NSDate localdate];
    NSLog(@"当前日期是%@",loacalDate);
    self.dataArray.array = [self getHistoryDataWithStartDate:loacalDate timeSpan:15];
    [self.tableView reloadData];
    
 }
- (void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:_currentRow inSection:0];
    //放在此处不合适  容易message sent to deallocated instance
  //  [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];

}
#pragma mark - configure navigationView
- (void)configureNavigationView
{
    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"back_button_bg@2x"] forState:UIControlStateNormal];

    
}
#pragma mark - navigation button event
- (void)clickLeftButton
{
    NSLog(@"点击里程碑按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)clickRightButton
{
    NSLog(@"点击分享按钮");
}

#pragma mark - 根据日期得到历史数据
/**
 *  根据日期得到历史数据
 *
 *  @param startDate 当前日期
 *  @param day       往后多顺延天数
 *
 *  @return 数据model数组
 */
- (NSArray *)getHistoryDataWithStartDate:(NSDate *)startDate timeSpan:(int)day//day 是跨度天数
{
    double start = 0;
    NSLog(@"第一次记录历史什么东西%@",[[NSUserDefaults standardUserDefaults] objectForKey:kFirstRecordFetal]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFirstRecordFetal]) {
        NSLog(@"滚犊子");
          start = [[[NSUserDefaults standardUserDefaults] objectForKey:kFirstRecordFetal] doubleValue];
          _currentRow = ([startDate timeIntervalSince1970] - start)/(60 * 60 *24);
        
    }else{
        start = [startDate timeIntervalSince1970];
        _currentRow = 0;
    }
    
   
    NSDate *endDate = [startDate addDay:day];
    double end = [endDate timeIntervalSince1970];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *resultArray = [[ADFetalMovementManager sharedADFetalMovementManager] getMilestonsDataWithStartDate:start endDate:end];
    
    for (int i = 0; i < [resultArray count]; i ++) {
        NSDictionary *dic = [resultArray objectAtIndex:i];
        ADMilestoneModel *model = [[ADMilestoneModel alloc] initWithDictionary:dic];
        [array addObject:model];
    }
    
    return array;
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
    
    static NSString *CellRow = @"CellTypicalRecord";
    static NSString *CellSection = @"cellSection";
    
    ADMilestoneContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellRow];
    ADMilestoneSectionCell *cellSection = [tableView dequeueReusableCellWithIdentifier:CellSection];
    
    ADMilestoneModel *model = [self.dataArray objectAtIndex:indexPath.row];

    if (cell == nil) {
        cell = [[ADMilestoneContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellRow];
        
    }
    
    if (cellSection == nil) {
        cellSection = [[ADMilestoneSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellSection];
    }
    
    if (model.isSection) {
        
        cellSection.model = model;
        cellSection.selectionStyle = UITableViewCellSelectionStyleBlue;

        return cellSection;
    }else{
        cell.model = model;
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
    
    
    
    
}
#pragma mark - tabelview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ADMilestoneModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.isSection) {
        NSLog(@"+++++++++++++++++++++++++++++++++++++++");
        return 48/2;
    }else{
        return 68/2;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

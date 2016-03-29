//
//  TravelNoteViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "TravelNoteViewController.h"
#import "RESideMenu.h"
#import "Header.h"
#import "MJRefresh.h"
#import "TravelNoteModel.h"
#import "SecondNoteModel.h"
#import "MWTravelNoteCell.h"
#import "UIImageView+WebCache.h"
#import "DetailTravelViewController.h"
#import "SDCycleScrollView.h"
#define kTravelCell @"rose"
#define kBaseUrlString @"http://api.breadtrip.com/trips/hot/?start=%ld&count=20&is_ipad=true"
// 引入全局变量
extern NSMutableArray *idArray;


@interface TravelNoteViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>
@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic , retain) NSMutableArray *datasourceArray;
@property (nonatomic , assign) NSInteger pageNumber;
@property (nonatomic , retain) NSMutableArray *minArray;
//@property (nonatomic , retain) UIImage *image;
@property (nonatomic , assign) BOOL isDown;
@property (nonatomic , assign) NSTimer *timer;


@end

@implementation TravelNoteViewController

- (void)dealloc
{
    self.datasourceArray = nil;
    self.tableView = nil;
    self.minArray = nil;
//    self.image = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
   [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1.0] forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)getImageWithAlpha:(CGFloat)alpha {
    
    UIColor *color=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:alpha];
    CGSize colorSize=CGSizeMake(1, 1);
    
    UIGraphicsBeginImageContext(colorSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    


    self.title = @"旅行日志";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xuanxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    
    //    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentRightMenuViewController:)];
    
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
   
    [self setupTableView];
    
    [self setUpScrollView];
    
    // 注册cell
    [self.tableView registerClass:[MWTravelNoteCell class] forCellReuseIdentifier:kTravelCell];
    
    // 初始化数据源
    self.datasourceArray = [NSMutableArray array];
    self.minArray = [NSMutableArray array];
    [self.tableView addHeaderWithTarget:self action:@selector(downRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(upRefresh)];
    
    // 进去程序自动下拉一次
    [self.tableView headerBeginRefreshing];
   
}

#pragma mark - 创建轮播图
- (void)setUpScrollView {
    
    NSArray *images = @[[UIImage imageNamed:@"lunbo1.jpeg"] , [UIImage imageNamed:@"lunbo2.jpg"], [UIImage imageNamed:@"lunbo3.jpg"]];
    NSArray *titles = @[@"梦想，并不奢侈，只要勇敢地迈出第一步。" , @"因为有梦,所以勇敢出发，选择出发，便是风雨兼程。" , @"旅游不在乎终点，而是在意途中的美好记忆和景色。"];
    
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSW, kSW*0.53) imagesGroup:images];
    
    scrollView.titlesGroup = titles;
    scrollView.autoScrollTimeInterval = 3.0;
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    scrollView.delegate = self;
    self.tableView.tableHeaderView = scrollView;
   
}

#pragma mark - 轮播代理协议
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    
}


#pragma mark - 下拉刷新，上拉加载
- (void)downRefresh
{
    _isDown = YES;
    self.pageNumber = 0;
    [self paserData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

#pragma mark - 定时器
- (void)timerAction
{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

- (void)upRefresh
{
    _isDown = NO;
    self.pageNumber++;
    [self paserData];
}

- (void)setupTableView {
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    [_tableView release];
    
}

- (void)paserData
{
    NSString *urlStr = [NSString stringWithFormat:kBaseUrlString , (long)self.pageNumber];

    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            if (_isDown == YES) {
                [self.datasourceArray removeAllObjects];
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *trips = [NSMutableArray arrayWithArray:dic[@"trips"]];
            for (NSDictionary *minDic in trips) {
                
                TravelNoteModel *model = [TravelNoteModel new];
                
                NSDictionary *aDic = [minDic valueForKey:@"user"];
                
                SecondNoteModel *minModel = [SecondNoteModel new];
                
                
                minModel.name = [aDic valueForKey:@"name"];
                minModel.avatar_m = [aDic valueForKey:@"avatar_m"];
                
                
                [self.minArray addObject:minModel];
                [minModel release];
               
                [model setValuesForKeysWithDictionary:minDic];
              
                
                
                // 全局变量

                NSString *str = [NSString stringWithFormat:@"%@", minDic[@"id"]];
     
                [idArray addObject:str];
                
            
                [self.datasourceArray addObject:model];
                
                [model release];
                
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            [trips removeAllObjects];
        }
    }];
}


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasourceArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   
    return @"精彩游记专题";

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSW*0.56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    MWTravelNoteCell *acell = [tableView dequeueReusableCellWithIdentifier:kTravelCell forIndexPath:indexPath];
    
 
//    static NSString *cellId = @"cellId";
//    MWTravelNoteCell *acell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!acell) {
//        acell = [[MWTravelNoteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//    }
    
   
    acell.travelNoteModel = self.datasourceArray[indexPath.row];
    
    SecondNoteModel *authorModel = self.minArray[indexPath.row];
    acell.userName.text = [NSString stringWithFormat:@"by %@" , authorModel.name];
    [acell.userView sd_setImageWithURL:[NSURL URLWithString:authorModel.avatar_m]];
    
  
    return acell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTravelViewController *detailVC = [DetailTravelViewController new];
   TravelNoteModel *model = self.datasourceArray[indexPath.row];
   detailVC.MWID = model.ID;
    detailVC.MWIndex = indexPath.row;
    detailVC.modelArr = self.datasourceArray;
   
    // 提供第三方分享用的照片
    NSString *str = model.cover_image_default;
    NSURL *url = [NSURL URLWithString:str];
    NSData *data = [NSData dataWithContentsOfURL:url];
    detailVC.image = [UIImage imageWithData:data];
    
   
    
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

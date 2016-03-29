//
//  WeatherViewController.m
//  RoamProject
//
//  Created by zongqingle on 15-9-5.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "WeatherViewController.h"
#import "RESideMenu.h"
#import "WeatherCell.h"
#import "WeatherMoedel.h"
#import "Header.h"
@interface WeatherViewController ()<UISearchBarDelegate , UITableViewDataSource , UITableViewDelegate>
//搜索框
@property (nonatomic , retain) UISearchBar *searchPlace;
@property (nonatomic, retain) UITableView *tableView;

//接受数据
@property (nonatomic , retain) NSMutableDictionary *placeDic;
@property (nonatomic , retain) NSMutableArray *weatherArray;

@property (nonatomic , retain) NSString *weaidKey;

@end

@implementation WeatherViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //self.title = @"天气";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xuanxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    
    //    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentRightMenuViewController:)];
    
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:kSB style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableView];
    [_tableView release];
    
    // Do any additional setup after loading the view.
    //添加搜索框
    self.searchPlace = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.searchPlace.placeholder = @"请输入地点";
    self.navigationItem.titleView = self.searchPlace;
    self.searchPlace.barStyle = UIBarStyleDefault;
    self.searchPlace.showsCancelButton = YES;
    [self.searchPlace release];
    self.searchPlace.delegate = self;
    
    //cell代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //初始化数组
    self.weatherArray = [NSMutableArray array];
    self.placeDic = [NSMutableDictionary dictionary];
    [self placeLoadDataShow];
    self.weaidKey = @"59";
    [self weatherLoadDataShow];
    
    [self configureTableHeaderView];
    
}

// 设置TableHeaderView
- (void)configureTableHeaderView {
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSW, 100)];
    //view.backgroundColor = [UIColor yellowColor];
    view.clipsToBounds = YES;
  
    self.tableView.tableHeaderView = view;
   
   UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tianqiheader"]];
    topView.frame = view.frame;
    [view addSubview:topView];
    [topView release];
    [view release];
 
}

#pragma  mark - leftButtonItem的点击事件
- (void)leftAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获得地点数据
- (void)placeLoadDataShow
{
    NSString *urlString = @"http://api.k780.com:88/?app=weather.city&format=json";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSString *key in [dataDic allKeys]) {
                if ([key isEqualToString:@"result"]) {
                    self.placeDic = dataDic[key];
                }
            }
        }
        [self.tableView reloadData];
    }];
    
}
#pragma mark - 获得天气数据
- (void)weatherLoadDataShow
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.future&weaid=%@&appkey=15080&sign=ce13066b71dd9f5e156148e40eb4ca8f&format=json" , self.weaidKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSString *key in [dataDic allKeys]) {
                if ([key isEqualToString:@"result"]) {
                    for (NSDictionary *miniDic in dataDic[key]) {
                        WeatherMoedel *model = [[WeatherMoedel alloc] init];
                        model.citynm = miniDic[@"citynm"];
                        model.days = miniDic[@"days"];
                        model.week = miniDic[@"week"];
                        model.weather = miniDic[@"weather"];
                        model.temperature = miniDic[@"temperature"];
                        model.wind = miniDic[@"wind"];
                        model.winp = miniDic[@"winp"];
                        [self.weatherArray addObject:model];
                        [model release];
                    }
                }
            }
        }
        [self.tableView reloadData];
    }];
    
}



#pragma mark - cell的代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.weatherArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.578*kSW;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WeatherCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }

    //WeatherMoedel *model = [[WeatherMoedel alloc] init];
    WeatherMoedel *model = self.weatherArray[indexPath.section];
    cell.model = model;

    
//    cell.citynm.text = model.citynm;
//    cell.days.text = model.days;
//    cell.week.text = model.week;
//    cell.weather.text = model.weather;
//    cell.temperature.text = model.temperature;
//    cell.wind.text = model.wind;
//    cell.winp.text = model.winp;
    
    return cell;
}



#pragma mark - 搜索框的代理事件
//取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchPlace setShowsCancelButton:YES animated:YES];
    self.searchPlace.text = nil;
    [self.searchPlace resignFirstResponder];
}
//搜索按钮的点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    //NSLog(@"%@" , self.placeDic);
    [self.searchPlace resignFirstResponder];
    
    for (NSString *placeKey in [self.placeDic allKeys]) {
        NSDictionary *miniDic  = self.placeDic[placeKey];
        //搜索框输入汉字 对应的key值 @"citynm" 英语@"cityno"
        if ([self.searchPlace.text isEqualToString:miniDic[@"citynm"]] || [self.searchPlace.text isEqualToString:[NSString stringWithFormat:@"%@省" ,miniDic[@"citynm"]]] ||  [self.searchPlace.text isEqualToString:[NSString stringWithFormat:@"%@市" ,miniDic[@"citynm"]]] ||  [self.searchPlace.text isEqualToString:[NSString stringWithFormat:@"%@县" ,miniDic[@"citynm"]]]) {
                self.weaidKey = miniDic[@"weaid"];
        }
    }
    [self.weatherArray removeAllObjects];
    [self weatherLoadDataShow];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    [_placeDic release];
    [_weaidKey release];
    [_weatherArray release];
    [_searchPlace release];
    [_tableView release];
    [super dealloc];
}
@end

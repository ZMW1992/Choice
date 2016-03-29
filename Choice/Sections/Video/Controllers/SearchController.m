//
//  SearchController.m
//  Choice
//
//  Created by lanouhn on 16/1/14.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "SearchController.h"
#import "AFNetworking.h"
#import "Video.h"
#import "VideoCell.h"
#import "Play.h"
#import "VideoPlayController.h"
#import "MJRefresh.h"
#import "Header.h"

//#import "PlayViewController.h"
#define kUrl @"http://115.28.54.40:8080/beautyideaInterface/api/v1/resources/search_res?condition=%@&pageNo=%ld&deviceModel=H30-U10&username=&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&pageSize=10&imieId=E20B65E58C77354FE86190E4091ABFB0"

@interface SearchController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>



@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic , retain)UITableView *baseTableView;

@property (nonatomic, assign) NSInteger page;

@end

@implementation SearchController

- (void)dealloc{
    self.searchBar = nil;
    self.dataSource = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.searchBar.hidden = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    
    
    // 配置searchBar
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(60, 30, 0.7*kSW, 34)];
    [self.searchBar setSearchBarStyle:UISearchBarStyleDefault];
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入搜索内容";
    
    [self.navigationController.view addSubview:self.searchBar];
    [self.searchBar release];
    
    
    self.baseTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView release];
    self.baseTableView.delegate =self;
    self.baseTableView.dataSource = self;
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(removeSrarchBar:)] autorelease];
    
    // 热词搜索
 //   [self loadDataWithString:self.hotWords];
    
    self.searchBar.text = self.hotWords;
    
  //  NSLog(@"随碟附送%@", self.hotWords);
    
    [self cancleKeyboard];
    
    
    
    
    
    
    self.page = 0;
    
  
    [self loadDataWithString:self.hotWords];
        
   
    
    
    // 上拉加载
    [self.baseTableView addFooterWithCallback:^{
        self.page += 10;
        
        [self loadDataWithString:self.hotWords];
        
        //        [self.tableView footerEndRefreshing];
    }];
    
    
    
    // 自动刷新
    [self.baseTableView headerBeginRefreshing];
    self.baseTableView.headerRefreshingText = @"加载中...";
   
}



#pragma mark - 网络请求数据
- (void)loadDataWithString:(NSString *)str {
    
    // 创建网络请求管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = [NSString stringWithFormat:kUrl, [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.page];
    
    
    
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    __block typeof(self)weakSelf = self;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //    NSLog(@"%@", responseObject);
        
 
        
        NSArray *array = responseObject[@"resources"];
        
//        if (self.page < 1) {
//            
//            // 先清空数据
//            [self.dataSource removeAllObjects];
//            
//        }
        
        
        
        
        
        for (NSDictionary *dic in array) {
            // 创建video对象
            Video *video = [[Video alloc]init];
            [video setValuesForKeysWithDictionary:dic];
            
            [weakSelf.dataSource addObject:video];
            
            [video release];
            
        }
        
      
            [self.baseTableView footerEndRefreshing];
       
        
        
        [self.baseTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}



- (void)cancleKeyboard
{
   
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.searchBar resignFirstResponder];
}




// 返回时移除SearchBar
- (void)removeSrarchBar:(UIBarButtonItem *)sender {
    
    [self.searchBar removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}




#pragma mark - UISearchBarDelegate
// 搜索框内添加取消按钮
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}


// 点击取消时回收键盘
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar.text.length != 0) {

        [self loadDataWithString:searchBar.text];
        
    }
//    [searchBar resignFirstResponder];
    
    
}




#pragma mark - UITableViewDataSource
// 返回cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

// 给cell赋值
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Video *vid = self.dataSource[indexPath.row];
    
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell assignForCellSubviews:vid];
    return cell;
}


// 返回cell高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return kSW/2;

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    
    [self searchBarSearchButtonClicked:searchBar];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//   // [self.view endEditing:YES];
//  //  [self.baseTableView endEditing:YES];
//    [self.searchBar resignFirstResponder];
////    [self.baseTableView becomeFirstResponder];
//}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DetailController *deVC = [[DetailController alloc] init];
//    SerachObject *serch = self.dataAry[indexPath.row];
//    deVC.Id = serch.textID;
//    deVC.countNu = [serch.countNum intValue];
//    deVC.classArtc = 2;
//    deVC.hidesBottomBarWhenPushed = YES;
//    [self.serchBar removeFromSuperview];
//    
//    [self.navigationController pushViewController:deVC animated:YES];
//    [deVC release];
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    [self.searchBar removeFromSuperview];
    self.searchBar.hidden = YES;
    

    Video *vid = self.dataSource[indexPath.row];
    
    
    
    VideoPlayController *playVC = [[VideoPlayController alloc] init];

    playVC.aID = vid.rsId;
    
 
    playVC.moduleID = vid.modulesId;
    
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:playVC animated:YES];
    
    self.parentViewController.hidesBottomBarWhenPushed = NO;
    
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

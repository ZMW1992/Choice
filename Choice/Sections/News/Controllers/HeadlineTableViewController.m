//
//  HeadlineTableViewController.m
//  Choice
//
//  Created by dream2021 on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "HeadlineTableViewController.h"
#import "BGNewsCell.h"
#import "BGNews.h"
#import "BGNewsDetailViewController.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"



#define kBGURLTouList @"http://admin.tingwen.me/index.php/api/interface/touList"
#define kBGURLPOSTList @"http://admin.tingwen.me/index.php/api/interface/postList"

@interface HeadlineTableViewController ()

@property (nonatomic, retain) NSMutableArray *dataSourceM;
@property (nonatomic, assign) NSInteger page;



@end

@implementation HeadlineTableViewController

- (void)dealloc {
    self.dataSourceM = nil;
    [super dealloc];
}


- (NSMutableArray *)dataSourceM {
    if (!_dataSourceM) {
        self.dataSourceM = [NSMutableArray arrayWithCapacity:1];
    }
    return [[_dataSourceM retain] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.page = 1;
}

#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
 
   
    self.page = 1;
    
    // 第三方
    [self addVenders];  
    
    // 加载数据
    [self readDataFromPlist];

    
    /**
     *  tableView 相关属性
     */
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    // 隐藏分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 90;
    [self.tableView registerClass:[BGNewsCell class] forCellReuseIdentifier:@"BGcell"];
}

/**
 *  添加第三方控件：过渡效果、刷新加载
 */
- (void)addVenders {
    // 展示过渡效果
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"拼命加载中..."];
    // 几秒后，自动消失
    [SVProgressHUD dismissWithDelay:8.0];
    
    
    // 刷新与加载
    __block typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf readDataFromPlist];
    }];
    
    [self.tableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf readDataFromPlist];
    }];

    // 自动刷新
    [self.tableView headerBeginRefreshing];
    self.tableView.headerRefreshingText = @"正在拼命加载中...";
    
}


- (void)readDataFromPlist {
    
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsList.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSDictionary *dic = dict[self.title];
    
    [self getDataByURLString:dic[@"url"] bodyString:dic[@"parameter"]];

}


/**
 *  获取网络数据
 *
 *  @param urlStr     请求头
 *  @param bodyString 请求体
 */
- (void)getDataByURLString:(NSString *)urlStr bodyString:(NSString *)bodyString {
  
//    self.page++;
    
    NSString *str = [NSString stringWithFormat:@"page=%ld&%@", self.page, bodyString];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    /**
     *  打印 error信息，最后 content-type: 对应的字符串
     */
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    [requestM setHTTPMethod:@"POST"];
    [requestM setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block typeof(self) weakSelf = self;
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:requestM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (weakSelf.page == 1) {
            // 清空数据源
            [weakSelf.dataSourceM removeAllObjects];
        }
        
        NSArray *arr = responseObject[@"results"];
        NSMutableArray *group = [NSMutableArray arrayWithCapacity:arr.count];
        
        for (NSDictionary *dic in arr) {
            BGNews *model = [[BGNews alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [group addObject:model];
            [model release];
        }
        [weakSelf.dataSourceM addObjectsFromArray:group];
        
        // 回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 停止刷新
            if (weakSelf.page == 1) {
                [weakSelf.tableView headerEndRefreshing];
            } else {
                [weakSelf.tableView footerEndRefreshing];
            }
            
            [weakSelf.tableView reloadData];
            
            // 隐藏过渡效果
            [SVProgressHUD dismiss];
        });
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"重新查看 BGNews ⚠️ %@", error);
    }];
    [manager.operationQueue addOperation:operation];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceM.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BGNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGcell" forIndexPath:indexPath];
   
    BGNews *model = self.dataSourceM[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BGNewsDetailViewController *vc = [[BGNewsDetailViewController alloc] init];
    vc.dataArrM = self.dataSourceM;
    vc.currentNum = indexPath.row;
    vc.title = @"新闻详情";
    
    self.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    self.parentViewController.parentViewController.hidesBottomBarWhenPushed = NO;
    [vc release];
}


@end

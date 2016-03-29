//
//  GroupDetailViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/12.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "VideoCell.h"
#import "AFNetworking.h"
#import "Video.h"
#import "VideoPlayController.h"
#import "Play.h"
#import "MJRefresh.h"
//#import "PlayViewController.h"
#define kVideocell @"cell"
#define kURL @"http://115.28.54.40:8080/beautyideaInterface/api/v1/resources/getResourcesByModulesId?pageNo=%ld&deviceModel=H30-U10&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&pageSize=10&modulesId=%ld&imieId=E20B65E58C77354FE86190E4091ABFB0"

@interface GroupDetailViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource; // 存储分类
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, retain) VideoCell *videocell;


@end

@implementation GroupDetailViewController

- (void)dealloc {
    self.dataSource = nil;
    self.videocell = nil;

    [super dealloc];
}






-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return [[_dataSource retain]autorelease];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    //  下拉刷新
    [self.tableView addHeaderWithCallback:^{
        
        [self readDataFromNetWork];
    }];
    
    
    // 上拉加载
    [self.tableView addFooterWithCallback:^{
        self.page += 10;
        [self readDataFromNetWork];
    }];
    
    
    
    // 自动刷新
    [self.tableView headerBeginRefreshing];
    self.tableView.headerRefreshingText = @"加载中...";
    
    // 注册cell
    [self.tableView registerClass:[VideoCell class] forCellReuseIdentifier:kVideocell];
}



// 请求网络数据
- (void)readDataFromNetWork {
    
    // 创建网络请求管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = [NSString stringWithFormat:kURL, self.page, self.aID];
    
    
    __block typeof(self)weakSelf = self;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
 //       NSLog(@"%@", responseObject);
        
        NSArray *array = responseObject[@"resources"];
        
        if (self.page < 1) {
            // 先清空数据
            [self.dataSource removeAllObjects];
        }
        
        
        for (NSDictionary *dic in array) {
            // 创建video对象
            Video *video = [[Video alloc]init];
            [video setValuesForKeysWithDictionary:dic];
            
            [weakSelf.dataSource addObject:video];
            [video release];
            
        }
        
        
        if (self.page < 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        
        
        
        [weakSelf.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       // NSLog(@"%@", error);
    }];
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

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:kVideocell forIndexPath:indexPath];
    
    Video *vid = self.dataSource[indexPath.row];
    
    [cell assignForCellSubviews:vid];
    
    // Configure the cell...
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Play *play = self.dataSource[indexPath.row];
    
    Video *play = self.dataSource[indexPath.row];
    
    
    VideoPlayController *playVC = [[VideoPlayController alloc] init];
  
    playVC.aID = play.rsId;

    
    if (play.modulesId) {
         playVC.moduleID = play.modulesId;
    }
   
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:playVC animated:YES];
    
    self.parentViewController.hidesBottomBarWhenPushed = NO;
    
    [playVC release];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

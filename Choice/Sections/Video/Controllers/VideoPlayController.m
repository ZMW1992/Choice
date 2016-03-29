//
//  VideoPlayController.m
//  Choice
//
//  Created by lanouhn on 16/1/15.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "VideoPlayController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Play.h"
#import "DescriptionCell.h"
#import "CommentCell.h"
#import "DCPicScrollView.h"
#import "Recommend Cell.h"
#import "SearchController.h"
#import "UMSocial.h"
#import "Header.h"
#import "Video.h"
#import "DataBase.h"
#import "SVProgressHUD.h"
#import "UMSocial.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


extern NSString *fromoneview;


@interface VideoPlayController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataSource;  // 存放描述数据
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *videoDataSource;  // 存放视频数据
@property (nonatomic, retain) NSMutableArray *commentDataSource;  // 存放评论数据
@property (nonatomic, retain) NSMutableArray *recommendDataSource; // 存放推荐数据
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) UIBarButtonItem *right2;// 收藏按钮
@property (nonatomic, retain) UIImage *name; // 收藏按钮图片

@property (nonatomic, assign) AVPlayerViewController *playerVC;

@end

@implementation VideoPlayController

- (void)dealloc{
    self.dataSource = nil;
    self.videoDataSource = nil;
    self.commentDataSource = nil;
    self.recommendDataSource = nil;
    self.tableView = nil;
    self.player = nil;
    self.right2 = nil;
    self.name = nil;
    self.videoArr = nil;
    [super dealloc];
}


//
//// 配置导航条颜色
//-( UIColor *) getColor:( NSString *)hexColor
//
//{
//    
//    unsigned int red, green, blue;
//    
//    NSRange range;
//    
//    range. length = 2 ;
//    
//    range. location = 0 ;
//    
//    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&red];
//    
//    range. location = 2 ;
//    
//    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
//    
//    range. location = 4 ;
//    
//    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&blue];
//    
//    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : 1.0f ];
//    
//}
//





#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    
    return [[_dataSource retain]autorelease];
}

- (NSMutableArray *)videoDataSource {
    
    if (!_videoDataSource) {
        self.videoDataSource = [NSMutableArray array];
    }
    
    return [[_videoDataSource retain] autorelease];
}


- (NSMutableArray *)commentDataSource {
    
    if (!_commentDataSource) {
        self.commentDataSource = [NSMutableArray array];
    }
    
    return [[_commentDataSource retain] autorelease];
}

- (NSMutableArray *)recommendDataSource {
    
    if (!_recommendDataSource) {
        self.recommendDataSource = [NSMutableArray array];
    }
    
    return [[_recommendDataSource retain] autorelease];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(5, kSW*0.6, kSW-2*5, kSH - 136) style:UITableViewStyleGrouped] autorelease];
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    
    return [[_tableView retain] autorelease];
}


#pragma mark - 加载数据
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SDImageCache sharedImageCache] clearMemory];
    
    // 分享按钮
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-601"] style:(UIBarButtonItemStylePlain) target:self action:@selector(handleRight1Btn:)];
    
    // 收藏按钮
    
    NSArray *arr = [[DataBase shareDataBase] selectVideoByID:self.aID];
    if (arr.count > 0) {
        self.name = [UIImage imageNamed:@"iconfont-iconfontshoucang"];
    }else{
        self.name = [UIImage imageNamed:@"star@2x"];
    }
    
    //self.name = [UIImage imageNamed:@"star@2x"];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithImage:self.name style:(UIBarButtonItemStylePlain) target:self action:@selector(actionRight2Btn:)];
    self.right2 = right2;
    // NSLog(@"%@", fromoneview);
    if ([fromoneview isEqualToString:@"collectionVC"]) {
        self.right2.enabled = NO;
    }
    fromoneview = nil;
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:right1, right2, nil]];
    
    [right1 release];
    [right2 release];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self GETData];
    

    // 注册DescriptionCellcell
    [self.tableView registerClass:[DescriptionCell class] forCellReuseIdentifier:@"descriptionCell"];
    
    // 注册commentCell
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"commentCell"];
  
}



// 分享
- (void)handleRight1Btn:(UIBarButtonItem *)sender {
    NSString *str = [NSString stringWithFormat:@"http://115.28.54.40:8080/beautyideaInterface/api/v1/resources/getPlayAdressByIdAndLink?deviceModel=H30U10&version=2.0.4.1&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&rsId=%@&link=http://v.youku.com/v_show/id_%@.html&imieId=E20B65E58C77354FE86190E4091ABFB0", self.aID, self.aID];
   // NSString *string = [NSString stringWithFormat:@"%@http://115.28.54.40:8080/beautyideaInterface/api/v1/resources/update_viewCount?deviceModel=H30-U10&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&rsId=%@&imieId=E20B65E58C77354FE86190E4091ABFB0", str, self.aID];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"569ca055e0f55a916100084a"
                                      shareText:str
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:nil];
    
}


// 收藏
static int num = 0;
- (void)actionRight2Btn:(UIBarButtonItem *)sender {
    
  //  Video *model = self.videoArr[self.index];
    
    Video *videoModel = self.videoArr[self.index];
    // 时间戳
    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter2 stringFromDate:date1];
    videoModel.time = dateString;
    if (num == 0) {
        [[DataBase shareDataBase] insertVideo:videoModel];
        // 显示菊花效果
        [SVProgressHUD showSuccessWithStatus:@"已收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
        [self.right2 setImage:[UIImage imageNamed:@"iconfont-iconfontshoucang"]];
        num = 1;
    }else{
        [[DataBase shareDataBase] deleteVideoByID:videoModel.rsId];
        // 显示菊花效果
        [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
        [self.right2 setImage:[UIImage imageNamed:@"star@2x"]];
        num = 0;
    }
   
}









- (void)GETData {
    [[SDImageCache sharedImageCache] clearMemory];
    [self.player pause];
    
    // 请求描述数据
    [self readDescriptionDataFromNetWorkWithID:self.aID];
    
    
    // 请求视频链接
    [self readVideoDataFromNetWorkWithID:self.aID];
    
    
    // 请求评论数据
    [self  loadCommentDataWithString:self.aID];
    
    
    // 请求轮播图(推荐)数据
    [self loadRecommendDataWithString:[NSString stringWithFormat:@"%ld", self.moduleID]];
    
    

}


// 配置播放器
- (void)configurePlayerView {
    
    self.playerVC = [[AVPlayerViewController alloc] init];
    
    _playerVC.view.frame = CGRectMake(0, 64, kSW, kSW*0.6);
    

    Play *model = [self.videoDataSource lastObject];
   
    
        self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:model.player]];
        
          _playerVC.player = self.player;
    
    
       [self.player play];
    
    
    
    [self.view addSubview:_playerVC.view];
    
   // [playerVC release];
   // [_player release];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.player pause];
    
    [self.playerVC.view removeFromSuperview];
    [_playerVC release];
    [_player release];
    [[SDImageCache sharedImageCache] clearMemory];
}



// 描述数据
- (void)readDescriptionDataFromNetWorkWithID:(NSString *)str {
    NSString *url = [NSString stringWithFormat:@"http://115.28.54.40:8080/beautyideaInterface/api/v1/resources/update_viewCount?deviceModel=H30-U10&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&rsId=%@&imieId=E20B65E58C77354FE86190E4091ABFB0", str];
    
    // 网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.dataSource removeAllObjects];
        NSDictionary *aDic = responseObject;
        
        Play *play = [[Play alloc] init];
        [play setValuesForKeysWithDictionary:aDic];
        [self.dataSource addObject:play];
        [play release];
        
//        NSLog(@"%@", self.dataSource);
        
        // 重走数据源方法
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"%@", error);
    }];
    
}


// 视频数据
- (void)readVideoDataFromNetWorkWithID:(NSString *)str {
    NSString *url = [NSString stringWithFormat:@"http://115.28.54.40:8080/beautyideaInterface/api/v1/resources/getPlayAdressByIdAndLink?deviceModel=H30-U10&version=2.0.4.1&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&rsId=%@&link=http://v.youku.com/v_show/id_%@.html&imieId=E20B65E58C77354FE86190E4091ABFB0", str, str];
    
    // 网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    __block typeof (self)weakSelf = self;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@", responseObject);
        [self.videoDataSource removeAllObjects];
        
        NSDictionary *aDic = responseObject;
        
        Play *play = [[Play alloc] init];
        [play setValuesForKeysWithDictionary:aDic];
        [weakSelf.videoDataSource addObject:play];
        [play release];
        
 //       NSLog(@"%@", weakSelf.videoDataSource);
        
        
        // 让集合视图对象重走数据源方法
        [weakSelf.tableView reloadData];
        

        // 调用播放器方法
        [self configurePlayerView];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       // NSLog(@"%@", error);
    }];
    
}



// 评论数据
- (void)loadCommentDataWithString:(NSString *)str {
    
    // 创建网络请求管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = [NSString stringWithFormat:@"http://115.28.54.40:8080/beautyideaInterface/api/v1/comments/getCommentsByRsId?pageNo=0&deviceModel=H30-U10&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&rsId=%@&pageSize=10&imieId=E20B65E58C77354FE86190E4091ABFB0", str];
    
    
    
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    __block typeof(self)weakSelf = self;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //    NSLog(@"%@", responseObject);
//        [self.dataSource removeAllObjects];
        
        NSArray *array = responseObject[@"comments"];
        
        [self.commentDataSource removeAllObjects];
        for (NSDictionary *dic in array) {
            // 创建video对象
            Play *play = [[Play alloc]init];
            [play setValuesForKeysWithDictionary:dic];
            
            [weakSelf.commentDataSource addObject:play];
            
            [play release];
            
        }
        
    //    NSLog(@"%@", weakSelf.commentDataSource);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       // NSLog(@"%@", error);
        
    }];
    
}







// 轮播图(推荐)数据

- (void)loadRecommendDataWithString:(NSString *)str {
    
    // 创建网络请求管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = [NSString stringWithFormat:@"http://115.28.54.40:8080/beautyideaInterface/api/v1/resources/recommend_res?albumId=&deviceModel=H30-U10&username=&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&modulesId=%@&imieId=E20B65E58C77354FE86190E4091ABFB0", [NSString stringWithFormat:@"%ld", self.moduleID]];
    
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    __block typeof(self)weakSelf = self;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //    NSLog(@"%@", responseObject);
//        [self.dataSource removeAllObjects];
        
        NSArray *array = responseObject[@"resources"];
        
        [self.recommendDataSource removeAllObjects];
        for (NSDictionary *dic in array) {
            // 创建video对象
            Play *play = [[Play alloc] init];
            [play setValuesForKeysWithDictionary:dic];
            
            [weakSelf.recommendDataSource addObject:play];
            
            [play release];
            
        }
        
  //      NSLog(@"第的所发生的%@", weakSelf.recommendDataSource);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       // NSLog(@"%@", error);
        
    }];
    
}




#pragma mark - 数据源代理方法

// 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.commentDataSource.count < 1) {
        return 2;
    } else
    
    
    return 3;
    
}



// 返回cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.dataSource.count;
    } else if (1 == section) {
     //   BOOL result = self.recommendDataSource.count == 0;
      //  return  result ? 0 : 1;
        return 1;
    }
    else{
      
        return self.commentDataSource.count;
    }
    
}

// 给cell赋值
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell" forIndexPath:indexPath];
        
        Play *play = self.dataSource[indexPath.row];
        
        [cell assignForCellSubviews:play];
        
        return cell;
        
    } else if (indexPath.section == 1) {
    
        Recommend_Cell *cell = [[Recommend_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        if (!cell.owner) {
            cell.owner = self;
        }
        
        
        cell.dataArray = self.recommendDataSource;
        
        return cell;
               }
    

    {
   
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
        
        Play *play = self.commentDataSource[indexPath.row];
        
        [cell assignForCommentCellSubviews:play];
        
        return cell;
    }
    

}


// 返回cell高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
           Play *play = self.dataSource[indexPath.row];
           CGFloat r = [play.title boundingRectWithSize:CGSizeMake(kSW-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} context:nil].size.height;
        
        
            
            CGFloat h = [play.descr boundingRectWithSize:CGSizeMake(kSW-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]} context:nil].size.height;
            
            
            return h + r + 40;
        
        
    } else if (indexPath.section == 2){
      
        Play *play = self.commentDataSource[indexPath.row];
        if (self.commentDataSource.count < 1) {
            return 0;
        }
        return [CommentCell getHeightWith:play]+70;
        
    }
    return 120;
}





//// 区头添加view
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    if (0 == section) {
//        
//        return nil;
//    }else {
//        
//        UIView *aView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)] autorelease];
//        
//        aView.backgroundColor = [UIColor whiteColor];
//        
//        return aView;
//    }
//    
//    
//    
//}



//设置区头高度

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (section == 0) {
        return 10;
    } else {
         return 1;
    }
  
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

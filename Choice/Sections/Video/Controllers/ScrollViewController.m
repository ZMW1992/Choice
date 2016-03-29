//
//  ScrollViewController.m
//  UICollectionViewTest-20
//
//  Created by lanouhn on 16/1/9.
//  Copyright © 2016年 LiPiaoYang. All rights reserved.
//

#import "ScrollViewController.h"
#import "VideoTableViewController.h"
#import "GroupViewController.h"
#import "SearchController.h"
#import "Header.h"
#import "RESideMenu.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kViewCount 2
#define kScreenHeight [UIScreen mainScreen].bounds.size.height




@interface ScrollViewController ()<UIScrollViewDelegate>


@property (nonatomic, retain)UIScrollView *scrollView;
@property (nonatomic, retain)UISegmentedControl *segmentControl;
@property (nonatomic, retain)VideoTableViewController *videoVC;
@property (nonatomic, retain)GroupViewController *groupVC;
//@property (nonatomic, retain)MovieViewController *movieVC;


@property (nonatomic, retain)UIView *segmentView;

@end

@implementation ScrollViewController


- (void)dealloc{
    self.scrollView = nil;
    self.segmentControl = nil;
    self.videoVC = nil;
    self.groupVC = nil;

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精彩视频";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xuanxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentRightMenuViewController:)];
    
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-sousuo-2"] style:(UIBarButtonItemStylePlain) target:self action:@selector(searchBar:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBtn, rightBtn2, nil]];
    
    [rightBtn release];
    [rightBtn2 release];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configureScrollView];
    [self configureSegmentControl];
    
    // Do any additional setup after loading the view.
}



// 配置segmentControl
- (void)configureSegmentControl {
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"", @""]];
//    self.navigationItem.titleView = self.segmentControl;
    
    _segmentControl.frame = CGRectMake(0, 64, kSW+10, 5);
    _segmentControl.tintColor = [UIColor orangeColor];
    _segmentControl.backgroundColor = [UIColor whiteColor];
   // [self.scrollView addSubview:_segmentControl];
    [self.view addSubview:self.segmentControl];
    
   
    
    [self.segmentControl addTarget:self action:@selector(handleControlAction:) forControlEvents:(UIControlEventValueChanged)];
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl release];
}

//segmentControl事件
- (void)handleControlAction:(UISegmentedControl *)sender{
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*sender.selectedSegmentIndex, 0)];
}







//配置scrollView
- (void)configureScrollView {
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 69, kSW, kScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(kViewCount*kSW, kScreenHeight);
    self.scrollView.bounces = NO;
    self.videoVC = [[VideoTableViewController alloc]init];
    self.groupVC = [[GroupViewController alloc]init];

    [self addChildViewController:self.videoVC];
    [self addChildViewController:self.groupVC];
    
    
    //右侧搜索效果
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBar:)];
    
    
    self.videoVC.view.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.groupVC.view.frame = CGRectMake(kSW, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self.scrollView addSubview:self.videoVC.view];
    [self.scrollView addSubview:self.groupVC.view];
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    
    
    [self.videoVC release];
    [self.groupVC release];
    [self.scrollView release];
    
}


//搜索栏效果
-(void)searchBar:(UIBarButtonItem *)sender
{
    SearchController *searchVC = [SearchController new];
    [self.navigationController pushViewController:searchVC animated:YES];
    [searchVC release];
}


//scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.segmentControl.selectedSegmentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    
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

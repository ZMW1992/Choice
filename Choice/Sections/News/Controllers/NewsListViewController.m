//
//  NewsListViewController.m
//  Choice
//
//  Created by dream2021 on 16/1/11.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "NewsListViewController.h"
#import "SCNavTabBarController.h"
#import "HeadlineTableViewController.h"
#import "RESideMenu.h"
@interface NewsListViewController ()

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯播报";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xuanxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    
    //    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentRightMenuViewController:)];
    
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
    
    
    [self configureSCNavTabBar];
}

- (void)configureSCNavTabBar {
    NSArray *group = @[@"头条", @"时政", @"社会", @"奇闻", @"段子", @"娱乐", @"体育", @"财经", @"科技", @"军事", @"房产"];
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:group.count];
    
    for (int i = 0; i < group.count; i++) {
        HeadlineTableViewController *newsVC = [[HeadlineTableViewController alloc] init];
        newsVC.title = group[i];
        [vcs addObject:newsVC];
        [newsVC release];
    }
    
    SCNavTabBarController *navTBC = [[SCNavTabBarController alloc] init];
    navTBC.subViewControllers = vcs;
    
    // 显示箭头
    navTBC.canPopAllItemMenu = YES;
    
    [navTBC addParentController:self];
    [navTBC release];
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

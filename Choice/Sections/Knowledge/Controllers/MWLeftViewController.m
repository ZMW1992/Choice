//
//  MWLeftViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/9.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "MWLeftViewController.h"
#import "RESideMenu.h"
#import "LoreViewController.h"
#import "NewsListViewController.h"
#import "TravelNoteViewController.h"
//#import "VideoTableViewController.h"
#import "MWMapViewController.h"
#import "WeatherViewController.h"
#import "CollectionViewController.h"
#import "ScrollViewController.h"
@interface MWLeftViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation MWLeftViewController

- (void)dealloc
{
    self.tableView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor cyanColor];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 7) / 2.0f, self.view.frame.size.width, 54 * 7) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.tableView release];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsListViewController *headVC = [[[NewsListViewController alloc] init] autorelease];
    UINavigationController *newsNC = [[[UINavigationController alloc] initWithRootViewController:headVC] autorelease];
    
    LoreViewController *loreVC = [[[LoreViewController alloc] init] autorelease];
    UINavigationController *loreNC = [[[UINavigationController alloc] initWithRootViewController:loreVC] autorelease];
    
    TravelNoteViewController *trvalVC = [[[TravelNoteViewController alloc] init] autorelease];
    UINavigationController *trvalNC = [[[UINavigationController alloc] initWithRootViewController:trvalVC] autorelease];
    
    ScrollViewController *videoVC = [[[ScrollViewController alloc] init] autorelease];
    UINavigationController *videoNC = [[[UINavigationController alloc] initWithRootViewController:videoVC] autorelease];
    
    MWMapViewController *mapVC = [[[MWMapViewController alloc] init] autorelease];
    UINavigationController *mapNC = [[[UINavigationController alloc] initWithRootViewController:mapVC] autorelease];
    

    CollectionViewController *collectionVC = [[[CollectionViewController alloc] init] autorelease];
    UINavigationController *collectionNC = [[[UINavigationController alloc] initWithRootViewController:collectionVC] autorelease];
    
    WeatherViewController *weatherVC = [[[WeatherViewController alloc] init] autorelease];
    UINavigationController *weatherNC = [[[UINavigationController alloc] initWithRootViewController:weatherVC] autorelease];
    
    switch (indexPath.row) {
        case 0:
        {
            [self.sideMenuViewController setContentViewController:loreNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;

        case 1:
        {
            [self.sideMenuViewController setContentViewController:newsNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 2:
        {
            [self.sideMenuViewController setContentViewController:trvalNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 3:
        {
            [self.sideMenuViewController setContentViewController:videoNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 4:
        {
            [self.sideMenuViewController setContentViewController:mapNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 5:
        {
            [self.sideMenuViewController setContentViewController:weatherNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 6:
        {
            [self.sideMenuViewController setContentViewController:collectionNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
       // cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
    }
    
    NSArray *titles = @[@"Home", @"资讯播报", @"旅行日志", @"精彩视频", @"查看地图", @"一周天气", @"我的收藏"];
    NSArray *images = @[@"iconfont-home", @"iconfont-xinwen", @"iconfont-lvxing", @"iconfont-x-mpg", @"iconfont-ditu", @"iconfont-tianqi", @"iconfont-qunfengcainixihuanchong"];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.textColor = [UIColor purpleColor];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
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

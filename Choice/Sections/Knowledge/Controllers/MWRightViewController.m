//
//  MWRightViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/9.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "MWRightViewController.h"
#import "RESideMenu.h"
#import "LoreViewController.h"
#import "SetUpViewController.h"
@interface MWRightViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation MWRightViewController

- (void)dealloc
{
    self.tableView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.backgroundColor = [UIColor orangeColor];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 2) / 2.0f, self.view.frame.size.width, 54 * 2) style:UITableViewStylePlain];
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

    LoreViewController *loreVC = [[[LoreViewController alloc] init] autorelease];
    UINavigationController *loreNC = [[[UINavigationController alloc] initWithRootViewController:loreVC] autorelease];
    SetUpViewController *setVC = [[[SetUpViewController alloc] init] autorelease];
    UINavigationController *setNC = [[[UINavigationController alloc] initWithRootViewController:setVC] autorelease];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:loreNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;

        case 1:
            [self.sideMenuViewController setContentViewController:setNC animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            //[self.sideMenuViewController setContentViewController: animated:YES];
            //[self.sideMenuViewController hideMenuViewController];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
       // cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"Home",@"设置"];
   // NSArray *images = @[@"iconfont-home", @"IconCalendar"];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.textColor = [UIColor purpleColor];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
 
    
    if (0 == row) {
        UIImageView *imaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-home"]];
        cell.accessoryView = imaView;
        [imaView release];
        
    }else{
        UIImageView *imaView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-set"]];
        cell.accessoryView = imaView2;
        [imaView2 release];
    }
    
    
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

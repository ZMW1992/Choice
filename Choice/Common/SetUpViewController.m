//
//  SetUpViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/14.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "SetUpViewController.h"
#import "StatementViewController.h"
#import "RESideMenu.h"
#import "Header.h"
@interface SetUpViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *headerBg;
}
@property (nonatomic, retain) NSMutableArray *dataSourceM;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *aview;
//@property (nonatomic, retain) UITableViewCell *tableViewCell;

@end

@implementation SetUpViewController

- (void)dealloc {
   
    self.tableView = nil;
    self.dataSourceM = nil;
    self.aview = nil;
   // self.tableViewCell = nil;
    [super dealloc];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"设置";
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xuanxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentRightMenuViewController:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
    
    
    // 创建UITableView对象
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
    self.tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor orangeColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"indntifier"];
    
    [self configureTableHeaderView];
    
}


// 设置TableHeaderView
- (void)configureTableHeaderView {
    
    // 设置tableHeaderView
    self.aview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSW, 200)];
    //view.backgroundColor = [UIColor yellowColor];
    _aview.clipsToBounds = YES;
    self.tableView.tableHeaderView = self.aview;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 200, 0);
    
    headerBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topview"]];
    headerBg.frame = _aview.frame;
    [_aview addSubview:headerBg];
    [headerBg release];
    [_aview release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"indntifier" forIndexPath:indexPath];
    
    switch (section) {
        case 0:
            if (0 == row) {
                cell.textLabel.text = @"清除缓存";
                cell.imageView.image = [UIImage imageNamed:@"iconfont-qingchuhuancun"];
            }
            break;
            
        case 1:
            if (0 == row) {
                cell.textLabel.text = @"夜间模式";
                cell.imageView.image = [UIImage imageNamed:@"iconfont-yejianmoshi"];
                
                UISwitch *swt = [[UISwitch alloc] init];
                [swt addTarget:self action:@selector(handSwitchBtn:) forControlEvents:(UIControlEventValueChanged)];
                cell.accessoryView = swt;
                [swt release];
            }
            break;
        case 2:
            if (0 == row) {
                cell.textLabel.text = @"免责声明";
                cell.imageView.image = [UIImage imageNamed:@"iconfont-mianzeshengmingicon"];
            }
            break;
            
        default:
            break;
    }
   
    return cell;
    
}

// 清除缓存
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    switch (section) {
        case 0:
            if (0 == row) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                NSString *path = [paths lastObject];
                NSString *str = [NSString stringWithFormat:@"缓存大小%.1fM", [self folderSizeAtPath:path]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:@"确定要清除缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 111;
                [alert show];
                [alert release];
            }
            break;
            case 2:
            if (0 == row) {
                StatementViewController *stateVC = [[StatementViewController alloc] init];
                stateVC.title = @"免责声明";
                [self.navigationController pushViewController:stateVC animated:YES];
                [stateVC release];
            }
            break;
        default:
            break;
    }
}

//alertView 的代理方法
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //根据alertView 的tag确定alert
    if (alertView.tag == 111) {
        //如果点击取消 什么事情也不做
        if (buttonIndex == alertView.cancelButtonIndex) {
            ;
        }
        //如果点击确定 清除缓存
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *path = [paths lastObject];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
            for (NSString *p in files) {
                NSError *error;
                NSString *Path = [path stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                }
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除缓存成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
            
        }
    }
}
//计算单个文件大小
- (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

// 夜间模式//控制屏幕的透明度
- (void)handSwitchBtn:(UISwitch *)sender {
    //NSLog(@"天黑了");
    if (sender.on == NO) {
        self.view.window.alpha = 1.0;
    }else{
        self.view.window.alpha = 0.6;
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

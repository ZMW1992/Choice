//
//  CollectionViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/15.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "CollectionViewController.h"
#import "RESideMenu.h"
#import "DataBase.h"
#import "BGNews.h"
#import "TravelNoteModel.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#import "DetailTravelViewController.h"
#import "BGNewsDetailViewController.h"
#import "CollectionViewCell.h"
#import "Header.h"
#import "VideoPlayController.h"


@interface CollectionViewController ()
{
    
    //    创建bool 数组
    BOOL _isOpen[3];
   
}
@property (nonatomic, retain) NSMutableArray *newsArr;
@property (nonatomic, retain) NSMutableArray *travelArr;
@property (nonatomic, retain) NSMutableArray *videoArray;
@property (nonatomic, retain) UIView *aview; // 区头视图
@end


extern NSMutableArray *idArray;
extern NSString *fromoneview;


@implementation CollectionViewController

- (void)dealloc
{
    self.newsArr = nil;
    self.travelArr = nil;
    self.aview = nil;
    self.videoArray = nil;
    [super dealloc];
}


#pragma mark - 懒加载
- (NSMutableArray *)newsArr {
    if (!_newsArr) {
        NSArray *group = [[DataBase shareDataBase] selectAllNews];
        self.newsArr = [NSMutableArray arrayWithArray:group];
    }
    return [[_newsArr retain] autorelease];
}

- (NSMutableArray *)travelArr {
    if (!_travelArr) {
        NSArray *group = [[DataBase shareDataBase] selectAllTravelNotes];
        self.travelArr = [NSMutableArray arrayWithArray:group];
    }
    return [[_travelArr retain] autorelease];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [idArray removeAllObjects];
    //[self.tableView reloadData];
   
}


#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];
    
    
    NSArray *group = [[DataBase shareDataBase] selectAllVideo];
    self.videoArray = [NSMutableArray arrayWithArray:group];
    
    self.title = @"我的收藏";
    
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xuanxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentRightMenuViewController:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
    
    
    
    //注册自定义CELL
    [self.tableView registerClass:[CollectionViewCell class] forCellReuseIdentifier:@"COCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    当程序运行时_isOpen为no,全部区域行为0
    if (_isOpen[section] == NO)
    {
        return 0;
    }
    
    if (section == 0) {
        
        if (_isOpen[0] == YES) {
            return self.newsArr.count;
        }else {
            return 0;
        }
        
        
    }else if (section == 1 ) {
        
        if (_isOpen[1] == YES) {
            return self.travelArr.count;
        }else {
            return 0;
        }
    }else if (section == 2) {
        if (_isOpen[2] == YES) {
            return self.videoArray.count;
            
        }else {
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

// 自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.aview = [[UIView alloc] init];
    _aview.backgroundColor = [UIColor lightGrayColor];
    
    
    
    UIButton *openBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    openBtn.tag = section;
    openBtn.frame = CGRectMake(kSW-50, 7, 40, 30);
    [openBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
    [openBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zhankaianniu"] forState:UIControlStateNormal];
    [_aview addSubview:openBtn];
    
    if (_isOpen[section] == YES) {
        // 让按钮旋转90度
        openBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 34)];
    titleLab.textColor = [UIColor whiteColor];
    if (0 == section) {
        titleLab.text = @"资讯播报";
    } else if (1 == section) {
       titleLab.text = @"旅行日志";
    }else{
        titleLab.text = @"精彩视频";
    }
    [_aview addSubview:titleLab];
    [titleLab release];
  
    return self.aview;
}

- (void)openClick:(UIButton *)sender {
    // 来改变当前点击按钮所在的某个区所对应的bool值的状态
    _isOpen[sender.tag] = !_isOpen[sender.tag];
    
    //[self.tableView reloadData];
    
    //  把所想要刷新的区加入到索引集合中
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sender.tag];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kSW*0.2 + 10;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"COCell" forIndexPath:indexPath];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.
            section) {
        case 0:
        {
            
            BGNews *newsModel = self.newsArr[indexPath.row];
            
            [cell initWithNewsModel:newsModel];
           
        }
            break;
        case 1: {
      
            TravelNoteModel *travelModel = self.travelArr[indexPath.row];
        
            [cell initWithTravelModel:travelModel];
         
        }
            break;
        case 2:{
            
            Video *videoModel = self.videoArray[indexPath.row];
            [cell initWithVideoModel:videoModel];
           
        }
       
            break;
        default:
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BGNewsDetailViewController *newsDetailVC = [[BGNewsDetailViewController alloc] init];
    
    DetailTravelViewController *detailTravelVC = [[DetailTravelViewController alloc] init];
    
    VideoPlayController *videoVC = [[VideoPlayController alloc] init];
    
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    switch (section) {
        case 0:
        {
            newsDetailVC.dataArrM = self.newsArr;
            newsDetailVC.currentNum = row;
            // 全局变量赋值
            fromoneview = @"collectionVC";
            [self.navigationController pushViewController:newsDetailVC animated:YES];
            [newsDetailVC release];
        }
            break;
            
            
        case 1:
        {
            detailTravelVC.MWIndex = row;
            TravelNoteModel *model = self.travelArr[row];
          
            for (TravelNoteModel *model in self.travelArr) {
                NSString *str = [NSString stringWithFormat:@"%@", model.ID];
                [idArray addObject:str];
            }
           
            detailTravelVC.MWID = model.ID;
            // 全局变量赋值
            fromoneview = @"collectionVC";
            [self.navigationController pushViewController:detailTravelVC animated:YES];
            [detailTravelVC release];
        }
            break;
            
            
        case 2:
        {
            Video *model = self.videoArray[row];
            videoVC.aID = model.rsId;
            videoVC.moduleID = model.modulesId;
            
            // 全局变量赋值
            fromoneview = @"collectionVC";
            [self.navigationController pushViewController:videoVC animated:YES];
            [videoVC release];
            
        }
            break;
        default:
            break;
    }
    
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        switch (indexPath.section) {
            case 0:
            {
                // 1. 先删除数据库中的数据
                BGNews *newsModel = self.newsArr[indexPath.row];
                [[DataBase shareDataBase] deleteNewsByID:newsModel.ID];
                // 2.再修改数据源
                [self.newsArr removeObjectAtIndex:indexPath.row];
                //
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
                
            case 1:
            {
                // 1. 先删除数据库中的数据
                TravelNoteModel *travelModel = self.travelArr[indexPath.row];
                [[DataBase shareDataBase] deleteTravelNoteByID:travelModel.ID];
                // 2.再修改数据源
                [self.travelArr removeObjectAtIndex:indexPath.row];
                //
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
                
            case 2:
            {
                // 1. 先删除数据库中的数据
                Video *videoModel = self.videoArray[indexPath.row];
                [[DataBase shareDataBase] deleteVideoByID:videoModel.rsId];
                
                // 2.再修改数据源
                [self.videoArray removeObjectAtIndex:indexPath.row];
                //
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
                
            default:
                break;
        }
             
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }   
}



@end

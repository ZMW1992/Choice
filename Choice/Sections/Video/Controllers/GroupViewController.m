//
//  GroupViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/11.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "GroupViewController.h"
#import "AFNetworking.h"
#import "Video.h"
#import "GroupCell.h"
#import "GroupHeadView.h"
#import "GroupDetailViewController.h"
#import "TagCell.h"
#import "SearchController.h"
#import "Header.h"
#define kGroupCell @"groupcell"
#define kGroupHead @"grouphead"
#define kLabel @"aLabel"



@interface GroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain)NSMutableArray *dataSource;   //储存分类对象
@property (nonatomic, retain)UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *dataArray;  //储存热词

@property (nonatomic, retain) NSMutableArray *widthsM; // 存储每个item的宽度
@end

@implementation GroupViewController

- (void)dealloc {
    self.dataSource = nil;
    self.collectionView = nil;
    
    [super dealloc];
}


- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    
    return [[_dataSource retain]autorelease];
}







- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化数据源
    self.dataArray = [NSMutableArray array];
    self.widthsM = [NSMutableArray array];
    
    [self readDataFromNetWork];
    [self configureCollectionView];
    
    
    [self loadDataAndShow];
    // Do any additional setup after loading the view.
}




- (void)readDataFromNetWork{
    NSString *url = @"http://115.28.54.40:8080/beautyideaInterface/api/v1/modules/getModules?imieId=E20B65E58C77354FE86190E4091ABFB0";
    
    // 网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    __block typeof (self)weakSelf = self;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        
        NSArray *array = responseObject[@"modules"];
        
        for (NSDictionary *dic in array) {
            // 创建model对象
            Video *video = [[Video alloc]init];
            // 使用KVC赋值
            [video setValuesForKeysWithDictionary:dic];
            
            [weakSelf.dataSource addObject:video];
            
            [video  release];
        }
        
        // 让集合视图对象重走数据源方法
        [weakSelf.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];

}



// 请求数据
- (void)loadDataAndShow {
    
    NSURL *url = [NSURL URLWithString:@"http://115.28.54.40:8080/beautyideaInterface/api/v1/user_tag/get_tag"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[@"deviceModel=H30-U10&username=&plamformVersion=4.2.2&deviceName=HUAWEI&plamform=Android&imieId=E20B65E58C77354FE86190E4091ABFB0" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        
        //该任务在子线程中进行,如果想刷新UI,需要回到主线程
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary *d1 =  dict[@"request_value"];
            NSArray *arr =  d1[@"tag"];

            
            // 遍历数组
//            for (NSDictionary *aDict in arr) {
            for (int i = 0; i < arr.count; i++) {
                
                
                
                NSDictionary *aDict = arr[i];
                Video *model = [[Video alloc] initWithDictionary:aDict];
                
                
                
                UILabel *aLabel = [[UILabel alloc]init];
                aLabel.text = model.tagName;
                [aLabel sizeToFit];
                CGFloat w = aLabel.bounds.size.width + 20;
                
                
                NSString *key = [NSString stringWithFormat:@"%d", i];
                
                NSNumber *value = [NSNumber numberWithFloat:w];
                
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:value forKey:key];
                
                
                
                [self.widthsM addObject:dictionary];

                
                [self.dataArray addObject:model];
                
                [model release];
                [aLabel release];
                
            }
            
           //     NSLog(@"%@", self.dataArray);
            
            // 回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
            });
            
        }
        
    }];
    // 执行任务
    [dataTask resume];
  
}



// 配置CollectionView的方法
- (void)configureCollectionView {
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    
    // 表头大小
    flowLayout.headerReferenceSize = CGSizeMake(0, 30);
    
    // 设置item大小
    flowLayout.itemSize = CGSizeMake((kSW-20)*0.333, 130);
    
    
    // 缩进量
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    
    // 创建UICollectionView对象
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, kSW-20, kSH-54) collectionViewLayout:flowLayout];
    [flowLayout release];
    
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:collectionView];
    // 给属性_collectionView赋值
    self.collectionView = collectionView;
    
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView release];
    
    // 注册第二分区cell
    [self.collectionView registerClass:[GroupCell class] forCellWithReuseIdentifier:kGroupCell];
    
    // 注册
    // 注册第一分区的cell
    [self.collectionView registerClass:[TagCell class] forCellWithReuseIdentifier:kLabel];
    
    // 注册表头
    [collectionView registerClass:[GroupHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGroupHead];
   
}


#pragma mark - 数据源代理方法
// 返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
    
}


// 返回item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.dataArray.count;
    }else{
   
    return self.dataSource.count;
    
    }
    
    
    
    
}



// 给不同分区的cell赋值
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLabel forIndexPath:indexPath];
        
        // 取出数组对应位置的元素
        Video *video = self.dataArray[indexPath.row];
        
        [cell configureTagLabelWithVideo:video];
        
        
        return cell;
    }else{
     
        
        GroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGroupCell forIndexPath:indexPath];
        
        // 取出数组对应位置的元素
        Video *video = self.dataSource[indexPath.row];
        
        [cell setValueForSubviewsWithVideo:video];
      return cell;
    }
    
  
}



// 重用表头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    [kind isEqualToString:UICollectionElementKindSectionHeader];
    GroupHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGroupHead forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        view.headLabel.text = [NSString stringWithFormat:@"  热词"];
        view.backgroundColor = [UIColor colorWithRed:233/255.0 green:225/255.0 blue:178/255.0 alpha:0.5];
    } else {
        view.headLabel.text = [NSString stringWithFormat:@"  分类"];
       // view.backgroundColor = [UIColor yellowColor];
    }
    

    return  view;
}



// 选中item触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        
        SearchController *searchVC = [[SearchController alloc] init];
        Video *vid = self.dataArray[indexPath.row];
  
        
        searchVC.hotWords = vid.tagName;
        
        
        [self.navigationController pushViewController:searchVC animated:YES];
        
        [searchVC release];
        
        
        
    } else {
        
        GroupDetailViewController *detailVC = [[GroupDetailViewController alloc] init];
        
        
        
        Video *video = self.dataSource[indexPath.row];
        
        detailVC.aID = video.modulesId;
        
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
        [detailVC release];
        
        
    }

}




#pragma mark - UICollectionViewDelegateFlowLayout 方法
// 动态返回item大小的方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (self.widthsM) {
            NSString *s = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            
            NSDictionary *dict = self.widthsM[indexPath.row];
            NSNumber *w = dict[s];
            
            return CGSizeMake([w floatValue], 30);
        } else {
            return CGSizeMake(10, 30);
        }
        
    }else{
       
        return CGSizeMake(100, 100);
    }
    
    
}


// 动态设置分区缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    if (section == 0) {
        return UIEdgeInsetsMake(10, 0, 10, 0);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
  
}


// 动态设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (0 == section) {
        return 10;
    }else{
        return 0;
        
    }
   
}

// 动态设置列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (0 == section) {
        return 10;
    }else{
        return 0;
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

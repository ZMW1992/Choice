//
//  DetailTravelViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "DetailTravelViewController.h"
#import "Header.h"
#import "SVProgressHUD.h"
#import "SectionTimeModel.h"
#import "RowDetailModel.h"
#import "HeaderViewModel.h"
#import "MWDetailTravelCellTableViewCell.h"
#import "MWPictureViewController.h"
#import "TravelDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "DataBase.h"
#import "TravelNoteModel.h"
#import "UMSocial.h"
@class CollectionViewController;

#define kImageOriginHight 200 // 自定义区头
#define kDetailTravelNotes @"http://api.breadtrip.com/trips/%@/waypoints/"
#define DISPATCH_TIME_NOW (0ull)
#define NSEC_PER_SEC 1000000000ull

extern NSMutableArray *idArray;
extern NSString *fromoneview;

@interface DetailTravelViewController ()<UITableViewDataSource , UITableViewDelegate, UIScrollViewDelegate, UMSocialUIDelegate>
{
    UIImageView *headerBg;
    UIImageView *topImageView;
    UIImageView *iconView;
    UILabel *titleLabel;
    UILabel *nameLabel;
    UIImageView *flightLabel;
    UILabel *flightText;
    UIImageView *sightLabel;
    UILabel *sightText;
    UIImageView *mileLabel;
    UILabel *mileText;
    
}
@property (nonatomic , retain) UITableView *tableView;

// 数据源
@property (nonatomic , retain) NSMutableArray *sectionArray;
@property (nonatomic , retain) NSMutableArray *rowArray;



@property (nonatomic , retain) NSTimer *timer;
@property (nonatomic, retain) UIBarButtonItem *right2;// 收藏按钮
@property (nonatomic, retain) UIBarButtonItem *right3;// 翻页按钮
@property (nonatomic, retain) UIImage *name; // 收藏按钮图片

@property (nonatomic, retain) MWDetailTravelCellTableViewCell *cell;

@end


@implementation DetailTravelViewController


- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        self.sectionArray = [NSMutableArray array];
    }
    return [[_sectionArray retain] autorelease];
}

- (NSMutableArray *)rowArray {
    if (!_rowArray) {
        self.rowArray = [NSMutableArray array];
    }
    return [[_rowArray retain] autorelease];
}


- (void)dealloc
{
   
    self.MWID = nil;
    self.sectionArray = nil;
    self.rowArray = nil;
    self.timer = nil;
    self.tableView = nil;
    self.right2 = nil;
    self.right3 = nil;
    self.modelArr = nil;
    self.name = nil;
    self.cell = nil;
    self.image = nil;
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
   // NSLog(@"id数组:%ld", idArray.count);
   // NSLog(@"下标:%ld", self.MWIndex);
    // 支持右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.backBarButtonItem = barItem;
    [barItem release];
    
    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui-2"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
//    self.navigationItem.leftBarButtonItem = left;
//    [left release];
    
    // 分享按钮
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-601"] style:(UIBarButtonItemStylePlain) target:self action:@selector(handleRight1Btn:)];
    
   // 收藏按钮
    NSArray *arr = [[DataBase shareDataBase] selectTravelNoteByID:self.MWID];
    
//    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [btn addTarget:self action:@selector(handleRight2Btn:) forControlEvents:(UIControlEventTouchUpInside)];
//    [btn setImage:[UIImage imageNamed:@"iconfont-iconfontshoucang"] forState:(UIControlStateNormal)];
//    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
  
    if (arr.count > 0) {
       self.name = [UIImage imageNamed:@"iconfont-iconfontshoucang"];
    }else{
        self.name = [UIImage imageNamed:@"star@2x"];
    }

    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithImage:self.name style:(UIBarButtonItemStylePlain) target:self action:@selector(handleRight2Btn:)];
    self.right2 = right2;
   // NSLog(@"%@", fromoneview);
    if ([fromoneview isEqualToString:@"collectionVC"]) {
        self.right2.enabled = NO;
    }
    fromoneview = nil;
   
    // 翻页按钮
//    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [btn addTarget:self action:@selector(handleRight3Btn:) forControlEvents:(UIControlEventTouchUpInside)];
//    [btn setImage:[UIImage imageNamed:@"iconfont-1-copy"] forState:(UIControlStateNormal)];
//    UIBarButtonItem *right3 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.right3.enabled = YES;
    
    UIBarButtonItem *right3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xiangxiaanniu"] style:(UIBarButtonItemStylePlain) target:self action:@selector(handleRight3Btn:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:right1, right2, right3, nil]];
    self.right3 = right3;
    if (self.MWIndex == idArray.count-1) {
        self.right3.enabled = NO;
    }
    [right1 release];
    [right2 release];
    [right3 release];
   
    [self setupTableView];
    
    // 注册cell
    [self.tableView registerClass:[MWDetailTravelCellTableViewCell class] forCellReuseIdentifier:@"detailCell"];
    // 注册自定义区头
    [self.tableView registerClass:[TravelDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[SDImageCache sharedImageCache] clearMemory];
}



// 分享
- (void)handleRight1Btn:(UIBarButtonItem *)sender {
    NSString *str = [NSString stringWithFormat:kDetailTravelNotes, idArray[self.MWIndex]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"569ca055e0f55a916100084a"
                                      shareText:str
                                     shareImage:self.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms, nil]
                                       delegate:self];
    
    
}


// 收藏
static int num = 0;
- (void)handleRight2Btn:(UIBarButtonItem *)sender {
    
    TravelNoteModel *model = self.modelArr[self.MWIndex];
    // 时间戳
    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter2 stringFromDate:date1];
    model.time = dateString;
    if (0 == num) {
        
        [[DataBase shareDataBase] insertTravelNote:model];
        
        [self.right2 setImage:[UIImage imageNamed:@"iconfont-iconfontshoucang"]];
        // 显示弹框效果
        [SVProgressHUD showSuccessWithStatus:@"已收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
        num = 1;
      
    }else{
        [[DataBase shareDataBase] deleteTravelNoteByID:model.ID];
        [SVProgressHUD showErrorWithStatus:@"已取消收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
        [self.right2 setImage:[UIImage imageNamed:@"star@2x"]];
        num = 0;
    }
 
}

// 下一页
- (void)handleRight3Btn:(UIBarButtonItem *)sender {

 
    if (self.MWIndex < idArray.count-1) {
         self.MWIndex++;
    }
   
    if (self.MWIndex == idArray.count-1) {
        
        
        sender.enabled = NO;
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最后一篇哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
        sleep(2);
        [alertView show];
        [alertView release];
    }
  
    [self paserData];
}



#pragma mark - 导航条左侧按钮
- (void)leftAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 定时器
- (void)timerAction:(NSTimer *)timer
{
    [SVProgressHUD dismiss];
    [self.timer invalidate];
}

#pragma mark - 创建tableView
- (void)setupTableView
{

    self.tableView = [[UITableView alloc] initWithFrame:kSB style:(UITableViewStyleGrouped)];
    self.tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];// 米黄色
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView release];
    
    
    [self configureTableHeaderView];
    
    
    [self paserData];
    
    
    [self initNavigationC];
}

// 设置TableHeaderView
- (void)configureTableHeaderView {
    
    // 设置tableHeaderView
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSW, 260)];
    //view.backgroundColor = [UIColor yellowColor];
    view.clipsToBounds = YES;
    self.tableView.tableHeaderView = view;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 260, 0);
    [view release];
    
    
    headerBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerpic"]];
    headerBg.frame = view.frame;
    [view addSubview:headerBg];
    [headerBg release];
    
    topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSW, 135)];
   // topImageView.backgroundColor = [UIColor blueColor];
    [headerBg addSubview:topImageView];
    [topImageView release];
    
    
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kSW/2-25, 110, 50, 50)];
    //iconView.backgroundColor = [UIColor greenColor];
    iconView.layer.cornerRadius = 25;
    iconView.layer.masksToBounds = YES;
    [headerBg addSubview:iconView];
    [iconView release];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, kSW-20, 20)];
   // nameLabel.backgroundColor = [UIColor cyanColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:12];
    [headerBg addSubview:nameLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, kSW-2*10, 50)];
    //titleLabel.backgroundColor = [UIColor yellowColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerBg addSubview:titleLabel];
    [titleLabel release];
    
    flightLabel = [[UIImageView alloc] initWithFrame:CGRectMake(30, 230, 40, 30)];
    flightLabel.image = [UIImage imageNamed:@"iconfont-chahangban"];
    [headerBg addSubview:flightLabel];
    [flightLabel release];
    
    flightText = [[UILabel alloc] initWithFrame:CGRectMake(70, 230, 30, 30)];
    [headerBg addSubview:flightText];
    [flightText release];
    
    
    sightLabel = [[UIImageView alloc] initWithFrame:CGRectMake(100, 230, 40, 30)];
    sightLabel.image = [UIImage imageNamed:@"iconfont-jingdian-2"];
    [headerBg addSubview:sightLabel];
    [sightLabel release];
    sightText = [[UILabel alloc] initWithFrame:CGRectMake(140, 230, 30, 30)];
    [headerBg addSubview:sightText];
    [sightText release];
    
    
    mileLabel = [[UIImageView alloc] initWithFrame:CGRectMake(180, 230, 40, 30)];
    mileLabel.image = [UIImage imageNamed:@"iconfont-xingshizonglicheng"];
    [headerBg addSubview:mileLabel];
    [mileLabel release];
    mileText = [[UILabel alloc] initWithFrame:CGRectMake(220, 230, 80, 30)];
    [headerBg addSubview:mileText];
    [mileText release];
    
  
}



-(void)initNavigationC{
    self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    
    [self scrollViewDidScroll:self.tableView];
    
}

// 导航条初始透明度为0
-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    
    UIColor *color=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:alpha];
    CGSize colorSize=CGSizeMake(1, 1);
    
    UIGraphicsBeginImageContext(colorSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    CGFloat alpha=scrollView.contentOffset.y/90.0f>1.0f?1:scrollView.contentOffset.y/90.0f;
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
 
}





// 解析数据
- (void)paserData {
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
   // [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *urlString = [NSString stringWithFormat:kDetailTravelNotes, idArray[self.MWIndex]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __block typeof(self)weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data != nil) {
            // 点击下一页清空数据
            [self.sectionArray removeAllObjects];
            [self.rowArray removeAllObjects];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          
            // 给表头视图赋值
            HeaderViewModel *headerModel = [[HeaderViewModel alloc] initWithDictionary:dic];
            
            titleLabel.text = [NSString stringWithFormat:@"%@\n旅行日期:%@~~%@", headerModel.titleName ,headerModel.first_day, headerModel.last_day];
            titleLabel.font = [UIFont fontWithName:@"CourierNewPSMT" size:14];
            titleLabel.numberOfLines = 0;
            //[titleLabel sizeToFit];
            [iconView sd_setImageWithURL:[NSURL URLWithString:headerModel.avatar_m]];
            [topImageView sd_setImageWithURL:[NSURL URLWithString:headerModel.icon]];
            nameLabel.text = headerModel.userName;
            
            
            flightText.text = [NSString stringWithFormat:@" %ld", (long)headerModel.flight];
            sightText.text = [NSString stringWithFormat:@" %ld", (long)headerModel.sights];
            mileText.text = [NSString stringWithFormat:@"%.1fKM", headerModel.mileage];
            
            [headerModel release];
           
            NSArray *arr = dic[@"days"];
            
            for (NSDictionary *mDic in arr) {
               
                SectionTimeModel *sectionModel = [[SectionTimeModel alloc] init];
                [sectionModel setValuesForKeysWithDictionary:mDic];
             
               
                for (NSDictionary *detailDic in mDic[@"waypoints"]) {
                    RowDetailModel *rowDetailModel = [[RowDetailModel alloc] init];
                    [rowDetailModel setValuesForKeysWithDictionary:detailDic];
                    
                    [weakSelf.rowArray addObject:rowDetailModel];
                    [rowDetailModel release];
                   
                }
                sectionModel.waypoints = [NSMutableArray arrayWithArray:self.rowArray];
          
               [weakSelf.sectionArray addObject:sectionModel];
               [sectionModel release];
            }
            
          [weakSelf.tableView reloadData];
            [SVProgressHUD dismiss];
        }
    }];

}

#pragma mark - tableView代理方法

// header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 40;
}


// 自定义表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TravelDetailHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    SectionTimeModel *timeModel = self.sectionArray[section];
   
    header.text = [NSString stringWithFormat:@"  %@ 第%@天", timeModel.date, timeModel.day];
  
    return header;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionTimeModel *timeModel = self.sectionArray[section];
   
    return timeModel.waypoints.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // 新方法
    SectionTimeModel *timeModel = self.sectionArray[indexPath.section];
    RowDetailModel *rowModel = timeModel.waypoints[indexPath.row];
    return rowModel.cellHeight;
  
    
    
//    SectionTimeModel *timeModel = self.sectionArray[indexPath.section];
//    return [MWDetailTravelCellTableViewCell getCellHeightWithModel:timeModel.waypoints[indexPath.row]];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MWDetailTravelCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];

    
//    static NSString *cellId = @"cellId";
//    MWDetailTravelCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[MWDetailTravelCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//    }
    
    SectionTimeModel *timeModel = self.sectionArray[indexPath.section];
    RowDetailModel *detailModel = timeModel.waypoints[indexPath.row];
    cell.detailModel = detailModel;
    cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];
    
    // 长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPressGesture];
    [longPressGesture release];
    
 
    return cell;
    
}

// cell长按手势
- (void)cellLongPress:(UIGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
       // CGPoint location = [recognizer locationInView:self.cell.photoImage];
       // NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        MWDetailTravelCellTableViewCell *cell = (MWDetailTravelCellTableViewCell *)recognizer.view;
        //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
        [cell becomeFirstResponder];
        self.cell = cell;
        UIMenuItem *itSave = [[UIMenuItem alloc] initWithTitle:@"保存图片" action:@selector(handleSaveCell:)];
        UIMenuItem *itCancell = [[UIMenuItem alloc] initWithTitle:@"取消" action:@selector(handleCancellCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itSave, itCancell,  nil]];
        [menu setTargetRect:cell.frame inView:self.tableView];
        [menu setMenuVisible:YES animated:YES];
        
        [itSave release];
        [itCancell release];
    }
}

// 保存
- (void)handleSaveCell:(UILongPressGestureRecognizer *)sender {
  
    
    UIImageWriteToSavedPhotosAlbum(self.cell.photoImage.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
}

// 保存到系统相册
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" message:@"保存失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [SVProgressHUD dismissWithDelay:1.0];
    }
}

// 取消
- (void)handleCancellCell:(id)sender {
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[SDImageCache sharedImageCache] clearMemory];
    NSInteger indexCount = 0;
    MWPictureViewController *pictureVC = [[MWPictureViewController alloc] init];
    SectionTimeModel *sectionModel = self.sectionArray[indexPath.section];
    RowDetailModel *rowModel = sectionModel.waypoints[indexPath.row];
    // cell存在图片
    if (![rowModel.photo isEqualToString:@""]) {
        // 算出这个cell是在存放有图片的cell数组中得索引
        for (int i = 0; i < indexPath.section; i++) {
           // SectionTimeModel *sectionModel2 = self.sectionArray[i];
            for (RowDetailModel *rowModel2 in sectionModel.waypoints) {
                if (![rowModel2.photo isEqualToString:@""]) {
                    indexCount++;
                }
            }
        }
        SectionTimeModel *sectionModel3 = self.sectionArray[indexPath.section];
        for (int j = 0; j < indexPath.row; j++) {
            RowDetailModel *rowModel3 = sectionModel3.waypoints[j];
            if (![rowModel3.photo isEqualToString:@""]) {
                indexCount++;
            }
        }
      
    }else{
        indexCount = 0;
    }
    pictureVC.secArray = self.sectionArray;
    pictureVC.index = indexCount;
    
    [self presentViewController:pictureVC animated:YES completion:nil];
    [pictureVC release];
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

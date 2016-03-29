//
//  MWPictureViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/11.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "MWPictureViewController.h"
#import "Header.h"
#import "SectionTimeModel.h"
#import "RowDetailModel.h"
#import "UIImageView+WebCache.h"

//#import "DetailTravelViewController.h"
@interface MWPictureViewController ()
@property (nonatomic , retain) UIImageView *imageView;
@property (nonatomic , retain) UIScrollView *scrollView;
@property (nonatomic , retain) NSMutableArray *photoArray;
@property (nonatomic , retain) UILabel *indexLab;
@property (nonatomic , assign) NSInteger shareIndex;
@property (nonatomic , retain) UIImage *photo;
@end

@implementation MWPictureViewController

- (void)dealloc
{
    self.secArray = nil;
    self.imageView = nil;
    self.scrollView = nil;
    self.photoArray = nil;
    self.indexLab = nil;
    self.photo = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self creatScrollew];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 25, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-fanhui-2"] forState:UIControlStateNormal];
    //    [backBtn setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    
}

- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)creatScrollew {
    self.scrollView = [[UIScrollView alloc] initWithFrame:kSB];
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    self.photoArray = [NSMutableArray array];
    NSMutableArray *textArr = [NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    for (SectionTimeModel *sectionModel in self.secArray) {
        for (RowDetailModel *detailModel in sectionModel.waypoints) {
            if (![detailModel.photo isEqualToString:@""]) {
                [self.photoArray addObject:detailModel.photo];
                [textArr addObject:detailModel.text];
                [timeArr addObject:detailModel.local_time];
            }
        }
    }
    for (int i = 0; i < self.photoArray.count; i++) {
        self.imageView = [UIImageView new];
        self.imageView.frame = CGRectMake(i*kSW, 0, kSW, kSH);
        self.imageView.userInteractionEnabled = YES;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photoArray[i]] placeholderImage:[UIImage imageNamed:@""]];
       
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        
        [self.imageView addGestureRecognizer:pinchGesture];
        [pinchGesture release];
   
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    [self.imageView release];
    
    // 图片索引Lab
    self.indexLab = [[UILabel alloc] initWithFrame:CGRectMake(i*kSW, 25, kSW, 30)];
    self.indexLab.textAlignment = NSTextAlignmentCenter;
    self.indexLab.textColor = [UIColor whiteColor];
        //        self.indexLab.font = [UIFont systemFontOfSize:15];
    self.indexLab.text = [NSString stringWithFormat:@"%d/%ld", i + 1 , self.photoArray.count];
    [self.scrollView addSubview:self.indexLab];
        
        // text Lab
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(kSW * i, self.scrollView.frame.size.height - 130, kSW - 10, 100)];
        textLab.text = textArr[i];
        textLab.numberOfLines = 0;
        textLab.textColor = [UIColor whiteColor];
        textLab.font = [UIFont systemFontOfSize:12];
        [self.scrollView addSubview:textLab];
        [textLab release];
        
        // 时间lab
        
        UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(kSW * i, self.scrollView.frame.size.height - 30, kSW, 30)];
        [self.scrollView addSubview:dateLab];
        
        UIImageView *clockView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 8.5, 13, 13)];
        clockView.image = [UIImage imageNamed:@"clock_gray"];
        [dateLab addSubview:clockView];
        [clockView release];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kSW, 30)];
        timeLab.text = timeArr[i];
        timeLab.textColor = [UIColor grayColor];
        timeLab.font = [UIFont systemFontOfSize:10];
        [dateLab addSubview:timeLab];
        [timeLab release];
        
  }
    
    // 设置偏移量
    self.scrollView.contentOffset = CGPointMake(kSW* self.index, 0);
    self.scrollView.contentSize = CGSizeMake(kSW * self.photoArray.count, kSH);
    
    // 按一个整页滑动
    self.scrollView.pagingEnabled = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture {
    //根据比例做放射变换,也是以上次视图为基准
    pinchGesture.view.transform = CGAffineTransformScale(pinchGesture.view.transform, pinchGesture.scale, pinchGesture.scale);
    //将上一次的缩放比例置为1
    pinchGesture.scale = 1;
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

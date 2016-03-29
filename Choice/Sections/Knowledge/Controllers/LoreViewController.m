//
//  LoreViewController.m
//  Choice
//
//  Created by dream2021 on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "LoreViewController.h"
#import "RESideMenu.h"
#import "Header.h"

#import <CoreLocation/CoreLocation.h>

@interface LoreViewController ()<CLLocationManagerDelegate>
//{
//    UIImageView *arrow;
//    UILabel *angel;
//    CLLocationManager *locManager;
//}
@property (nonatomic, retain) UIImageView *arrow;
@property (nonatomic, retain) UILabel *angel;
@property (nonatomic, retain) CLLocationManager *locManager;

@end

@implementation LoreViewController

- (void)dealloc
{
    self.arrow = nil;
    self.angel = nil;
    self.locManager = nil;

    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // UIImageView *imageView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kSW, kSH-64)] autorelease];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.image = [UIImage imageNamed:@"zhuyebeijing"];
    [self.view addSubview:imageView];
   
    // 指南针布局
    self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-dingwei"]];
    
    self.arrow.center = CGPointMake(kSW/2, kSW*2/3);
    [self.view addSubview:_arrow];
    
    
    self.angel = [[UILabel alloc] initWithFrame:CGRectMake(0.2*kSW, 0.31*kSW, kSW-2*0.2*kSW, 30)];
    self.angel.backgroundColor = [UIColor lightGrayColor];
    _angel.layer.cornerRadius = 7;
    _angel.layer.masksToBounds = YES;
    self.angel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_angel];
    
    
    self.locManager = [[CLLocationManager alloc] init];
    
    self.locManager.delegate = self;
    if ([CLLocationManager headingAvailable]) {
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locManager.headingFilter = kCLHeadingFilterNone;
        [_locManager startUpdatingHeading];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"设备指南针不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
       // arrow.alpha = 0.0f;
    }
    [_arrow release];
    [_angel release];
    [_locManager release];
 
    self.title = @"旅友";
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xuanxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentRightMenuViewController:)];
    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
   
}



#pragma 指南针
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    //每次要重置view的位置，才能保证图片每次偏转量正常，而不是叠加，指针方向正确。
    self.arrow.transform = CGAffineTransformIdentity;
    self.angel.text = [NSString stringWithFormat:@"angle:%.2f",newHeading.magneticHeading];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1 * M_PI*newHeading.magneticHeading/180.0);
    
    
    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(10, 50);
    _arrow.transform = transform;
    
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
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

//
//  MWMapViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/12.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "MWMapViewController.h"
#import <MapKit/MapKit.h>
#import "RESideMenu.h"
#import "AnnotationView.h"
#import "Header.h"
#import "PopoverView.h"
@interface MWMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

// 经度
@property (nonatomic , retain) UILabel *longitudeLabel;
@property (nonatomic , retain) UITextField *longitudeText;

// 维度
@property (nonatomic , retain) UILabel *latitudeLabel;
@property (nonatomic , retain) UITextField *latitudeText;

// 查询坐标
@property (nonatomic , retain) UIButton *locationButton;

// 地址输入框
@property (nonatomic , retain) UILabel *addressLabel;
@property (nonatomic , retain) UITextField *addressTest;

// 搜索
@property (nonatomic , retain) UIButton *addressButton;

// 地图view
@property (nonatomic , retain) MKMapView *mapView;

// 可以实现用户当前的经纬度信息
@property (nonatomic, retain) CLLocationManager *locManager;
@end

@implementation MWMapViewController

- (void)dealloc
{
    self.longitudeLabel = nil;
    self.longitudeText = nil;
    self.latitudeLabel = nil;
    self.latitudeText = nil;
    self.locationButton = nil;
    self.addressTest = nil;
    self.addressLabel = nil;
    self.addressButton = nil;
    self.mapView = nil;
    self.locManager = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureInterface];
    
    //self.title = @"地图";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xuanxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    
    //    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(presentRightMenuViewController:)];
    
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
   // self.navigationItem.rightBarButtonItem = rightBtn;
   // [rightBtn release];
    
    
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"模式" style:(UIBarButtonItemStylePlain) target:self action:@selector(handleRightBtn2:)];
    UIBarButtonItem *rightBtn3 = [[UIBarButtonItem alloc] initWithTitle:@"我的位置" style:(UIBarButtonItemStylePlain) target:self action:@selector(handleMyPointBtn3:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBtn, rightBtn2, rightBtn3, nil]];
    
    [rightBtn release];
    [rightBtn2 release];
    [rightBtn3 release];
    
    
    // 初始化
    self.locManager = [[CLLocationManager alloc] init];
    
    //请求定位服务
    if (![CLLocationManager locationServicesEnabled]) {
        //NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"定位功能已被禁止，请进行设置!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [_locManager requestWhenInUseAuthorization];
        
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        
        // 设置代理
        self.locManager.delegate = self;
        // 定位精度
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 判断是否是iOS8
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
           // NSLog(@"是iOS8以后的版本");
            // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
            [self.locManager requestWhenInUseAuthorization];
            [self.locManager startUpdatingLocation];
            
        }else{
            //NSLog(@"是iOS7以前的版本");
            [self.locManager startUpdatingLocation];
        }
       
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = 10.0;//十米定位一次
        self.locManager.distanceFilter = distance;
    }
    
    //[self.locManager requestAlwaysAuthorization];
    //    [self.locManager requestWhenInUseAuthorization];
    
   
    
    self.mapView.delegate = self;
    
     //标注自身位置
    [self.mapView setShowsUserLocation:YES];
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    
    [_locManager release];
    
    //添加大头针
    // [self addAnnotation];
    
  
}

#pragma mark - 配置页面
- (void)configureInterface {
    
    self.latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 69, 40, 30)];
    _latitudeLabel.text = @"纬度:";
    [self.view addSubview:_latitudeLabel];
    [_latitudeLabel release];
    
    self.latitudeText = [[UITextField alloc] initWithFrame:CGRectMake(70, 69, kSW*0.25, 30)];
    _latitudeText.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:_latitudeText];
    [_latitudeText release];
    
    
    
    self.longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 109, 40, 30)];
    _longitudeLabel.text = @"经度:";
    [self.view addSubview:_longitudeLabel];
    [_longitudeLabel release];
    
    self.longitudeText = [[UITextField alloc] initWithFrame:CGRectMake(70, 109, kSW*0.25, 30)];
    _longitudeText.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:_longitudeText];
    [_longitudeText release];
    
    
    
    self.locationButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _locationButton.frame = CGRectMake(kSW*0.156, 144, 80, 30);
    [_locationButton setTitle:@"坐标查询" forState:(UIControlStateNormal)];
    [_locationButton addTarget:self action:@selector(handleLocatinButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_locationButton];
    
    
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.5+10, 69, 140, 30)];
    _addressLabel.text = @"请输入地址:";
    [self.view addSubview:_addressLabel];
    [_addressLabel release];
    self.addressTest = [[UITextField alloc] initWithFrame:CGRectMake(kSW*0.5+10, 109, kSW*0.4375, 30)];
    _addressTest.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:_addressTest];
    [_addressTest release];
    
    
    self.addressButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _addressButton.frame = CGRectMake(kSW*0.625, 144, 80, 30);
    [_addressButton setTitle:@"地址查询" forState:(UIControlStateNormal)];
    [_addressButton addTarget:self action:@selector(handleAddressButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_addressButton];
    
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 174, kSW, kSH-174)]; // 初始化地图对象
    [_mapView setMapType:(MKMapTypeStandard)]; // 设置地图样式
    // _mapView.showsUserLocation = YES; // 实时位置,自动定位自己位置
    // _mapView.showsTraffic = YES; // 实时路况,显示路况拥堵情况
    [self.view addSubview:_mapView];
    [_mapView release];
}


//#pragma mark 添加大头针
//- (void)addAnnotation {
//    
//    CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake(34.83, 113.56);
//    AnnotationView *annotation1 = [[AnnotationView alloc]init];
//    annotation1.title = @"郑州蓝鸥";
//    annotation1.subtitle = @"梦之队";
//    annotation1.coordinate = location1;
//    annotation1.image = [UIImage imageNamed:@"666"];
//    [self.mapView addAnnotation:annotation1];
//    [annotation1 release];
//    
//}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[AnnotationView class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout = true;//允许交互点击
            annotationView.calloutOffset = CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation = annotation;
        annotationView.image = ((AnnotationView *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else {
        return nil;
    }
}


#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D loc = [userLocation coordinate];
    
    NSLog(@"获取我的位置");
    self.longitudeText.text = [NSString stringWithFormat:@"%.2f",loc.longitude];
    
    self.latitudeText.text = [NSString stringWithFormat:@"%.2f",loc.latitude];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [self.mapView setRegion:region animated:true];
    
    [self.locManager stopUpdatingLocation];
}


// 我的位置
- (void)handleMyPointBtn3:(UIBarButtonItem *)sender {
    NSLog(@"点了");
    // 初始化
    self.locManager = [[CLLocationManager alloc] init];
    [self.locManager requestWhenInUseAuthorization];
    
    [self.locManager startUpdatingLocation];
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance = 10.0;//十米定位一次
    self.locManager.distanceFilter = distance;
    //标注自身位置
    [self.mapView setShowsUserLocation:YES];
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.locManager release];
   
}


// 地图模式
- (void)handleRightBtn2:(UIBarButtonItem *)sender {
    
    CGPoint point = CGPointMake([UIScreen mainScreen].bounds.size.width-0.219*kSW , self.navigationController.navigationBar.frame.size.height + 20);
    NSArray *titles = @[@"标准" , @"卫星" , @"混合"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        if (index == 0) {
            self.mapView.mapType = MKMapTypeStandard;
        }else if (index == 1){
            self.mapView.mapType = MKMapTypeSatellite;
        }else{
            self.mapView.mapType = MKMapTypeHybrid;
        }
    };
    [pop show];
    [pop release];
}



- (void)handleLocatinButton:(UIButton *)sender {
    
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.latitudeText.text floatValue],[self.longitudeText.text floatValue]); // 获取要查询的位置2维坐标
    
    AnnotationView *annotation = [[AnnotationView alloc] initWithCoordinate:location];
    
    [self.mapView addAnnotation:annotation];
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000); // 设置要查询的位置,周围的范围(米)
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // 移除地图上(之前)所有的注释
        [_mapView removeAnnotations:_mapView.annotations];
        
        [self.mapView setRegion:region animated:YES]; // 地图上显示要设置的坐标
        
        // 设置大头针
        AnnotationView *annotationView = [[AnnotationView alloc] initWithCoordinate:location];
        
        // 把标注点MapLocation 对象添加到地图视图上,一但被调用,地图视图委托方法mapView: ViewForAnnotation:就会被回调
        [self.mapView addAnnotation:annotationView];
        [annotationView release];
        
    }];
    [annotation release];
    [loc release];
    [geocoder release];
}

- (void)handleAddressButton:(UIButton *)sender {
    
    // 判断输入框是否为空
    if (self.addressTest.text == nil || self.addressTest.text.length == 0) {
        
        return;
    }
    
    // 编译输入的内容
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder geocodeAddressString:_addressTest.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error || placemarks.count == 0) {
            
           // NSLog(@"地址不存在");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该地址不存在!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
           
        }
        
        if ([placemarks count] > 0) {
            
            [_mapView removeAnnotations:_mapView.annotations]; // 移除地图上的标注
        }
        
        // 取出placemarks中的第一个位置信息对象
        CLPlacemark *placeMark = placemarks.firstObject;
        
        // 在经纬度textFiled显示
        self.latitudeText.text = [NSString stringWithFormat:@"%.2f" , placeMark.location.coordinate.latitude];  // 纬度
        
        self.longitudeText.text = [NSString stringWithFormat:@"%.2f" , placeMark.location.coordinate.longitude]; // 经度
        // 取出位置坐标
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(placeMark.location.coordinate.latitude, placeMark.location.coordinate.longitude);
        
       // MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
        
       // [self.mapView setRegion:coordinateRegion animated:YES];
        
        // 设置大头针
        AnnotationView *annotationView = [[AnnotationView alloc] initWithCoordinate:location];
        annotationView.image = [UIImage imageNamed:@"666"];
        // 把标注点MapLocation 对象添加到地图视图上,一但被调用,地图视图委托方法mapView: ViewForAnnotation:就会被回调
        [self.mapView addAnnotation:annotationView];
        MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
        MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
        [self.mapView setRegion:region animated:YES];
        [annotationView release];
    }];
    [geocoder release];
}













- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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

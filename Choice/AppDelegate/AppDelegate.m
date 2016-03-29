//
//  AppDelegate.m
//  Choice
//
//  Created by dream2021 on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "AppDelegate.h"
#import "RESideMenu.h"

#import "LoreViewController.h"
#import "MWLeftViewController.h"
#import "MWRightViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "UMSocial.h"
#import "MZGuidePages.h"
// 全局变量
NSMutableArray *idArray;
NSString *fromoneview;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)dealloc {
    self.window = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [UMSocialData setAppKey:@"569ca055e0f55a916100084a"];
    
    // 全局变量初始化
    idArray = [[NSMutableArray alloc] init];
   
    LoreViewController *loreVC = [[LoreViewController alloc] init];
    UINavigationController *loreNC = [[UINavigationController alloc] initWithRootViewController:loreVC];
    MWLeftViewController *leftMVC = [[MWLeftViewController alloc] init];
    MWRightViewController *rightMVC = [[MWRightViewController alloc] init];
    RESideMenu *sideMVC = [[[RESideMenu alloc] initWithContentViewController:loreNC leftMenuViewController:leftMVC rightMenuViewController:rightMVC] autorelease];
    
    [loreVC release];
    [loreNC release];
    [leftMVC release];
    [rightMVC release];
    
    sideMVC.backgroundImage = [UIImage imageNamed:@"beijing"];
    sideMVC.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    //sideMVC.delegate = self;
    sideMVC.contentViewShadowColor = [UIColor blackColor];
    sideMVC.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMVC.contentViewShadowOpacity = 0.1;
    sideMVC.contentViewShadowRadius = 12;
    sideMVC.contentViewShadowEnabled = YES;
    
    
    
    self.window.rootViewController = sideMVC;

    [self.window makeKeyAndVisible];
    
    
    //用户引导图只运行一次
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *launched = [userDefaults objectForKey:@"launched"];
    if (!launched)
    {
        //[self guidePages];
        launched = @"YES";
        [userDefaults setObject:launched forKey:@"launched"];
        [userDefaults synchronize];
    }
    

    
#pragma mark - 网络监测
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    //厚度
    [SVProgressHUD setRingThickness:6];
    //1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //当网络状态改变后，会调用这个方法
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请检查您当前的网路" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert1 show];
                [alert1 release];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"好痛苦！断网了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert2 show];
                [alert2 release];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [SVProgressHUD showSuccessWithStatus:@"3G/4G网络"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [SVProgressHUD showSuccessWithStatus:@"WIFI"];
            }
                break;
            default:
                break;
        }
        
    }];
    
    //3 开始监测
    [manager startMonitoring];    
    
    
    NSURLCache *cathe = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:20*1024*1024 diskPath:nil];
    [NSURLCache setSharedURLCache:cathe];
    [cathe release];
    
    
    return YES;
}

- (void)guidePages
{
    //数据源
    NSArray *imageArray = @[ @"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg" ];
    
    //  初始化方法1
    MZGuidePages *mzgpc = [[MZGuidePages alloc] init];
    mzgpc.imageDatas = imageArray;
    __block typeof(MZGuidePages) *weakMZ = mzgpc;
    mzgpc.buttonAction = ^{
        [UIView animateWithDuration:2.0f
                         animations:^{
                             weakMZ.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [weakMZ removeFromSuperview];
                         }];
    };
    
    //  初始化方法2
    //    MZGuidePagesController *mzgpc = [[MZGuidePagesController alloc]
    //    initWithImageDatas:imageArray
    //                                                                            completion:^{
    //                                                                              NSLog(@"click!");
    //
    
    //要在makeKeyAndVisible之后调用才有效
    [self.window addSubview:mzgpc];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

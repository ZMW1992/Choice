//
//  BGNewsDetailViewController.m
//  Choice
//
//  Created by dream2021 on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "BGNewsDetailViewController.h"
#import "BGNewsDetailView.h"
#import <AVFoundation/AVFoundation.h>
#import "BGAudioView.h"
#import "Header.h"
#import "BGNews.h"
#import "DataBase.h"
#import "SVProgressHUD.h"

extern NSString *fromoneview;

@interface BGNewsDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) AVPlayerItem *playerItem;

@property (nonatomic, retain) BGAudioView *audioView;

// 收藏按钮
@property (nonatomic, retain) UIButton *btn;


@end

@implementation BGNewsDetailViewController

- (void)dealloc {
    self.player = nil;
    self.playerItem = nil;
    self.audioView = nil;
    self.btn = nil;
    [super dealloc];
}

#pragma mark - 懒加载
- (AVPlayer *)player {
    if (!_player) {
        self.player = [[[AVPlayer alloc] init] autorelease];
    }
    return [[_player retain] autorelease];
}

- (BGAudioView *)audioView {
    if (!_audioView) {
        self.audioView = [[[BGAudioView alloc] initWithFrame:CGRectMake(0, kSH - 65, kSW, 65)] autorelease];
        _audioView.backgroundColor = [UIColor cyanColor];
        [_audioView.previousBtn addTarget:self action:@selector(aaPreviousBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_audioView.nextBtn addTarget:self action:@selector(aaNextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_audioView.playBtn addTarget:self action:@selector(aaPlayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_audioView.progressSlider addTarget:self action:@selector(aaSliderValueChange:) forControlEvents:UIControlEventValueChanged];

    }
    return [[_audioView retain] autorelease];
}

#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self playerItemWithArray];
    
    // 导航栏收藏按钮
    [self configureNavigationBar];
    
    // 收藏按钮关闭交互
    if ([fromoneview isEqualToString:@"collectionVC"]) {
        self.btn.enabled = NO;
        fromoneview = nil;
    }
    
}

- (void)addSubviews {
    // 详情视图
    BGNewsDetailView *view = [[BGNewsDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.model = self.dataArrM[self.currentNum];
    view.contentInset = UIEdgeInsetsMake(0, 0, 65, 0);
    view.delegate = self;
    view.bounces = NO;
    [self.view addSubview:view];
    [view release];
    
    // 播放视图
    [self.view addSubview:self.audioView];
}

/**
 *  导航栏收藏按钮
 */
static int ss = 0;
- (void)configureNavigationBar {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    if (0 == ss) {
        [btn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"star_select"] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(aaRightBarAction) forControlEvents:UIControlEventTouchUpInside];
    self.btn = btn;
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
    
  
    [bar release];
    
}


- (void)aaRightBarAction {
    BGNews *model = self.dataArrM[self.currentNum];
    
    // 时间戳
    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter2 stringFromDate:date1];
    model.time = dateString;
    
    if (0 == ss) {
       
        [[DataBase shareDataBase] insertNews:self.dataArrM[self.currentNum]];
        // 显示菊花效果
        [SVProgressHUD showSuccessWithStatus:@"已收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
        
        [self.btn setImage:[UIImage imageNamed:@"star_select"] forState:UIControlStateNormal];
        ss = 1;
    } else {
        //BGNews *model = self.dataArrM[self.currentNum];
        [[DataBase shareDataBase] deleteNewsByID:model.ID];
        
        [SVProgressHUD showErrorWithStatus:@"已取消收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
        
        [self.btn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        ss = 0;
    }
    
}




#pragma mark - 按钮响应事件
- (void)aaPreviousBtnAction:(UIButton *)sender {
    self.currentNum--;
//    if (self.currentNum == 0) {
//        sender.enabled = NO;
//    }
    [self playerItemWithArray];
}

- (void)aaNextBtnAction:(UIButton *)sender {
    self.currentNum++;
//    if (self.currentNum == self.dataArrM.count - 1) {
//        sender.enabled = NO;
//    }
    [self playerItemWithArray];
}

- (void)aaPlayBtnAction:(UIButton *)sender {
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.player play];
    } else {
        [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.player pause];
    }
    
    sender.selected = !sender.selected;
}

- (void)aaSliderValueChange:(UISlider *)slider {
    
    [self.player pause];
    
    [self.audioView.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    
    CGFloat f = slider.value * CMTimeGetSeconds(self.playerItem.duration);
    switch (self.playerItem.status) {
        case AVPlayerItemStatusReadyToPlay:
        {
            [self.player seekToTime:CMTimeMake(f, 1) completionHandler:^(BOOL finished) {
                [self.player play];
                [self.audioView.playBtn setTitle:@"暂停" forState:UIControlStateNormal];
            }];
        }
            break;
            
        default:
            break;
    }
    
}

/**
 *  播放内容
 */
- (void)playerItemWithArray {
    
    [self addSubviews];
    
    self.audioView.progressSlider.value = 0;
    self.audioView.leftLab.text = @"00:00";
    self.audioView.rightLab.text = @"--:--";
    
    // 获取模型数据
    BGNews *model = self.dataArrM[self.currentNum];
    ss = 0;
    if ([[DataBase shareDataBase] selectNewsByID:model.ID].count > 0) {
        ss = 1;
    }
    // 1. 初始化
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:model.post_mp]];
    
    // 2. 取代当前playerItem
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    // 3. 播放
    [self.player play];
    
    
    // 4. 监控播放时长变化
    /**
     *  可以更新一个UI，比如进度条的当前时间等
     *
     *  interval       响应的间隔时间（每秒都响应）
     *  queue          队列，传NULL，代表在主线程执行
     */
    
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentTime = CMTimeGetSeconds(time);
        //        NSLog(@"%.2f", currentTime);
        CGFloat totalTime = CMTimeGetSeconds(self.playerItem.duration);
        //        NSLog(@"%.2f", totalTime);
        
        if (totalTime > 0) {
            
            self.audioView.leftLab.text = [NSString stringWithFormat:@"%02d:%02d", (int)currentTime/60, (int)currentTime%60];
            self.audioView.rightLab.text = [NSString stringWithFormat:@"%02d:%02d", (int)totalTime/60, (int)totalTime % 60];
            [self.audioView.progressSlider setValue:currentTime / totalTime];
        }
        
    }];
    
    [self.audioView.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    // 前进,后退按钮失效判断
    self.audioView.previousBtn.enabled = self.currentNum == 0 ? NO : YES;
    self.audioView.nextBtn.enabled = (self.currentNum == self.dataArrM.count-1) ? NO : YES;
    

    self.audioView.playBtn.selected = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.player pause];
    self.player = nil;
    
}


static CGFloat currentY = -64;

#pragma mark - 滚动视图代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    NSLog(@"%f", currentY);
    if (currentY < scrollView.contentOffset.y) {
        [UIView animateWithDuration:0.7 animations:^{
            self.audioView.frame = CGRectMake(0, kSH, kSW, 65);
        }];
        
    } else {
        [UIView animateWithDuration:0.7 animations:^{
            self.audioView.frame = CGRectMake(0, kSH-65, kSW, 65);
        }];
    }
    currentY = scrollView.contentOffset.y;
}







@end

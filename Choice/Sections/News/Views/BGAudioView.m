//
//  BGAudioView.m
//  Choice
//
//  Created by dream2021 on 16/1/12.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "BGAudioView.h"

#define kSW [UIScreen mainScreen].bounds.size.width
#define kSH [UIScreen mainScreen].bounds.size.height

// 按钮的宽度
#define kBtnW 35
#define kBtnH 35

@implementation BGAudioView

- (void)dealloc {
    self.previousBtn = nil;
    self.playBtn = nil;
    self.nextBtn = nil;
    self.progressSlider = nil;
    self.leftLab = nil;
    self.rightLab = nil;
    [super dealloc];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addAllSubviews];
    }
    return self;
}


- (void)addAllSubviews {
    // 进度条
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, 5, kSW - 120, 15)];
    _progressSlider.minimumValue = 0;
    _progressSlider.maximumValue = 1;
    [_progressSlider setThumbImage:[UIImage imageNamed:@"thumbSlider"] forState:UIControlStateHighlighted];
    [self addSubview:self.progressSlider];
    [self.progressSlider release];
    
    
    self.leftLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 50, 15)];
    _leftLab.textColor = [UIColor lightGrayColor];
    _leftLab.textAlignment = NSTextAlignmentCenter;
    _leftLab.font = [UIFont systemFontOfSize:12.0];
    _leftLab.text = @"00:00";
    [self addSubview:self.leftLab];
    [self.leftLab release];
    
    
    self.rightLab = [[UILabel alloc] initWithFrame:CGRectMake(kSW - 50 - 5, 5, 50, 15)];
    _rightLab.textColor = [UIColor lightGrayColor];
    _rightLab.textAlignment = NSTextAlignmentCenter;
    _rightLab.font = [UIFont systemFontOfSize:12.0];
    _rightLab.text = @"--:--";
    [self addSubview:self.rightLab];
    [self.rightLab release];
    
    
    self.previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _previousBtn.frame = CGRectMake(kSW*0.25 - kBtnW*0.5, 25, kBtnW, kBtnH);
    [_previousBtn setImage:[UIImage imageNamed:@"previous1"] forState:UIControlStateNormal];
    [_previousBtn setImage:[UIImage imageNamed:@"previous2"] forState:UIControlStateHighlighted];
    [self addSubview:self.previousBtn];
    [self.previousBtn release];
    
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(kSW*0.75 - kBtnW*0.5, 25, kBtnW, kBtnH);
    [_nextBtn setImage:[UIImage imageNamed:@"next1"] forState:UIControlStateNormal];
    [_nextBtn setImage:[UIImage imageNamed:@"next2"] forState:UIControlStateHighlighted];
    [self addSubview:self.nextBtn];
    [self.nextBtn release];
    
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake((kSW - kBtnW)*0.5, 25, kBtnW, kBtnH);
    [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self addSubview:self.playBtn];
    [self.playBtn release];
}


@end

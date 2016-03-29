//
//  BGAudioView.h
//  Choice
//
//  Created by dream2021 on 16/1/12.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGAudioView : UIView

/**
 *  上一首
 */
@property (nonatomic, retain) UIButton *previousBtn;

/**
 *  播放 / 暂停
 */
@property (nonatomic, retain) UIButton *playBtn;

/**
 *  下一首
 */
@property (nonatomic, retain) UIButton *nextBtn;

/**
 *  进度条
 */
@property (nonatomic, retain) UISlider *progressSlider;

/**
 *  当前时长
 */
@property (nonatomic, retain) UILabel *leftLab;

/**
 *  总时长
 */
@property (nonatomic, retain) UILabel *rightLab;

@end

//
//  Play.h
//  Choice
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Play : NSObject


@property (nonatomic, copy) NSString *title;  // 标题
@property (nonatomic, copy) NSString *rsId;
@property (nonatomic, copy) NSString *thumbnail; // 图片
@property (nonatomic, assign) NSInteger viewCount;  // 播放次数

#pragma mark - 播放页面的model (系统重名)
@property (nonatomic, copy) NSString *descr;  // 描述


@property (nonatomic, copy) NSString *avatarHd;   // 头像链接
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *published;   // 评论时间
@property (nonatomic, copy) NSString *content;    // 评论内容

@property (nonatomic, assign) NSInteger moduleID;  // 分类号

@property (nonatomic, copy) NSString *player;  // 播放链接

@property (nonatomic, assign) NSInteger commentcount;  // 播放次数





//@property (nonatomic, copy) NSString *aColor;

@end

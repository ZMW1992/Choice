//
//  Video.h
//  Choice
//
//  Created by lanouhn on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject


#pragma mark - 推荐视频的model

@property (nonatomic, copy) NSString *title;   // 标题
@property (nonatomic, assign) NSInteger viewCount; // 浏览量
@property (nonatomic, assign) NSInteger commentcount; // 评论数
@property (nonatomic, assign) NSInteger duration;  // 时长
@property (nonatomic, copy) NSString *thumbnail;  // 缩略图
@property (nonatomic, copy) NSString *time;


@property (nonatomic, copy) NSString *rsId;


#pragma mark - 分类的model
@property (nonatomic, copy) NSString *modulesName; // 分类名
@property (nonatomic, copy) NSString *modulsCover; // 分类icon


@property (nonatomic, assign) NSInteger modulesId; // 分类号


// 热词标签
// 自定义初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)dict;



#pragma mark - 热词的model
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *tagName;


//@property (nonatomic, copy) NSString *aColor;




@end

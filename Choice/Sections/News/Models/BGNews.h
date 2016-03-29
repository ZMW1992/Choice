//
//  BGNews.h
//  Choice
//
//  Created by dream2021 on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGNews : NSObject

@property (nonatomic, copy) NSString *ID;

/**
 *  日期
 */
@property (nonatomic, copy) NSString *post_date;

/**
 *  详情
 */
@property (nonatomic, copy) NSString *post_excerpt;

/**
 *  关键词
 */
@property (nonatomic, copy) NSString *post_keywords;

/**
 *  来源
 */
@property (nonatomic, copy) NSString *post_lai;

/**
 *  音频
 */
@property (nonatomic, copy) NSString *post_mp;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *post_title;

/**
 *  图片
 */
@property (nonatomic, copy) NSString *smeta;


@property (nonatomic, copy) NSString *time; // 时间戳




@end

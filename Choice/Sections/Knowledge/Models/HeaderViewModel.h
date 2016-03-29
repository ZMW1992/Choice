//
//  HeaderViewModel.h
//  Choice
//
//  Created by lanouhn on 16/1/12.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HeaderViewModel : NSObject
@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, copy) NSString *icon; // 国旗
@property (nonatomic, copy) NSString *avatar_m; // 头像
@property (nonatomic, copy) NSString *first_day;
@property (nonatomic, copy) NSString *last_day;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger flight;
@property (nonatomic, assign) NSInteger sights;
@property (nonatomic, assign) CGFloat mileage;

// 自定义初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

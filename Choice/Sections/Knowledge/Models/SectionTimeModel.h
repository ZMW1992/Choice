//
//  SectionTimeModel.h
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionTimeModel : NSObject
// 第几天
@property (nonatomic , assign) NSString *day;
@property (nonatomic , retain) NSString *date;

@property (nonatomic , retain) NSArray *waypoints;
@end

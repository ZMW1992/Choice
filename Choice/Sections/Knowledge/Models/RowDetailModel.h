//
//  RowDetailModel.h
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RowDetailModel : NSObject
@property (nonatomic , retain) NSString *photo;
@property (nonatomic , retain) NSString *text;
@property (nonatomic , retain) NSString *local_time;
@property (nonatomic, retain) NSDictionary *photo_info;

// 定义一个日期表示点击的cell是第几天的
@property (nonatomic , assign) NSInteger dayCount;


@property (nonatomic, assign) CGFloat cellHeight;

@end

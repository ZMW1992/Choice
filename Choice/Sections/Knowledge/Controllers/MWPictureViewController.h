//
//  MWPictureViewController.h
//  Choice
//
//  Created by lanouhn on 16/1/11.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWPictureViewController : UIViewController
// 创建一个数据接收数据
@property (nonatomic , retain) NSMutableArray *secArray;

// 图片索引
@property (nonatomic , assign) NSInteger index;
@end

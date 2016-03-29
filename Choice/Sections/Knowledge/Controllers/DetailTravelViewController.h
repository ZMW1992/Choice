//
//  DetailTravelViewController.h
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTravelViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *modelArr;

@property (nonatomic , assign) NSInteger MWIndex;

@property (nonatomic , copy) NSString *MWID;

@property (nonatomic , retain) UIImage *image;

@end

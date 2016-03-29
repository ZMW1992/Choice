//
//  WeatherCell.h
//  RoamProject
//
//  Created by zhumingwen on 15-9-5.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherMoedel;
@interface WeatherCell : UITableViewCell

@property (nonatomic, retain) UIImageView *imaView;
@property (nonatomic , retain) UILabel *citynm;
@property (nonatomic , retain) UILabel *days;
@property (nonatomic , retain) UILabel *week;
@property (nonatomic , retain) UILabel *lable1;
@property (nonatomic , retain) UIImageView *weatherImage;


@property (nonatomic , retain) UILabel *weather;
@property (nonatomic , retain) UILabel *lable2;
@property (nonatomic , retain) UILabel *temperature;
@property (nonatomic , retain) UILabel *lable3;
@property (nonatomic , retain) UILabel *wind;
@property (nonatomic , retain) UILabel *winp;

@property (nonatomic, retain) WeatherMoedel *model;
//+ (void)initWithModel:(WeatherMoedel *)model;

@end

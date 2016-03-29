//
//  WeatherCell.m
//  RoamProject
//
//  Created by zongqingle on 15-9-5.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "WeatherCell.h"
#import "WeatherMoedel.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation WeatherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.imaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tianqicell"]];
    //_imaView.frame = self.frame;
    //self.imaView.contentMode = UIViewContentModeScaleAspectFill;
    _imaView.frame = CGRectMake(0, 0, kScreenWidth, 185);
    self.imaView.alpha = 0.3;
    [self.contentView addSubview:_imaView];
    [_imaView release];
    
    self.citynm = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth / 4, 40)];
    self.citynm.textAlignment = NSTextAlignmentCenter;
    //self.citynm.backgroundColor = [UIColor orangeColor];
    self.citynm.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    [self.contentView addSubview:self.citynm];
    [self.citynm release];
    
    self.days = [[UILabel alloc] initWithFrame:CGRectMake(self.citynm.frame.origin.x + 5 + self.citynm.frame.size.width, 5, kScreenWidth / 2 - 20 , 40)];
    self.days.textAlignment = NSTextAlignmentCenter;
    self.days.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.days.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.days];
    [self.days release];
    
    self.week = [[UILabel alloc] initWithFrame:CGRectMake(self.days.frame.origin.x + 5 + self.days.frame.size.width, 5, kScreenWidth / 4 , 40)];
    self.week.textAlignment = NSTextAlignmentCenter;
    self.week.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.week.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.week];
    [self.week release];
    
    self.lable1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, kScreenWidth / 4, 40)];
    self.lable1.textAlignment = NSTextAlignmentCenter;
    self.lable1.text = @"天气";
    self.lable1.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.lable1.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.lable1];
    [self.lable1 release];
    
    
    self.weatherImage = [[UIImageView alloc] initWithFrame:CGRectMake(30 + kScreenWidth / 4, 50, 40, 40)];
    [self.contentView addSubview:self.weatherImage];
    [self.weatherImage release];
    
    
    self.weather = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 50, kScreenWidth / 2 - 15, 40)];
    self.weather.textAlignment = NSTextAlignmentLeft;
    self.weather.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.weather.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.weather];
    [self.weather release];
    
    self.lable2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 95, kScreenWidth / 4, 40)];
    self.lable2.textAlignment = NSTextAlignmentCenter;
    self.lable2.text = @"温度";
    self.lable2.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.lable2.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.lable2];
    [self.lable2 release];
    
    self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(self.lable2.frame.origin.x + self.lable1.frame.size.width + 5, 95, kScreenWidth / 4 * 3 - 15, 40)];
    self.temperature.textAlignment = NSTextAlignmentCenter;
    self.temperature.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.temperature.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.temperature];
    [self.temperature release];
    
    self.lable3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, kScreenWidth / 4, 40)];
    self.lable3.textAlignment = NSTextAlignmentCenter;
    self.lable3.text = @"风速";
    self.lable3.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.lable3.backgroundColor = [UIColor brownColor];
    [self.contentView addSubview:self.lable3];
    [self.lable3 release];
    
    self.wind = [[UILabel alloc] initWithFrame:CGRectMake(self.citynm.frame.origin.x + 5 + self.citynm.frame.size.width, 140, kScreenWidth / 2 - 20, 40)];
    self.wind.textAlignment = NSTextAlignmentCenter;
    self.wind.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.wind.backgroundColor = [UIColor brownColor];
    [self.contentView addSubview:self.wind];
    [self.wind release];
    
    self.winp = [[UILabel alloc] initWithFrame:CGRectMake(self.days.frame.origin.x + 5 + self.days.frame.size.width, 140, kScreenWidth / 4, 40)];
    self.winp.textAlignment = NSTextAlignmentCenter;
    self.winp.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    //self.winp.backgroundColor = [UIColor brownColor];
    [self.contentView addSubview:self.winp];
    [self.winp release];
    
}


//+ (void)initWithModel:(WeatherMoedel *)model {
    
//    self.citynm.text = model.citynm;
//    self.days.text = model.days;
//    self.week.text = model.week;
//    self.weather.text = model.weather;
//    self.temperature.text = model.temperature;
//    self.wind.text = model.wind;
//    self.winp.text = model.winp;
    
//}

- (void)setModel:(WeatherMoedel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    
    self.citynm.text = model.citynm;
    self.days.text = model.days;
    self.week.text = model.week;
    self.weather.text = model.weather;
    self.temperature.text = model.temperature;
    self.wind.text = model.wind;
    self.winp.text = model.winp;
    
    if ([model.weather isEqualToString:@"晴"]) {
        self.weatherImage.image = [UIImage imageNamed:@"iconfont-qingtian"];
    }else if ([model.weather isEqualToString:@"阴"]) {
        self.weatherImage.image = [UIImage imageNamed:@"iconfont-duoyuncloudy"];
    }else if ([model.weather rangeOfString:@"多云"].location != NSNotFound) {
        self.weatherImage.image = [UIImage imageNamed:@"iconfont-6yintian"];
    }else if ([model.weather rangeOfString:@"雪"].location != NSNotFound) {
        self.weatherImage.image = [UIImage imageNamed:@"iconfont-zhenxue"];
    }else if ([model.weather rangeOfString:@"小雨"].location != NSNotFound) {
        self.weatherImage.image = [UIImage imageNamed:@"iconfont-xiaoyu"];
    }else if ([model.weather rangeOfString:@"中雨"].location != NSNotFound) {
        self.weatherImage.image = [UIImage imageNamed:@"iconfont-25xiaoyuzhongyu"];
    }else if ([model.weather rangeOfString:@"大雨"].location != NSNotFound) {
        self.weatherImage.image = [UIImage imageNamed:@"iconfont-dayu"];
    }
   
   
}











- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    self.model = nil;
    self.weatherImage = nil;
   
    [_imaView release];
    [_citynm release];
    [_days release];
    [_week release];
    [_lable1 release];
    [_weather release];
    [_lable2 release];
    [_temperature release];
    [_lable3 release];
    [_wind release];
    [_winp release];
    [super dealloc];
}
@end

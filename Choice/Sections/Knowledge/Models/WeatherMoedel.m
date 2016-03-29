//
//  WeatherMoedel.m
//  RoamProject
//
//  Created by zongqingle on 15-9-5.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "WeatherMoedel.h"

@implementation WeatherMoedel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"数据出现错误");
}

-(void)dealloc
{
    [_citynm release];
    [_days release];
    [_week release];
    [_weather release];
    [_temperature release];
    [_wind release];
    [_winp release];
    [super dealloc];
}

@end

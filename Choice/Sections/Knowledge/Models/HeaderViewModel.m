//
//  HeaderViewModel.m
//  Choice
//
//  Created by lanouhn on 16/1/12.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "HeaderViewModel.h"

@implementation HeaderViewModel


- (void)dealloc
{
    self.titleName = nil;
    self.icon = nil;
    self.avatar_m = nil;
    self.first_day = nil;
    self.last_day = nil;
    self.userName = nil;
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

// 自定义初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if (dict[@"covered_countries"] != nil) {
            NSArray *mArr = dict[@"covered_countries"];
            NSDictionary *mDic = mArr.firstObject;
            NSString *str = mDic[@"icon"];
            if (str) {
                
                    self.icon = mDic[@"icon"];
                }else{
                    self.icon = @"http://media.breadtrip.com/images/icons/passport/CN.png";
            }
        }
        
        self.flight = [[dict[@"poi_infos_count"] objectForKey:@"flight"] integerValue];
        self.sights = [[dict[@"poi_infos_count"] objectForKey:@"sights"] integerValue];
        self.mileage = [dict[@"mileage"] floatValue];
        
        
        self.titleName = dict[@"name"];
        self.userName = dict[@"user"];
        self.first_day = [NSString stringWithFormat:@"%@", dict[@"first_day"]];
        self.last_day = [NSString stringWithFormat:@"%@", dict[@"last_day"]];
        NSDictionary *uDic = dict[@"user"];
        if (uDic) {
            self.avatar_m = uDic[@"avatar_m"];
            self.userName = uDic[@"name"];
        }
        
    }
    return self;
}


@end

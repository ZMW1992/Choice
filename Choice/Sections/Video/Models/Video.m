//
//  Video.m
//  Choice
//
//  Created by lanouhn on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "Video.h"


@implementation Video

- (void)dealloc {
    
    self.title = nil;
    self.thumbnail = nil;
    
    self.modulesName = nil;
    self.modulsCover = nil;
    
    self.rsId = nil;
    self.tagName = nil;
    self.time = nil;
//    self.aColor = nil;
//    self.descr = nil;
//    
//    self.avatarHd = nil;
////    self.nickname = nil;
//    self.published = nil;
//    self.content = nil;
//    self.player = nil;
    [super dealloc];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"modules"]) {
        
        NSDictionary *aDic = value;
        self.modulesId = [aDic[@"modulesId"] integerValue];
        
     //   self.aColor = aDic[@"modulesColor"];
        

    }
    
}


-(instancetype)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
       
        self.tagName = dict[@"tagName"];
        self.flag = dict[@"flag"];
        

        self.rsId = [NSString stringWithFormat:@"%@", dict[@"rsId"]];

        
//        self.nickname = dict[@"nickname"];

    }
    return self;
    
}













@end













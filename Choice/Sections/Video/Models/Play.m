//
//  Play.m
//  Choice
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "Play.h"

@implementation Play

- (void)dealloc{
    self.title = nil;
    
    self.descr = nil;
    
    self.avatarHd = nil;
    self.nickname = nil;
    self.published = nil;
    self.content = nil;
    self.player = nil;
//    self.aColor = nil;
    [super dealloc];
}





- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"modules"]) {
        
        NSDictionary *aDic = value;
        self.moduleID = [aDic[@"modulesId"] integerValue];
        
 //       self.aColor = aDic[@"modulesColor"];
        
    }
    
    if ([key isEqualToString:@"users"]) {
        NSDictionary *dic = value;
        self.nickname = dic[@"nickname"];
        
        
        self.avatarHd = dic[@"avatarHd"];
    }
    
    
    if ([key isEqualToString:@"description"]) {
        
        self.descr = value;
    }
    
    
}







-(instancetype)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        self.title = dict[@"title"];
        
        self.descr = dict[@"description"];
        
 
        self.avatarHd = dict[@"avatarHd"];
        
     
        self.published = dict[@"published"];
        self.content = dict[@"content"];
        self.player = dict[@"player"];
    }
    return self;
    
}







@end

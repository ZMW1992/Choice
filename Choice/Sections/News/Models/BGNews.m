//
//  BGNews.m
//  Choice
//
//  Created by dream2021 on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "BGNews.h"

@implementation BGNews

- (void)dealloc {
    self.ID = nil;
    self.post_date = nil;
    self.post_excerpt = nil;
    self.post_keywords = nil;
    self.post_lai = nil;
    self.post_mp = nil;
    self.post_title = nil;
    self.smeta = nil;
    self.time = nil;
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end

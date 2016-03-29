//
//  RowDetailModel.m
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "RowDetailModel.h"

@implementation RowDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)dealloc
{
    [_photo release];
    [_text release];
    [_local_time release];
    [_photo_info release];
    [super dealloc];
}

@end

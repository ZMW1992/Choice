//
//  SectionTimeModel.m
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "SectionTimeModel.h"

@implementation SectionTimeModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)dealloc
{
   
    [_waypoints release];
    [_date release];
    [super dealloc];
    
}
@end

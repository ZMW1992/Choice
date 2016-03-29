//
//  TravelNoteModel.m
//  RoamProject
//
//  Created by lanouhn on 15-9-4.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "TravelNoteModel.h"

@implementation TravelNoteModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"day_count"]) {
        self.day_count = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"view_count"]) {
        self.view_count = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"first_day"]) {
        self.first_day = [NSString stringWithFormat:@"%@", value];
    }
    
    
    
}


- (void)dealloc
{
    [_ID release];
    [_first_day release];
    [_day_count release];
    [_name release];
    [_popular_place_str release];
    [_cover_image_default release];
    [_time release];
    [super dealloc];
}


@end

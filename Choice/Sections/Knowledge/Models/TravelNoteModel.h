//
//  TravelNoteModel.h
//  RoamProject
//
//  Created by lanouhn on 2016.
//  Copyright (c) 2015年 zhumingwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelNoteModel : NSObject

@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *popular_place_str;
@property (nonatomic , retain) NSString *cover_image_default;
@property (nonatomic , retain) NSString *view_count;
@property (nonatomic , retain) NSString *ID;
@property (nonatomic , retain) NSString *day_count;
@property (nonatomic , retain) NSString *first_day;
@property (nonatomic, retain) NSString *time;

@end

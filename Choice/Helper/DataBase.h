//
//  DataBase.h
//  Choice
//
//  Created by lanouhn on 16/1/15.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BGNews;
@class TravelNoteModel;
@class Video;
@interface DataBase : NSObject
/**
 *  单例
 */
+ (DataBase *)shareDataBase;

#pragma mark - 听闻

- (void)insertNews:(BGNews *)model;

- (NSArray *)selectAllNews;

- (NSArray *)selectNewsByID:(NSString *)ID;

- (void)deleteNewsByID:(NSString *)ID;

#pragma mark - 旅行

- (void)insertTravelNote:(TravelNoteModel *)travelModel;

- (NSArray *)selectAllTravelNotes;

- (NSArray *)selectTravelNoteByID:(NSString *)ID;

- (void)deleteTravelNoteByID:(NSString *)ID;


#pragma mark - 视频

- (void)insertVideo:(Video *)videoModel;

- (NSArray *)selectAllVideo;

- (NSArray *)selectVideoByID:(NSString *)ID;

- (void)deleteVideoByID:(NSString *)ID;





















@end

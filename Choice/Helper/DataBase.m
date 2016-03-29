//
//  DataBase.m
//  Choice
//
//  Created by lanouhn on 16/1/15.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "DataBase.h"
#import "BGNews.h"
#import "FMDB.h"
#import "TravelNoteModel.h"
#import "Video.h"
@interface DataBase ()
@property (nonatomic, retain) FMDatabase *db;
@end


@implementation DataBase

static DataBase *single = nil;
+ (DataBase *)shareDataBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[DataBase alloc] init];
        [single creatDataBase];
    });
    return single;
}

// 创建数据库
- (void)creatDataBase {
    //1.获取文件路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SQLite"];
    //2.创建SQLite文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //3.拼接数据库文件存储路径
    NSString *path = [filePath stringByAppendingPathComponent:@"db.sqlite"];
    //4.初始化数据库对象
    self.db = [FMDatabase databaseWithPath:path];
    //5.打开数据库
    BOOL isOpen = [_db open];
    if (!isOpen) {
        NSLog(@"数据库没有打开");
    }
    //6.创建表格
    [self createNewsTable];
    
    [self creatTravelNoteTable];
    
    [self creatVideoTable];
   
}

// 创建临时文件夹
- (NSString *)getCachesFile {
    // 1. 获取临时文件夹路径
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    // 2. 拼接子文件夹
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"Videos"];
    
    return filePath;
}

#pragma mark - 新闻
- (void)createNewsTable {
    [self.db executeUpdate:@"create table if not exists News(id text primary key, post_date text, post_excerpt text, post_keywords text, post_lai text, post_mp text, post_title text, smeta text, time text)"];
}
// 添加新闻数据
- (void)insertNews:(BGNews *)model {
    [self.db executeUpdate:@"insert into News (id, post_date, post_excerpt, post_keywords, post_lai, post_mp, post_title, smeta, time) values (?, ?, ?, ?, ?, ?, ?, ?, ?)", model.ID, model.post_date, model.post_excerpt, model.post_keywords, model.post_lai, model.post_mp, model.post_title, model.smeta, model.time];
    
}

- (NSArray *)selectAllNews {
    return [self getNewsGroupWith:@"select * from News"];
}

- (NSArray *)selectNewsByID:(NSString *)ID {
    NSString *str = [NSString stringWithFormat:@"select * from News where id = %@", ID];
    return [self getNewsGroupWith:str];
}

- (NSArray *)getNewsGroupWith:(NSString *)string {
    // 1. 开辟临时存储空间
    NSMutableArray *group = [NSMutableArray arrayWithCapacity:1];
    
    // 2. 查询所有数据
    FMResultSet *set = [self.db executeQuery:string];
    
    while ([set next]) {
        
        // 3. 获取每一行字段中对应的数据
        NSString *ID = [set stringForColumn:@"id"];
        NSString *post_date = [set stringForColumn:@"post_date"];
        NSString *post_excerpt = [set stringForColumn:@"post_excerpt"];
        NSString *post_keywords = [set stringForColumn:@"post_keywords"];
        NSString *post_lai = [set stringForColumn:@"post_lai"];
        NSString *post_mp = [set stringForColumn:@"post_mp"];
        NSString *post_title = [set stringForColumn:@"post_title"];
        NSString *smeta = [set stringForColumn:@"smeta"];
        NSString *time = [set stringForColumn:@"time"];
        // 4. 存储到模型对象里
        BGNews *model = [[BGNews alloc] init];
        model.ID = ID;
        model.post_date = post_date;
        model.post_excerpt = post_excerpt;
        model.post_keywords = post_keywords;
        model.post_lai = post_lai;
        model.post_mp = post_mp;
        model.post_title = post_title;
        model.smeta = smeta;
        model.time = time;
        // 5. 添加到数组里
        [group addObject:model];
        [model release];
    }
    return group;
}

- (void)deleteNewsByID:(NSString *)ID {
    [self.db executeUpdate:@"delete from News where id = ?", ID];
}


#pragma mark - 旅行
- (void)creatTravelNoteTable {
   
    [self.db executeUpdate:@"create table if not exists Travel(id text primary key, name text, imageURL text, time text)"];
    
}
// 插入旅行日志数据
- (void)insertTravelNote:(TravelNoteModel *)travelModel {
    if (travelModel.ID != nil && travelModel.name != nil && travelModel.cover_image_default != nil) {
        [self.db executeUpdate:@"insert into Travel (id, name, imageURL, time) values (?, ?, ?, ?)", travelModel.ID, travelModel.name, travelModel.cover_image_default, travelModel.time];
    }
}

- (NSArray *)selectAllTravelNotes {
    return [self getTravelGroupWith:@"select * from Travel"];
}

- (NSArray *)selectTravelNoteByID:(NSString *)ID {
    NSString *str = [NSString stringWithFormat:@"select * from Travel where id = %@", ID];
    return [self getTravelGroupWith:str];
}

- (void)deleteTravelNoteByID:(NSString *)ID {
    [self.db executeUpdate:@"delete from Travel where id = ?", ID];
}

- (NSArray *)getTravelGroupWith:(NSString *)string {
    // 1. 开辟临时存储空间
    NSMutableArray *group = [NSMutableArray arrayWithCapacity:1];
    // 2. 查询所有数据
    FMResultSet *set = [self.db executeQuery:string];
    while ([set next]) {
        // 3. 获取每一行字段中对应的数据
        NSString *ID = [set stringForColumn:@"id"];
        NSString *name = [set stringForColumn:@"name"];
        NSString *imageURL = [set stringForColumn:@"imageURL"];
        NSString *time = [set stringForColumn:@"time"];
         // 4. 存储到模型对象里
        TravelNoteModel *travelModel = [[TravelNoteModel alloc] init];
        travelModel.ID = ID;
        travelModel.name = name;
        travelModel.cover_image_default = imageURL;
        travelModel.time = time;
        // 5. 添加到数组里
        [group addObject:travelModel];
        [travelModel release];
        
        
    }
    return group;
}


#pragma mark - 视频

- (void)creatVideoTable {
    
    [self.db executeUpdate:@"create table if not exists Video(rsId text primary key, modulesId integer, title text, thumbnail text, time text)"];
    
}

// 插入数据
- (void)insertVideo:(Video *)video {
    if (video.rsId != nil) {
        [self.db executeUpdate:@"insert into Video (rsId, modulesId, title, thumbnail, time) values (?, ?, ?, ?, ?)", video.rsId, @(video.modulesId), video.title, video.thumbnail, video.time];
    }
}

- (NSArray *)selectAllVideo {
    return [self getVideoGroupWith:@"select * from Video"];
}

- (NSArray *)selectVideoByID:(NSString *)ID {
    NSString *str = [NSString stringWithFormat:@"select * from Video where rsId = %@", ID];
    return [self getVideoGroupWith:str];
}

- (void)deleteVideoByID:(NSString *)ID {
    [self.db executeUpdate:@"delete from Video where rsId = ?", ID];
}

- (NSArray *)getVideoGroupWith:(NSString *)string {
    // 1. 开辟临时存储空间
    NSMutableArray *group = [NSMutableArray arrayWithCapacity:1];
    // 2. 查询所有数据
    FMResultSet *set = [self.db executeQuery:string];
    while ([set next]) {
        // 3. 获取每一行字段中对应的数据
        NSString *rsId = [set stringForColumn:@"rsId"];
        int modulesId = [set intForColumn:@"modulesId"];
        NSString *title = [set stringForColumn:@"title"];
        NSString *thumbnail = [set stringForColumn:@"thumbnail"];
        NSString *time = [set stringForColumn:@"time"];
        // 4. 存储到模型对象里
        Video *model = [[Video alloc] init];
        model.rsId = rsId;
        model.modulesId = (NSInteger)modulesId;
        model.title = title;
        model.thumbnail = thumbnail;
        model.time = time;
        // 5. 添加到数组里
        [group addObject:model];
        [model release];
    }
    return group;
}























@end
